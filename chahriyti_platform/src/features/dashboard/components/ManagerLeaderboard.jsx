import React from 'react';
import { Badge } from '../../../components/ui';

/**
 * Extract the first letter of a name for the avatar circle.
 * @param {string} name
 * @returns {string}
 */
function getInitial(name) {
  return (name || '?').charAt(0).toUpperCase();
}

/**
 * Background color palette for avatar circles, cycled by index.
 */
const AVATAR_COLORS = [
  '#0D6E6E',
  '#1A9494',
  '#084E4E',
  '#22C55E',
  '#F59E0B',
  '#6366F1',
  '#EC4899',
  '#8B5CF6',
];

/**
 * Ranked list of managers sorted by client count.
 *
 * Each row shows rank, avatar initial, manager name, and client count.
 * Rows are clickable to trigger drill-down into a specific manager's stats.
 *
 * @param {Object} props
 * @param {{ managerId: string, name: string, count: number }[]} props.managers
 * @param {(managerId: string, name: string) => void} props.onSelect
 * @param {string|null} [props.selectedId] - Currently selected manager ID
 */
export function ManagerLeaderboard({ managers = [], onSelect, selectedId }) {
  if (!managers.length) {
    return (
      <div className="bg-white rounded-2xl border border-border/50 shadow-card p-5">
        <h3 className="text-sm font-semibold text-text-primary mb-4">
          Manager Leaderboard
        </h3>
        <p className="text-sm text-text-secondary text-center py-6">
          No managers found
        </p>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-2xl border border-border/50 shadow-card p-5">
      <h3 className="text-sm font-semibold text-text-primary mb-4">
        Manager Leaderboard
      </h3>

      <div className="space-y-1">
        {managers.map((manager, index) => {
          const isSelected = selectedId === manager.managerId;
          const avatarColor = AVATAR_COLORS[index % AVATAR_COLORS.length];

          return (
            <button
              key={manager.managerId}
              onClick={() => onSelect?.(manager.managerId, manager.name)}
              className={[
                'w-full flex items-center gap-3 px-3 py-2.5 rounded-xl',
                'transition-colors duration-150 text-left',
                isSelected
                  ? 'bg-primary/8 ring-1 ring-primary/20'
                  : 'hover:bg-surface',
              ].join(' ')}
            >
              {/* Rank number */}
              <span className="text-xs font-semibold text-text-secondary w-5 text-center tabular-nums shrink-0">
                {index + 1}
              </span>

              {/* Avatar circle */}
              <div
                className="w-8 h-8 rounded-full flex items-center justify-center text-white text-xs font-bold shrink-0"
                style={{ backgroundColor: avatarColor }}
              >
                {getInitial(manager.name)}
              </div>

              {/* Name */}
              <span className="text-sm font-medium text-text-primary truncate flex-1">
                {manager.name}
              </span>

              {/* Count badge */}
              <Badge variant="neutral">
                {(manager.count ?? 0).toLocaleString()}
              </Badge>
            </button>
          );
        })}
      </div>
    </div>
  );
}
