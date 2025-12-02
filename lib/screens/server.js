// server.js
import express from "express";
import admin from "firebase-admin";
import sgMail from "@sendgrid/mail";
import crypto from "crypto";
import bodyParser from "body-parser";
import dotenv from "dotenv";

dotenv.config(); // carga SENDGRID_API_KEY y FIREBASE_* desde .env o entorno

// Inicializa Firebase Admin con tu service account
admin.initializeApp({
  credential: admin.credential.cert(JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON))
});
const db = admin.firestore();

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

const app = express();
app.use(bodyParser.json());

// => helpers
function hashCode(code) {
  return crypto.createHash("sha256").update(code).digest("hex");
}

function gen4Digits() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// POST /request-reset  { email }
app.post("/request-reset", async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: "email required" });

    const userRef = db.collection("usuario").doc(email);
    const userSnap = await userRef.get();
    if (!userSnap.exists) return res.status(404).json({ error: "user not found" });

    const code = gen4Digits();
    const hashed = hashCode(code);
    const expiresAt = Date.now() + 1000 * 60 * 15; // 15 minutos

    // Guarda hashed code y expiry
    await userRef.update({
      reset_token: hashed,
      reset_expires: expiresAt
    });

    // Enviar email con SendGrid
    const msg = {
      to: email,
      from: process.env.SENDGRID_FROM_EMAIL, // tu dirección verificada
      subject: "Código de recuperación - QuizZoo",
      text: `Tu código de recuperación es: ${code}. Válido 15 minutos.`,
      html: `<p>Tu código de recuperación es: <b>${code}</b></p><p>Válido 15 minutos.</p>`
    };

    await sgMail.send(msg);
    return res.json({ ok: true });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: "server error" });
  }
});

// POST /verify-code { email, code }
app.post("/verify-code", async (req, res) => {
  try {
    const { email, code } = req.body;
    if (!email || !code) return res.status(400).json({ error: "email and code required" });

    const userRef = db.collection("usuario").doc(email);
    const snap = await userRef.get();
    if (!snap.exists) return res.status(404).json({ error: "user not found" });

    const data = snap.data();
    const storedHash = data?.reset_token;
    const expires = data?.reset_expires ?? 0;
    if (!storedHash || Date.now() > expires) {
      return res.status(400).json({ error: "token expired or not found" });
    }

    if (hashCode(code) !== storedHash) {
      return res.status(400).json({ error: "invalid code" });
    }

    // OK -> allow reset (we return success)
    // Optionally mark a short-lived "code_verified" flag or return a temporary jwt. For simplicity:
    return res.json({ ok: true });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: "server error" });
  }
});

// POST /reset-password { email, code, newPassword }
app.post("/reset-password", async (req, res) => {
  try {
    const { email, code, newPassword } = req.body;
    if (!email || !code || !newPassword) return res.status(400).json({ error: "missing fields" });

    const userRef = db.collection("usuario").doc(email);
    const snap = await userRef.get();
    if (!snap.exists) return res.status(404).json({ error: "user not found" });

    const data = snap.data();
    const storedHash = data?.reset_token;
    const expires = data?.reset_expires ?? 0;
    if (!storedHash || Date.now() > expires) {
      return res.status(400).json({ error: "token expired or not found" });
    }

    if (hashCode(code) !== storedHash) {
      return res.status(400).json({ error: "invalid code" });
    }

    // Actualizar contraseña (en claro si así está tu esquema; ideal: hash en servidor)
    await userRef.update({
      contrasena: newPassword,
      // borrar token
      reset_token: admin.firestore.FieldValue.delete(),
      reset_expires: admin.firestore.FieldValue.delete(),
    });

    return res.json({ ok: true });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: "server error" });
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log("Server listening on", PORT));
