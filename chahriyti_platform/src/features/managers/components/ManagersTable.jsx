import { Badge, Button, Spinner } from '../../../components/ui';
import { formatDate } from '../../../utils/formatters';
import { STATUS } from '../../../config/constants';

/**
 * Data table displaying the list of managers.
 *
 * @param {Object} props
 * @param {object[]} props.managers - Array of manager objects
 * @param {Function} props.onToggleStatus - Called with (uid, currentStatus) when toggle is clicked
 * @param {string|null} props.toggling - UID of the manager currently being toggled (shows spinner)
 */
export function ManagersTable({ managers, onToggleStatus, toggling }) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-border/50">
            <th className="text-left py-3 px-4 text-xs font-medium text-text-secondary uppercase tracking-wider">
              الاسم
            </th>
            <th className="text-left py-3 px-4 text-xs font-medium text-text-secondary uppercase tracking-wider">
              البريد الإلكتروني
            </th>
            <th className="text-center py-3 px-4 text-xs font-medium text-text-secondary uppercase tracking-wider">
              الحالة
            </th>
            <th className="text-left py-3 px-4 text-xs font-medium text-text-secondary uppercase tracking-wider">
              العملاء
            </th>
            <th className="text-left py-3 px-4 text-xs font-medium text-text-secondary uppercase tracking-wider">
              تاريخ الإنشاء
            </th>
            <th className="text-center py-3 px-4 text-xs font-medium text-text-secondary uppercase tracking-wider">
              الإجراءات
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-border/30">
          {managers.map((manager) => {
            const isActive = manager.status === STATUS.ACTIVE;
            const isToggling = toggling === manager.id;

            return (
              <tr
                key={manager.id}
                className="hover:bg-surface/50 transition-colors duration-150"
              >
                {/* Name */}
                <td className="py-3.5 px-4">
                  <span className="font-medium text-text-primary">
                    {manager.displayName}
                  </span>
                </td>

                {/* Email */}
                <td className="py-3.5 px-4 text-text-secondary">
                  {manager.email}
                </td>

                {/* Status badge */}
                <td className="py-3.5 px-4 text-center">
                  <Badge variant={isActive ? 'success' : 'danger'}>
                    {isActive ? 'نشط' : 'معطل'}
                  </Badge>
                </td>

                {/* Clients count */}
                <td className="py-3.5 px-4 text-text-secondary">
                  {manager.clientsCount ?? 0}
                </td>

                {/* Created date */}
                <td className="py-3.5 px-4 text-text-secondary">
                  {formatDate(manager.createdAt)}
                </td>

                {/* Actions */}
                <td className="py-3.5 px-4 text-center">
                  <Button
                    variant={isActive ? 'danger' : 'primary'}
                    size="sm"
                    loading={isToggling}
                    onClick={() => onToggleStatus(manager.id, manager.status, manager.displayName)}
                    disabled={!!toggling}
                  >
                    {isToggling ? (
                      <Spinner size="sm" />
                    ) : isActive ? (
                      'تعطيل'
                    ) : (
                      'تفعيل'
                    )}
                  </Button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
