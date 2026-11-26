const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

/**
 * Automatically sends an FCM push notification to all app users ('all_users' topic)
 * whenever a new document is created in the Firestore 'notifications' collection.
 */
exports.sendNotificationOnCreate = onDocumentCreated(
  "notifications/{docId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data() || {};
    const title = (data.title || "Hornbill Festival Update").toString().trim();
    const body = (data.body || data.description || data.title || "Tap to view the latest update.")
      .toString()
      .trim();
    const file = (data.file || data.url || data.link || "").toString().trim();

    const message = {
      topic: "all_users",
      notification: {
        title,
        body,
      },
      data: {
        docId: event.params.docId,
        type: "notification",
        title,
        body,
        file,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "hornbill_notifications",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    };

    try {
      const response = await getMessaging().send(message);
      console.log(`Sent FCM push for notifications/${event.params.docId}:`, response);
    } catch (err) {
      console.error(`Failed to send FCM push for notifications/${event.params.docId}:`, err);
    }
  }
);
