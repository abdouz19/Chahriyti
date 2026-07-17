/**
 * Admin seed script — creates the initial admin account
 *
 * Usage: node functions/src/seed.js
 *
 * Environment variables required:
 *   FIREBASE_PROJECT_ID — your Firebase project ID
 *
 * This script should be run once during initial setup.
 * It creates a Firebase Auth user with admin custom claims
 * and a corresponding Firestore user document.
 */

const admin = require('firebase-admin');

// Initialize with default credentials (use GOOGLE_APPLICATION_CREDENTIALS or gcloud auth)
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: process.env.FIREBASE_PROJECT_ID,
  });
}

const db = admin.firestore();

async function seedAdmin() {
  const email = process.argv[2] || 'admin@chahriyti.com';
  const password = process.argv[3] || 'admin12345';
  const displayName = process.argv[4] || 'Admin';

  console.log(`Creating admin account: ${email}`);

  try {
    // Create Firebase Auth user
    let userRecord;
    try {
      userRecord = await admin.auth().getUserByEmail(email);
      console.log(`User already exists: ${userRecord.uid}`);
    } catch {
      userRecord = await admin.auth().createUser({
        email,
        password,
        displayName,
      });
      console.log(`Created user: ${userRecord.uid}`);
    }

    // Set admin custom claims
    await admin.auth().setCustomUserClaims(userRecord.uid, { role: 'admin' });
    console.log('Set admin custom claims');

    // Create Firestore user document
    await db.collection('users').doc(userRecord.uid).set({
      email,
      displayName,
      role: 'admin',
      status: 'active',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      createdBy: 'seed-script',
    }, { merge: true });
    console.log('Created Firestore user document');

    // Initialize global stats if not exists
    const globalStatsRef = db.doc('stats/global');
    const globalStats = await globalStatsRef.get();
    if (!globalStats.exists) {
      await globalStatsRef.set({
        totalClients: 0,
        totalManagers: 0,
        todayClients: 0,
        monthClients: 0,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });
      console.log('Initialized global stats document');
    }

    console.log('\nAdmin account ready!');
    console.log(`  Email: ${email}`);
    console.log(`  Password: ${password}`);
    console.log(`  UID: ${userRecord.uid}`);

  } catch (err) {
    console.error('Seed failed:', err.message);
    process.exit(1);
  }

  process.exit(0);
}

seedAdmin();
