const { HttpsError } = require('firebase-functions/v2/https');

/**
 * Verify that the caller is authenticated and has one of the allowed roles.
 *
 * @param {object} context - Firebase callable function context (must have context.auth)
 * @param {string[]} allowedRoles - list of roles that may call this function
 * @returns {{ uid: string, role: string }} the caller's uid and role
 * @throws {HttpsError} 'unauthenticated' if not signed in
 * @throws {HttpsError} 'permission-denied' if role is not in allowedRoles
 */
function verifyRole(context, allowedRoles) {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'Authentication required.');
  }

  const uid = context.auth.uid;
  const role = (context.auth.token && context.auth.token.role) || null;

  if (!role || !allowedRoles.includes(role)) {
    throw new HttpsError(
      'permission-denied',
      `Role '${role}' is not authorized. Allowed: ${allowedRoles.join(', ')}.`
    );
  }

  return { uid, role };
}

module.exports = { verifyRole };
