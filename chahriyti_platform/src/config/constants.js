// Firebase collection names
export const COLLECTIONS = {
  USERS: 'users',
  CLIENTS: 'clients',
  STATS: 'stats',
  LICENSES: 'licenses',
};

// User roles
export const ROLES = {
  ADMIN: 'admin',
  MANAGER: 'manager',
};

// User status
export const STATUS = {
  ACTIVE: 'active',
  INACTIVE: 'inactive',
};

// Cloud Function names
export const FUNCTIONS = {
  GENERATE_LICENSE: 'generateLicense',
  CREATE_MANAGER: 'createManager',
  UPDATE_USER_STATUS: 'updateUserStatus',
  GET_DASHBOARD_STATS: 'getDashboardStats',
  SEND_TO_DELIVERY: 'sendToDelivery',
  GENERATE_LICENSE_BATCH: 'generateLicenseBatch',
  ASSIGN_LICENSE: 'assignLicense',
  MARK_LICENSES_PRINTED: 'markLicensesPrinted',
};

// License pool statuses
export const LICENSE_STATUS = {
  AVAILABLE: 'available',
  USED: 'used',
};

// Pagination
export const PAGE_SIZE = 20;

// Date periods for dashboard
export const PERIODS = {
  WEEK: 'week',
  MONTH: 'month',
  QUARTER: 'quarter',
  YEAR: 'year',
};
