import { httpsCallable } from 'firebase/functions';
import { functions } from '../config/firebase';
import { FUNCTIONS } from '../config/constants';

// ---------------------------------------------------------------------------
// Internal helper — wraps httpsCallable with consistent error handling.
// ---------------------------------------------------------------------------

async function callFunction(name, data = {}) {
  try {
    const fn = httpsCallable(functions, name);
    const result = await fn(data);
    return result.data;
  } catch (error) {
    // Cloud Functions errors carry a `message` on the error object.
    // Fall back to a generic message when none is provided.
    const message =
      error?.message || `Cloud function "${name}" failed. Please try again.`;
    throw new Error(message);
  }
}

// ---------------------------------------------------------------------------
// Public callable wrappers
// ---------------------------------------------------------------------------

/**
 * Generate a license for a client.
 * @param {{ clientName: string, phone: string, deviceId: string }} data
 * @returns {Promise<object>} The generated license data from the backend.
 */
export function callGenerateLicense({ clientName, phone, deviceId }) {
  return callFunction(FUNCTIONS.GENERATE_LICENSE, { clientName, phone, deviceId });
}

/**
 * Create a new manager account.
 * @param {{ email: string, displayName: string, password: string }} data
 * @returns {Promise<object>} The created manager data.
 */
export function callCreateManager({ email, displayName, password }) {
  return callFunction(FUNCTIONS.CREATE_MANAGER, { email, displayName, password });
}

/**
 * Enable or disable a user account.
 * @param {{ uid: string, status: string }} data — status should be 'active' or 'inactive'.
 * @returns {Promise<object>} Confirmation from the backend.
 */
export function callUpdateUserStatus({ uid, status }) {
  return callFunction(FUNCTIONS.UPDATE_USER_STATUS, { uid, status });
}

/**
 * Fetch dashboard statistics for a given period.
 * @param {{ period: string, managerId?: string }} data
 * @returns {Promise<object>} Dashboard stats payload.
 */
export function callGetDashboardStats({ period, managerId }) {
  return callFunction(FUNCTIONS.GET_DASHBOARD_STATS, { period, managerId });
}

/**
 * Send license details to the delivery agent via email.
 * @param {object} data — license details (clientName, phone, deviceId, licenseKey, expiryDate, managerName, generatedAt)
 * @returns {Promise<object>} Confirmation from the backend.
 */
export function callSendToDelivery(data) {
  return callFunction(FUNCTIONS.SEND_TO_DELIVERY, data);
}
