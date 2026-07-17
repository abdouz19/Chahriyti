import {
  collection,
  query,
  where,
  orderBy,
  limit,
  startAfter,
  getDocs,
  doc,
  onSnapshot,
} from 'firebase/firestore';
import { db } from '../config/firebase';
import { COLLECTIONS, ROLES, PAGE_SIZE } from '../config/constants';

// ---------------------------------------------------------------------------
// Clients
// ---------------------------------------------------------------------------

/**
 * Fetch a paginated list of clients with optional filters.
 *
 * @param {object} options
 * @param {string}  [options.managerId]   — filter by the manager who created them.
 * @param {string}  [options.searchQuery] — prefix search on client name.
 * @param {Date}    [options.startDate]   — only clients created on or after this date.
 * @param {Date}    [options.endDate]     — only clients created on or before this date.
 * @param {number}  [options.pageSize]    — results per page (defaults to PAGE_SIZE).
 * @param {object}  [options.lastDoc]     — Firestore document snapshot for cursor pagination.
 * @returns {Promise<{ clients: object[], lastDoc: object|null, hasMore: boolean }>}
 */
export async function getClients({
  managerId,
  searchQuery,
  startDate,
  endDate,
  pageSize = PAGE_SIZE,
  lastDoc,
} = {}) {
  try {
    const constraints = [];
    const colRef = collection(db, COLLECTIONS.CLIENTS);

    // Filter by manager
    if (managerId) {
      constraints.push(where('managerId', '==', managerId));
    }

    // Prefix search on clientName (case-sensitive, starts-with)
    if (searchQuery) {
      const end = searchQuery + '\uf8ff'; // Unicode high char for range query
      constraints.push(where('clientName', '>=', searchQuery));
      constraints.push(where('clientName', '<=', end));
    }

    // Date range on createdAt
    if (startDate) {
      constraints.push(where('createdAt', '>=', startDate));
    }
    if (endDate) {
      constraints.push(where('createdAt', '<=', endDate));
    }

    // Ordering — when searching by name the index already orders by clientName,
    // otherwise default to newest first.
    if (searchQuery) {
      constraints.push(orderBy('clientName'));
    } else {
      constraints.push(orderBy('createdAt', 'desc'));
    }

    // Fetch one extra doc to determine if there are more pages.
    constraints.push(limit(pageSize + 1));

    // Cursor-based pagination
    if (lastDoc) {
      constraints.push(startAfter(lastDoc));
    }

    const q = query(colRef, ...constraints);
    const snapshot = await getDocs(q);

    const docs = snapshot.docs;
    const hasMore = docs.length > pageSize;

    // Trim the extra doc we fetched for the hasMore check.
    const pageDocs = hasMore ? docs.slice(0, pageSize) : docs;

    const clients = pageDocs.map((d) => ({ id: d.id, ...d.data() }));
    const newLastDoc = pageDocs.length > 0 ? pageDocs[pageDocs.length - 1] : null;

    return { clients, lastDoc: newLastDoc, hasMore };
  } catch (error) {
    throw new Error('Failed to load clients. Please try again.');
  }
}

// ---------------------------------------------------------------------------
// Managers
// ---------------------------------------------------------------------------

/**
 * Fetch all users with the 'manager' role, ordered alphabetically.
 * @returns {Promise<object[]>}
 */
export async function getManagers() {
  try {
    const q = query(
      collection(db, COLLECTIONS.USERS),
      where('role', '==', ROLES.MANAGER),
      orderBy('displayName'),
    );
    const snapshot = await getDocs(q);
    return snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
  } catch (error) {
    throw new Error('Failed to load managers.');
  }
}

// ---------------------------------------------------------------------------
// Real-time stats listeners
// ---------------------------------------------------------------------------

/**
 * Subscribe to global platform statistics (stats/global document).
 * @param {function} callback — receives the stats data object.
 * @returns {function} Unsubscribe function.
 */
export function onGlobalStatsSnapshot(callback) {
  const docRef = doc(db, COLLECTIONS.STATS, 'global');
  return onSnapshot(
    docRef,
    (snapshot) => {
      callback(snapshot.exists() ? snapshot.data() : null);
    },
    (error) => {
      console.error('Global stats listener error:', error);
    },
  );
}

/**
 * Subscribe to a specific manager's statistics (stats/managers/{managerId}).
 * @param {string} managerId
 * @param {function} callback — receives the stats data object.
 * @returns {function} Unsubscribe function.
 */
export function onManagerStatsSnapshot(managerId, callback) {
  const docRef = doc(db, 'stats_managers', managerId);
  return onSnapshot(
    docRef,
    (snapshot) => {
      callback(snapshot.exists() ? snapshot.data() : null);
    },
    (error) => {
      console.error(`Manager stats listener error (${managerId}):`, error);
    },
  );
}

// ---------------------------------------------------------------------------
// Daily stats
// ---------------------------------------------------------------------------

/**
 * Query daily stat documents for a given period.
 *
 * Assumes documents live under stats/daily/{YYYY-MM-DD} and have a `date`
 * field that can be compared as a string or Timestamp.
 *
 * @param {string} period — ISO date string for the start of the period.
 * @param {string} [managerId] — optional; unused at query level but included
 *   so callers can post-filter by manager if the doc contains a byManager map.
 * @returns {Promise<object[]>} Array of daily stat documents.
 */
export async function getDailyStats(period, managerId) {
  try {
    const constraints = [orderBy('date', 'asc')];

    if (period) {
      constraints.push(where('date', '>=', period));
    }

    const q = query(
      collection(db, 'stats_daily'),
      ...constraints,
    );
    const snapshot = await getDocs(q);
    const stats = snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));

    // If a managerId was provided, surface only that manager's slice when
    // documents contain a byManager map.
    if (managerId) {
      return stats.map((entry) => ({
        date: entry.date,
        count: entry.byManager?.[managerId] ?? 0,
      }));
    }

    return stats;
  } catch (error) {
    throw new Error('Failed to load daily statistics.');
  }
}

// ---------------------------------------------------------------------------
// Client lookup by device
// ---------------------------------------------------------------------------

/**
 * Check whether a client with the given deviceId already exists.
 * @param {string} deviceId
 * @returns {Promise<object|null>} The client document data (with id) or null.
 */
export async function getClientByDeviceId(deviceId) {
  try {
    const q = query(
      collection(db, COLLECTIONS.CLIENTS),
      where('deviceId', '==', deviceId),
      limit(1),
    );
    const snapshot = await getDocs(q);

    if (snapshot.empty) return null;

    const docSnap = snapshot.docs[0];
    return { id: docSnap.id, ...docSnap.data() };
  } catch (error) {
    throw new Error('Failed to look up client by device ID.');
  }
}
