importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAqk9XHXONs5l8C8gjXGyJUFWc30ivWHJ0",
  authDomain: "sayedgolf-edeff.firebaseapp.com",
  projectId: "sayedgolf-edeff",
  storageBucket: "sayedgolf-edeff.firebasestorage.app",
  messagingSenderId: "5568704054",
  appId: "1:5568704054:web:sayedgolf",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("Received background message:", payload);
  self.registration.showNotification(payload.notification?.title ?? "Message", {
    body: payload.notification?.body,
    icon: "/icons/Icon-192.png",
  });
});
