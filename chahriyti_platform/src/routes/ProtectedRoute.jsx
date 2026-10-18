import { Navigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { Spinner } from '../components/ui';
import { ROLES } from '../config/constants';

/**
 * Route guard — checks authentication and role
 * @param {Object} props
 * @param {string} props.allowedRole - Required role ('admin' | 'manager')
 * @param {string[]} props.allowedRoles - Alternative: any of these roles
 * @param {React.ReactNode} props.children - Protected content
 */
export function ProtectedRoute({ allowedRole, allowedRoles, children }) {
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
  const allowed = allowedRoles ?? [allowedRole];
  if (!allowed.includes(role)) {
    const redirectTo = {
      [ROLES.ADMIN]: '/admin',
      [ROLES.AGENT]: '/admin/leads',
    }[role] ?? '/manager';
    return <Navigate to={redirectTo} replace />;
  }

  return children;
}

/**
 * Admin-only page inside the admin portal: leads agents are sent to the leads page.
 */
export function AdminOnly({ children }) {
  const { role } = useAuth();
  if (role !== ROLES.ADMIN) return <Navigate to="/admin/leads" replace />;
  return children;
}
