const { verifyRole } = require('../src/middleware');

describe('verifyRole', () => {
  test('throws unauthenticated when no auth', () => {
    const context = { auth: null };

    expect(() => verifyRole(context, ['admin'])).toThrow();
    try {
      verifyRole(context, ['admin']);
    } catch (err) {
      expect(err.code).toBe('unauthenticated');
    }
  });

  test('throws unauthenticated when auth is undefined', () => {
    const context = {};

    expect(() => verifyRole(context, ['admin'])).toThrow();
    try {
      verifyRole(context, ['admin']);
    } catch (err) {
      expect(err.code).toBe('unauthenticated');
    }
  });

  test('throws permission-denied when role is not in allowedRoles', () => {
    const context = {
      auth: {
        uid: 'user-1',
        token: { role: 'manager' },
      },
    };

    expect(() => verifyRole(context, ['admin', 'superadmin'])).toThrow();
    try {
      verifyRole(context, ['admin', 'superadmin']);
    } catch (err) {
      expect(err.code).toBe('permission-denied');
    }
  });

  test('throws permission-denied when token has no role', () => {
    const context = {
      auth: {
        uid: 'user-2',
        token: {},
      },
    };

    expect(() => verifyRole(context, ['admin'])).toThrow();
    try {
      verifyRole(context, ['admin']);
    } catch (err) {
      expect(err.code).toBe('permission-denied');
    }
  });

  test('returns uid and role when role is valid', () => {
    const context = {
      auth: {
        uid: 'user-3',
        token: { role: 'admin' },
      },
    };

    const result = verifyRole(context, ['admin', 'manager']);
    expect(result).toEqual({ uid: 'user-3', role: 'admin' });
  });

  test('returns uid and role for any matching role in allowedRoles', () => {
    const context = {
      auth: {
        uid: 'user-4',
        token: { role: 'manager' },
      },
    };

    const result = verifyRole(context, ['admin', 'manager']);
    expect(result).toEqual({ uid: 'user-4', role: 'manager' });
  });
});
