import React, { createContext, useState, useEffect, useCallback } from 'react';
import { doc, getDoc } from 'firebase/firestore';
import { db } from '../config/firebase';
import { COLLECTIONS, STATUS } from '../config/constants';
import {
  signIn as authSignIn,
  signOut as authSignOut,
  onAuthChange,
  getUserRole,
} from '../services/auth';

// ---------------------------------------------------------------------------
// Context
// ---------------------------------------------------------------------------

export const AuthContext = createContext(null);

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

/**
 * AuthProvider wraps the app and exposes auth state + actions via context.
 *
 * Provided values:
 *  - user     : Firebase User object or null
 *  - role     : 'admin' | 'manager' | null
 *  - loading  : true while the initial auth check is in progress
 *  - signIn   : (email, password) => Promise<void>
 *  - signOut  : () => Promise<void>
 */
export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [role, setRole] = useState(null);
  const [loading, setLoading] = useState(true);

  // -----------------------------------------------------------------------
  // Listen for Firebase auth state changes on mount.
  // -----------------------------------------------------------------------
  useEffect(() => {
    const unsubscribe = onAuthChange(async (firebaseUser) => {
      if (firebaseUser) {
        try {
          // Check the user's status in Firestore — inactive users get signed out.
          const userDoc = await getDoc(
            doc(db, COLLECTIONS.USERS, firebaseUser.uid),
          );

          if (userDoc.exists() && userDoc.data().status === STATUS.INACTIVE) {
            await authSignOut();
            setUser(null);
            setRole(null);
            setLoading(false);
            return;
          }

          // Fetch role from custom claims
          const userRole = await getUserRole();
          setUser(firebaseUser);
          setRole(userRole);
        } catch (error) {
          // If anything fails during the check, reset to logged-out state.
          console.error('Auth state check failed:', error);
          setUser(null);
          setRole(null);
        }
      } else {
        setUser(null);
        setRole(null);
      }

      setLoading(false);
    });

    return unsubscribe;
  }, []);

  // -----------------------------------------------------------------------
  // Sign in — validates status before admitting the user.
  // -----------------------------------------------------------------------
  const signIn = useCallback(async (email, password) => {
    const firebaseUser = await authSignIn(email, password);

    // Verify the account is active in Firestore
    const userDoc = await getDoc(
      doc(db, COLLECTIONS.USERS, firebaseUser.uid),
    );

    if (userDoc.exists() && userDoc.data().status === STATUS.INACTIVE) {
      // Sign out immediately — the account has been deactivated.
      await authSignOut();
      throw new Error('Your account has been deactivated. Contact an administrator.');
    }

    // Fetch role from custom claims
    const userRole = await getUserRole();
    setUser(firebaseUser);
    setRole(userRole);
    return { role: userRole };
  }, []);

  // -----------------------------------------------------------------------
  // Sign out
  // -----------------------------------------------------------------------
  const signOut = useCallback(async () => {
    await authSignOut();
    setUser(null);
    setRole(null);
  }, []);

  // -----------------------------------------------------------------------
  // Context value (stable reference via memoisation isn't necessary here
  // because the provider only re-renders when state actually changes).
  // -----------------------------------------------------------------------
  const value = { user, role, loading, signIn, signOut };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
