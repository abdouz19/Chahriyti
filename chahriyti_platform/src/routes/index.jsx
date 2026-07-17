import { lazy, Suspense } from 'react';
import { createBrowserRouter, Navigate } from 'react-router-dom';
import { ProtectedRoute } from './ProtectedRoute';
import { Spinner } from '../components/ui';
import { ROLES } from '../config/constants';

// Lazy-loaded layouts
const AdminLayout = lazy(() =>
  import('../components/layout/AdminLayout').then(m => ({ default: m.AdminLayout }))
);
const ManagerLayout = lazy(() =>
  import('../components/layout/ManagerLayout').then(m => ({ default: m.ManagerLayout }))
);

// Lazy-loaded pages — Auth
const LoginPage = lazy(() =>
  import('../features/auth/pages/LoginPage').then(m => ({ default: m.LoginPage }))
);

// Lazy-loaded pages — Manager portal
const GenerateLicensePage = lazy(() =>
  import('../features/license/pages/GenerateLicensePage').then(m => ({ default: m.GenerateLicensePage }))
);
const ClientsPage = lazy(() =>
  import('../features/clients/pages/ClientsPage').then(m => ({ default: m.ClientsPage }))
);
const ManagerDashboardPage = lazy(() =>
  import('../features/dashboard/pages/ManagerDashboardPage').then(m => ({ default: m.ManagerDashboardPage }))
);

// Lazy-loaded pages — Admin portal
const AdminDashboardPage = lazy(() =>
  import('../features/dashboard/pages/AdminDashboardPage').then(m => ({ default: m.AdminDashboardPage }))
);
const ManagersPage = lazy(() =>
  import('../features/managers/pages/ManagersPage').then(m => ({ default: m.ManagersPage }))
);

/** Loading fallback for lazy-loaded routes */
function PageLoader() {
  return (
    <div className="flex items-center justify-center min-h-[400px]">
      <Spinner size="lg" />
    </div>
  );
}

/** Wrap lazy component in Suspense */
function LazyPage({ children }) {
  return <Suspense fallback={<PageLoader />}>{children}</Suspense>;
}

export const router = createBrowserRouter([
  // Login
  {
    path: '/login',
    element: (
      <LazyPage>
        <LoginPage />
      </LazyPage>
    ),
  },

  // Admin portal
  {
    path: '/admin',
    element: (
      <ProtectedRoute allowedRole={ROLES.ADMIN}>
        <LazyPage>
          <AdminLayout />
        </LazyPage>
      </ProtectedRoute>
    ),
    children: [
      { index: true, element: <LazyPage><AdminDashboardPage /></LazyPage> },
      { path: 'managers', element: <LazyPage><ManagersPage /></LazyPage> },
    ],
  },

  // Manager portal
  {
    path: '/manager',
    element: (
      <ProtectedRoute allowedRole={ROLES.MANAGER}>
        <LazyPage>
          <ManagerLayout />
        </LazyPage>
      </ProtectedRoute>
    ),
    children: [
      { index: true, element: <LazyPage><ManagerDashboardPage /></LazyPage> },
      { path: 'generate', element: <LazyPage><GenerateLicensePage /></LazyPage> },
      { path: 'clients', element: <LazyPage><ClientsPage /></LazyPage> },
    ],
  },

  // Root redirect
  { path: '/', element: <Navigate to="/login" replace /> },

  // 404 catch-all
  {
    path: '*',
    element: (
      <div className="min-h-screen bg-surface flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-6xl font-bold text-primary mb-4">404</h1>
          <p className="text-text-secondary mb-6">الصفحة غير موجودة</p>
          <a href="/login" className="btn-primary inline-block">
            العودة لتسجيل الدخول
          </a>
        </div>
      </div>
    ),
  },
]);
