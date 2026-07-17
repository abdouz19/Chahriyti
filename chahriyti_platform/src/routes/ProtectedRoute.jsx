import { Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { Spinner } from '../components/ui';
import { ROLES } from '../config/constants';

/**
 * Route guard — checks authentication and role
 * @param {Object} props
 * @param {string} props.allowedRole - Required role ('admin' | 'manager')
 * @param {React.ReactNode} props.children - Protected content
 */
export function ProtectedRoute({ allowedRole, children }) {
  const { user, role, loading } = useAuth();

  // Show loading spinner during initial auth check
  if (loading) {
    return (
      <div className="min-h-screen bg-surface flex items-center justify-center">
        <div className="text-center">
          <Spinner size="lg" />
          <p className="text-text-secondary mt-4 text-sm">جاري التحميل...</p>
        </div>
      </div>
    );
  }

  // Not authenticated — redirect to login
  if (!user) {
    return <Navigate to="/login" replace />;
  }

  // Wrong role — redirect to correct portal
  if (role !== allowedRole) {
    const redirectTo = role === ROLES.ADMIN ? '/admin' : '/manager';
    return <Navigate to={redirectTo} replace />;
  }

  return children;
}
