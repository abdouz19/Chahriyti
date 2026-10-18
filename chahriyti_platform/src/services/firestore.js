import {
  collection,
  query,
  where,
  orderBy,
  limit,
  startAfter,
  getDocs,
  getDoc,
  updateDoc,
  doc,
  onSnapshot,
  getCountFromServer,
} from 'firebase/firestore';
import { db } from '../config/firebase';
import { COLLECTIONS, PAGE_SIZE } from '../config/constants';

// ---------------------------------------------------------------------------
// License pool
// ---------------------------------------------------------------------------

/**
 * Fetch paginated pool licenses with optional status and printed filters.
 *
 * Unprinted licenses have no `printed` field, so Firestore can't query them:
 * they're found by scanning newest-first and skipping printed ones.
 */
export async function getLicenses({
  status,
  printed,
  pageSize = PAGE_SIZE,
  lastDoc: lastDocCursor,
} = {}) {
  try {
    const colRef = collection(db, COLLECTIONS.LICENSES);
    const base = [];
    if (status) base.push(where('status', '==', status));
    if (printed === 'printed') base.push(where('printed', '==', true));
    base.push(orderBy('createdAt', 'desc'));

    const toPage = (matches, scanCursor) => {
      const hasMore = matches.length > pageSize || !!scanCursor;
      const pageDocs = matches.slice(0, pageSize);
      return {
        licenses: pageDocs.map((d) => ({ id: d.id, ...d.data() })),
        lastDoc: matches.length > pageSize ? pageDocs[pageDocs.length - 1] : (scanCursor ?? pageDocs[pageDocs.length - 1] ?? null),
        hasMore,
      };
    };

    if (printed !== 'unprinted') {
      const constraints = [...base, limit(pageSize + 1)];
      if (lastDocCursor) constraints.push(startAfter(lastDocCursor));
      const snapshot = await getDocs(query(colRef, ...constraints));
      return toPage(snapshot.docs, null);
    }

    // Scan for unprinted, capped so a page never reads the whole pool
    const CHUNK = 300;
    const MAX_SCANNED = 3000;
    const matches = [];
    let cursor = lastDocCursor ?? null;
    let scanned = 0;
    while (matches.length <= pageSize && scanned < MAX_SCANNED) {
      const constraints = [...base, limit(CHUNK)];
      if (cursor) constraints.push(startAfter(cursor));
      const snapshot = await getDocs(query(colRef, ...constraints));
      for (const d of snapshot.docs) {
        if (!d.data().printed) {
          matches.push(d);
          if (matches.length > pageSize) break;
        }
      }
      scanned += snapshot.docs.length;
      cursor = snapshot.docs[snapshot.docs.length - 1] ?? cursor;
      if (snapshot.docs.length < CHUNK) {
        return toPage(matches, null);
      }
    }
    // Stopped at the cap: continue scanning from where we stopped
    return matches.length > pageSize ? toPage(matches, null) : toPage(matches, cursor);
  } catch (error) {
    throw new Error('Failed to load licenses.');
  }
}

/**
 * Find licenses activated on a device whose ID starts with the given text.
 */
export async function searchLicensesByDevice(devicePrefix, { max = 50 } = {}) {
  try {
    const snap = await getDocs(query(
      collection(db, COLLECTIONS.LICENSES),
      where('deviceId', '>=', devicePrefix),
      where('deviceId', '<=', `${devicePrefix}\uf8ff`),
      orderBy('deviceId'),
      limit(max),
    ));
    return snap.docs.map((d) => ({ id: d.id, ...d.data() }));
  } catch (error) {
    throw new Error('Failed to search licenses.');
  }
}

/**
 * Fetch unprinted available licenses up to the requested count.
 */
export async function getUnprintedLicenses(count) {
  const colRef = collection(db, COLLECTIONS.LICENSES);
  const result = [];
  let cursor = null;
  const batchSize = Math.max(count * 2, 200);

  while (result.length < count) {
    const constraints = [
      where('status', '==', 'available'),
      orderBy('createdAt', 'desc'),
      limit(batchSize),
    ];
    if (cursor) constraints.push(startAfter(cursor));

    const snapshot = await getDocs(query(colRef, ...constraints));
    if (snapshot.empty) break;

    for (const d of snapshot.docs) {
      const data = { id: d.id, ...d.data() };
      if (!data.printed) {
        result.push(data);
        if (result.length >= count) break;
      }
    }
    cursor = snapshot.docs[snapshot.docs.length - 1];
    if (snapshot.docs.length < batchSize) break;
  }

  return result;
}

/**
 * Look up a single license by its formatted key.
 */
export async function getLicenseByKey(licenseKey) {
  try {
    const raw = licenseKey.replace(/^CHRY-/, '').replace(/-/g, '').toUpperCase();
    const docRef = doc(db, COLLECTIONS.LICENSES, raw);
    const snapshot = await getDoc(docRef);
    if (!snapshot.exists()) return null;
    return { id: snapshot.id, ...snapshot.data() };
  } catch (error) {
    throw new Error('Failed to look up license.');
  }
}

