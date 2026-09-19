import {
  collection,
  query,
  where,
  orderBy,
  limit,
  startAfter,
  getDocs,
  getDoc,
  doc,
  onSnapshot,
} from 'firebase/firestore';
import { db } from '../config/firebase';
import { COLLECTIONS, PAGE_SIZE } from '../config/constants';

// ---------------------------------------------------------------------------
// License pool
// ---------------------------------------------------------------------------

/**
 * Fetch paginated pool licenses with optional status filter.
 */
export async function getLicenses({
  status,
  pageSize = PAGE_SIZE,
  lastDoc: lastDocCursor,
} = {}) {
  try {
    const constraints = [];
    const colRef = collection(db, COLLECTIONS.LICENSES);

    if (status) {
      constraints.push(where('status', '==', status));
    }

    constraints.push(orderBy('createdAt', 'desc'));
    constraints.push(limit(pageSize + 1));

    if (lastDocCursor) {
      constraints.push(startAfter(lastDocCursor));
    }

    const q = query(colRef, ...constraints);
    const snapshot = await getDocs(q);

    const docs = snapshot.docs;
    const hasMore = docs.length > pageSize;
    const pageDocs = hasMore ? docs.slice(0, pageSize) : docs;

    const licenses = pageDocs.map((d) => ({ id: d.id, ...d.data() }));
    const newLastDoc = pageDocs.length > 0 ? pageDocs[pageDocs.length - 1] : null;

    return { licenses, lastDoc: newLastDoc, hasMore };
  } catch (error) {
    throw new Error('Failed to load licenses.');
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
