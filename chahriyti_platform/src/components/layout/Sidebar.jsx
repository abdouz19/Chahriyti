import { NavLink } from 'react-router-dom';

/**
 * Sidebar navigation component
 * @param {Object} props
 * @param {Array<{to: string, label: string, icon: React.ReactNode}>} props.items - Nav items
 * @param {boolean} props.collapsed - Whether sidebar is collapsed
 * @param {Function} props.onToggle - Toggle collapse callback
 */
export function Sidebar({ items, collapsed, onToggle }) {
  return (
    <aside
      className={`fixed top-0 left-0 h-screen bg-white border-r border-border/50 flex flex-col
                  transition-all duration-300 z-30
                  ${collapsed ? 'w-[72px]' : 'w-[260px]'}`}
    >
      {/* Logo area */}
      <div className="h-16 flex items-center px-5 border-b border-border/50">
        <div className="flex items-center gap-3 min-w-0">
          <div className="w-8 h-8 rounded-xl bg-primary flex items-center justify-center flex-shrink-0">
            <span className="text-white font-bold text-sm">ش</span>
          </div>
          {!collapsed && (
            <span className="font-semibold text-text-primary text-lg truncate">
              شهريتي
            </span>
          )}
        </div>
      </div>

      {/* Navigation items */}
      <nav className="flex-1 py-4 px-3 space-y-1">
        {items.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              `flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium
               transition-colors duration-200
               ${isActive
                 ? 'bg-primary/8 text-primary'
                 : 'text-text-secondary hover:bg-surface hover:text-text-primary'
               }
               ${collapsed ? 'justify-center' : ''}`
            }
          >
            <span className="w-5 h-5 flex-shrink-0 flex items-center justify-center">
              {item.icon}
            </span>
            {!collapsed && <span className="truncate">{item.label}</span>}
          </NavLink>
        ))}
      </nav>

      {/* Collapse toggle */}
      <div className="p-3 border-t border-border/50">
        <button
          onClick={onToggle}
          className="w-full flex items-center justify-center p-2 rounded-xl
                     text-text-secondary hover:bg-surface transition-colors duration-200"
          aria-label={collapsed ? 'Expand sidebar' : 'Collapse sidebar'}
        >
          <svg
            className={`w-5 h-5 transition-transform duration-300 ${collapsed ? 'rotate-180' : ''}`}
            fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
          </svg>
        </button>
      </div>
    </aside>
  );
}