// ---------------------------------------------------------------------------
// Leads
// ---------------------------------------------------------------------------

/**
 * Fetch paginated leads ordered by submittedAt desc.
 */
export async function getLeads({ pageSize = PAGE_SIZE, lastDoc: lastDocCursor, status, from, to } = {}) {
  try {
    const constraints = [];
    const colRef = collection(db, COLLECTIONS.LEADS);

    if (status) constraints.push(where('status', '==', status));
    constraints.push(...dateRange(from, to));
    constraints.push(orderBy('submittedAt', 'desc'));
    constraints.push(limit(pageSize + 1));
    if (lastDocCursor) constraints.push(startAfter(lastDocCursor));

    const snap = await getDocs(query(colRef, ...constraints));
    const hasMore = snap.docs.length > pageSize;
    const docs = snap.docs.slice(0, pageSize).map((d) => ({ id: d.id, ...d.data() }));
    return { docs, hasMore, lastDoc: snap.docs[pageSize - 1] ?? null };
  } catch (error) {
    throw new Error('Failed to fetch leads.');
  }
}

/**
 * submittedAt bounds for a period: [from, to), either side optional.
 */
function dateRange(from, to) {
  const c = [];
  if (from) c.push(where('submittedAt', '>=', from));
  if (to) c.push(where('submittedAt', '<', to));
  return c;
}

/**
 * Lead counts for the stats cards: totals, today, by source and by status.
 * Uses count queries, so it doesn't download the leads themselves.
 */
export async function getLeadsStats({ from, to } = {}) {
  const colRef = collection(db, COLLECTIONS.LEADS);
  const range = dateRange(from, to);
  const countRaw = async (...constraints) =>
    (await getCountFromServer(query(colRef, ...constraints))).data().count;
  // Every count except "today" respects the selected period
  const count = (...constraints) => countRaw(...constraints, ...range);

  const startOfToday = new Date();
  startOfToday.setHours(0, 0, 0, 0);

  const [total, today, store, pending, contacted, converted, rejected] = await Promise.all([
    count(),
    countRaw(where('submittedAt', '>=', startOfToday)),
    count(where('source', '==', 'woocommerce')),
    count(where('status', '==', 'pending')),
    count(where('status', '==', 'contacted')),
    count(where('status', '==', 'converted')),
    count(where('status', '==', 'rejected')),
  ]);

  return {
    total,
    today,
    store,
    app: total - store,
    byStatus: { pending, contacted, converted, rejected },
  };
}

/**
 * All leads in a period, newest first, for the analytics charts (capped).
 */
export async function getLeadsForAnalytics({ from, to } = {}, { max = 3000 } = {}) {
  const snap = await getDocs(query(
    collection(db, COLLECTIONS.LEADS),
    ...dateRange(from, to),
    orderBy('submittedAt', 'desc'),
    limit(max),
  ));
  return { docs: snap.docs.map((d) => ({ id: d.id, ...d.data() })), capped: snap.size >= max };
}

/**
 * Find leads whose phone starts with the given digits (newest first).
 */
export async function searchLeadsByPhone(phonePrefix, { max = 50 } = {}) {
  try {
    const snap = await getDocs(query(
      collection(db, COLLECTIONS.LEADS),
      where('phone', '>=', phonePrefix),
      where('phone', '<=', `${phonePrefix}`),
      orderBy('phone'),
      limit(max),
    ));
    const docs = snap.docs.map((d) => ({ id: d.id, ...d.data() }));
    const time = (ts) => (ts?.toMillis ? ts.toMillis() : 0);
    return docs.sort((a, b) => time(b.submittedAt) - time(a.submittedAt));
  } catch (error) {
    throw new Error('Failed to search leads.');
  }
}

/**
 * List leads agent accounts (newest first).
 */
export async function getLeadsAgents() {
  const snap = await getDocs(query(
    collection(db, COLLECTIONS.USERS),
    where('role', '==', 'agent'),
  ));
  const time = (ts) => (ts?.toMillis ? ts.toMillis() : 0);
  return snap.docs
    .map((d) => ({ id: d.id, ...d.data() }))
    .sort((a, b) => time(b.createdAt) - time(a.createdAt));
}

/**
 * Update a lead's status field.
 */
export async function updateLeadStatus(leadId, status) {
  await updateDoc(doc(db, COLLECTIONS.LEADS, leadId), { status });
}

/**
 * Subscribe to pool statistics (stats/pool document).
 */
export function onPoolStatsSnapshot(callback) {
  const docRef = doc(db, COLLECTIONS.STATS, 'pool');
  return onSnapshot(
    docRef,
    (snapshot) => {
      callback(snapshot.exists() ? snapshot.data() : null);
    },
    (error) => {
      console.error('Pool stats listener error:', error);
    },
  );
}
