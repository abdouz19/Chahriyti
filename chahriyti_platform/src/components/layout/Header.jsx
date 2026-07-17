import { useAuth } from '../../hooks/useAuth';
import { Badge } from '../ui';
import { ROLES } from '../../config/constants';

/**
 * Top header bar with user info and logout
 * @param {Object} props
 * @param {string} props.title - Page title
 */
export function Header({ title }) {
  const { user, role, signOut } = useAuth();

  const roleLabel = role === ROLES.ADMIN ? 'مدير النظام' : 'مسؤول';
  const roleBadgeVariant = role === ROLES.ADMIN ? 'warning' : 'success';

  return (
    <header className="h-16 bg-white border-b border-border/50 flex items-center justify-between px-6">
      {/* Page title */}
      <h1 className="text-lg font-semibold text-text-primary">{title}</h1>

      {/* User info + logout */}
      <div className="flex items-center gap-4">
        <Badge variant={roleBadgeVariant}>{roleLabel}</Badge>

        <div className="flex items-center gap-3">
          {/* User avatar */}
          <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center">
            <span className="text-primary text-sm font-semibold">
              {user?.email?.charAt(0)?.toUpperCase() || '?'}
            </span>
          </div>

          {/* User email */}
          <span className="text-sm text-text-secondary hidden sm:block max-w-[180px] truncate">
            {user?.email}
          </span>
        </div>

        {/* Logout button */}
        <button
          onClick={signOut}
          className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-sm
                     text-text-secondary hover:text-negative hover:bg-negative/5
                     transition-colors duration-200"
        >
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
            <path strokeLinecap="round" strokeLinejoin="round"
              d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9" />
          </svg>
          <span className="hidden sm:inline">خروج</span>
        </button>
      </div>
    </header>
  );
}
