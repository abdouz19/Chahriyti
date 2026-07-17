import { useState, useEffect, useCallback } from 'react';
import { getManagers } from '../../../services/firestore';
import { callCreateManager, callUpdateUserStatus } from '../../../services/functions';
import { STATUS } from '../../../config/constants';

/**
 * React hook for managing the managers list, including
 * creating new managers and toggling their active status.
 *
 * @returns {{
 *   managers: object[],
 *   loading: boolean,
 *   error: string|null,
 *   creating: boolean,
 *   toggling: string|null,
 *   createManager: (data: { email: string, displayName: string, password: string }) => Promise<object>,
 *   toggleStatus: (uid: string, currentStatus: string) => Promise<object>,
 *   refresh: () => Promise<void>,
 * }}
 */
export function useManagers() {
  const [managers, setManagers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [creating, setCreating] = useState(false);
  const [toggling, setToggling] = useState(null);

  /**
   * Fetch the full managers list from Firestore.
   */
  const fetchManagers = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const result = await getManagers();
      setManagers(result);
    } catch (err) {
      setError(err.message || 'Failed to load managers.');
    } finally {
      setLoading(false);
    }
  }, []);

  // Fetch on mount
  useEffect(() => {
    fetchManagers();
  }, [fetchManagers]);

  /**
   * Create a new manager account via Cloud Function, then refresh the list.
   *
   * @param {{ email: string, displayName: string, password: string }} data
   * @returns {Promise<object>} The created manager data from the backend.
   */
  const createManager = useCallback(
    async ({ email, displayName, password }) => {
      setCreating(true);
      try {
        const result = await callCreateManager({ email, displayName, password });
        await fetchManagers();
        return result;
      } finally {
        setCreating(false);
      }
    },
    [fetchManagers],
  );

  /**
   * Toggle a manager's status between active and inactive.
   *
   * @param {string} uid - The manager's UID.
   * @param {string} currentStatus - Current status ('active' or 'inactive').
   * @returns {Promise<object>} Confirmation from the backend.
   */
  const toggleStatus = useCallback(
    async (uid, currentStatus) => {
      const newStatus =
        currentStatus === STATUS.ACTIVE ? STATUS.INACTIVE : STATUS.ACTIVE;
      setToggling(uid);
      try {
        const result = await callUpdateUserStatus({ uid, status: newStatus });
        await fetchManagers();
        return result;
      } finally {
        setToggling(null);
      }
    },
    [fetchManagers],
  );

  return {
    managers,
    loading,
    error,
    creating,
    toggling,
    createManager,
    toggleStatus,
    refresh: fetchManagers,
  };
}
