const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyNewReport = functions.firestore
  .document("evac_reports/{reportId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    const payload = {
      notification: {
        title: "🚨 Laporan Evakuasi Baru",
        body: data.title ?? "Ada laporan baru",
      },
    };

    await admin.messaging().sendToTopic("reports", payload);

    console.log("Notifikasi laporan terkirim");
  });
