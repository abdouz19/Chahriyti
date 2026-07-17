import React, { useState } from 'react';
import { Card, Pagination, EmptyState, Spinner } from '../../../components/ui';
import { useClients } from '../hooks/useClients';
import { ClientsToolbar } from '../components/ClientsToolbar';
import { ClientsTable } from '../components/ClientsTable';
import { ClientDetailModal } from '../components/ClientDetailModal';

/**
 * Users icon for the empty state.
 */
function UsersIcon() {
  return (
    <svg
      className="w-7 h-7"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth={1.5}
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z"
      />
    </svg>
  );
}

/**
 * Client History page — displays a paginated, searchable table of
 * the authenticated manager's clients with detail modal.
 *
 * Route: /manager/clients
 */
export function ClientsPage() {
  const {
    clients,
    loading,
    error,
    searchQuery,
    setSearchQuery,
    startDate,
    endDate,
    setDateRange,
    currentPage,
    hasMore,
    totalToday,
    totalAll,
    goToPage,
    totalPages,
  } = useClients();

  /** Currently selected client for the detail modal. */
  const [selectedClient, setSelectedClient] = useState(null);

  return (
    <div className="flex flex-col gap-6">
      {/* Page header */}
      <div>
        <h1 className="text-xl font-bold text-text-primary">سجل العملاء</h1>
        <p className="text-sm text-text-secondary mt-1">
          عرض وإدارة قائمة العملاء والتراخيص المُولّدة
        </p>
      </div>

      {/* Toolbar: search, date filter, badges */}
      <ClientsToolbar
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
        startDate={startDate}
        endDate={endDate}
        onDateChange={(s, e) => setDateRange(s, e)}
        todayCount={totalToday}
        totalCount={totalAll}
      />

      {/* Error state */}
      {error && (
        <div className="text-sm text-negative bg-negative/8 border border-negative/20 rounded-lg px-4 py-3">
          {error}
        </div>
      )}

      {/* Main content */}
      <Card>
        {/* Initial loading (no data yet) */}
        {loading && clients.length === 0 ? (
          <div className="flex items-center justify-center py-20">
            <Spinner size="lg" />
          </div>
        ) : clients.length === 0 ? (
          /* Empty state */
          <EmptyState
            icon={<UsersIcon />}
            title="لا يوجد عملاء"
            description="لم يتم العثور على عملاء مطابقين للبحث أو الفلتر الحالي."
          />
        ) : (
          /* Data table */
          <ClientsTable
            clients={clients}
            loading={loading}
            onRowClick={(client) => setSelectedClient(client)}
          />
        )}
      </Card>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex justify-center">
          <Pagination
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={goToPage}
          />
        </div>
      )}

      {/* Client detail modal */}
      <ClientDetailModal
        client={selectedClient}
        isOpen={!!selectedClient}
        onClose={() => setSelectedClient(null)}
      />
    </div>
  );
}
