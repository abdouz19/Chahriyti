import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../../hooks/useAuth';
import { Button, Input } from '../../../components/ui';
import { validateEmail, validatePassword } from '../../../utils/validators';
import { ROLES } from '../../../config/constants';

/**
 * Login page — email/password form with Chahriyti branding
 */
export function LoginPage() {
  const { signIn } = useAuth();
  const navigate = useNavigate();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState({});
  const [serverError, setServerError] = useState('');
  const [loading, setLoading] = useState(false);

  const validate = () => {
    const newErrors = {};
    const emailErr = validateEmail(email);
    const passErr = validatePassword(password);
    if (emailErr) newErrors.email = emailErr;
    if (passErr) newErrors.password = passErr;
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setServerError('');

    if (!validate()) return;

    setLoading(true);
    try {
      const { role } = await signIn(email, password);
      // Route to correct portal based on role
      if (role === ROLES.ADMIN) {
        navigate('/admin', { replace: true });
      } else {
        navigate('/manager', { replace: true });
      }
    } catch (err) {
      setServerError(err.message || 'حدث خطأ أثناء تسجيل الدخول');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-surface flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo + branding */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl bg-primary flex items-center justify-center mx-auto mb-4">
            <span className="text-white font-bold text-2xl">ش</span>
          </div>
          <h1 className="text-2xl font-bold text-text-primary">شهريتي</h1>
          <p className="text-text-secondary mt-1">منصة إدارة التراخيص</p>
        </div>

        {/* Login form */}
        <form onSubmit={handleSubmit} className="card-elevated space-y-5">
          <div>
            <h2 className="text-lg font-semibold text-text-primary mb-1">تسجيل الدخول</h2>
            <p className="text-sm text-text-secondary">أدخل بياناتك للمتابعة</p>
          </div>

          {/* Server error */}
          {serverError && (
            <div className="bg-negative/5 border border-negative/20 rounded-xl px-4 py-3 text-sm text-negative">
              {serverError}
            </div>
          )}

          <Input
            label="البريد الإلكتروني"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            error={errors.email}
            placeholder="example@email.com"
            icon={
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round"
                  d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75" />
              </svg>
            }
          />

          <Input
            label="كلمة المرور"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            error={errors.password}
            placeholder="••••••••"
            icon={
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round"
                  d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" />
              </svg>
            }
          />

          <Button
            type="submit"
            variant="primary"
            fullWidth
            loading={loading}
          >
            دخول
          </Button>
        </form>

        {/* Footer */}
        <p className="text-center text-xs text-text-secondary mt-6">
          شهريتي &copy; {new Date().getFullYear()}
        </p>
      </div>
    </div>
  );
}
