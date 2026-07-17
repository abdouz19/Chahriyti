import { useContext } from 'react';
import { AuthContext } from '../contexts/AuthContext';

/**
 * Convenience hook for consuming the AuthContext.
 *
 * @returns {{ user: object|null, role: string|null, loading: boolean, signIn: function, signOut: function }}
 */
export function useAuth() {
  const context = useContext(AuthContext);

  if (context === null) {
    throw new Error(
      'useAuth must be used within an <AuthProvider>. ' +
        'Wrap your component tree with <AuthProvider> in App or index.',
    );
  }

  return context;
}
