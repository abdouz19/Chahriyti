import {
  signInWithEmailAndPassword,
  signOut as firebaseSignOut,
  onAuthStateChanged,
} from 'firebase/auth';
import { auth } from '../config/firebase';

/**
 * Sign in with email and password.
 * @param {string} email
 * @param {string} password
 * @returns {Promise<import('firebase/auth').User>} The authenticated user.
 */
export async function signIn(email, password) {
  try {
    const credential = await signInWithEmailAndPassword(auth, email, password);
    return credential.user;
  } catch (error) {
    throw new Error(getAuthErrorMessage(error.code));
  }
}

/**
 * Sign the current user out.
 */
export async function signOut() {
  try {
    await firebaseSignOut(auth);
  } catch (error) {
    throw new Error('Failed to sign out. Please try again.');
  }
}

/**
 * Subscribe to auth state changes.
 * @param {function} callback — receives the user object or null.
 * @returns {function} Unsubscribe function.
 */
export function onAuthChange(callback) {
  return onAuthStateChanged(auth, callback);
}

/**
 * Get the current user's custom-claim role from their ID token.
 * @returns {Promise<string|null>} The role string (e.g. 'admin', 'manager') or null.
 */
export async function getUserRole() {
  const user = auth.currentUser;
  if (!user) return null;

  try {
    const tokenResult = await user.getIdTokenResult();
    return tokenResult.claims.role || null;
  } catch (error) {
    throw new Error('Failed to retrieve user role.');
  }
}

/**
 * Force-refresh the ID token (useful after a role change on the backend).
 */
export async function refreshToken() {
  const user = auth.currentUser;
  if (!user) return;

  try {
    await user.getIdToken(true);
  } catch (error) {
    throw new Error('Failed to refresh authentication token.');
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/**
 * Map Firebase auth error codes to user-friendly messages.
 */
function getAuthErrorMessage(code) {
  const messages = {
    'auth/invalid-email': 'Invalid email address.',
    'auth/user-disabled': 'This account has been disabled.',
    'auth/user-not-found': 'No account found with this email.',
    'auth/wrong-password': 'Incorrect password.',
    'auth/too-many-requests': 'Too many attempts. Please try again later.',
    'auth/invalid-credential': 'Invalid email or password.',
    'auth/network-request-failed': 'Network error. Check your connection.',
  };
  return messages[code] || 'Authentication failed. Please try again.';
}
