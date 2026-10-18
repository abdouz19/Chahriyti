import React, { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Button, Modal, Spinner, EmptyState, Input } from '../../../components/ui';
import { getLeadsAgents } from '../../../services/firestore';
import { callCreateLeadsAgent, callSetLeadsAgentStatus } from '../../../services/functions';
import { formatLeadDate } from '../../leads/leadStatus';
import { LeadAvatar } from '../../leads/components/LeadBits';

// Readable random password: no look-alike characters (0/O, 1/l/I)
function generatePassword() {
  const chars = 'ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
  const bytes = new Uint32Array(12);
  crypto.getRandomValues(bytes);
  return Array.from(bytes, (b) => chars[b % chars.length]).join('');
}

async function copy(text, message) {
  try {
    await navigator.clipboard.writeText(text);
    toast.success(message);
  } catch {
    toast.error('تعذر النسخ');
  }
}

function CreateAgentModal({ isOpen, onClose, onCreated }) {
  const [form, setForm] = useState({ displayName: '', email: '', password: '' });
  const [saving, setSaving] = useState(false);
  const [created, setCreated] = useState(null);

  useEffect(() => {
    if (isOpen) {
      setForm({ displayName: '', email: '', password: generatePassword() });
      setCreated(null);
    }
  }, [isOpen]);

  const set = (key) => (e) => setForm((f) => ({ ...f, [key]: e.target.value }));

  const submit = async (e) => {
    e.preventDefault();
    setSaving(true);
    try {
      await callCreateLeadsAgent(form);
      setCreated({ email: form.email.trim().toLowerCase(), password: form.password });
      onCreated();
    } catch (err) {
      toast.error(err.message || 'فشل إنشاء الحساب');
    } finally {
      setSaving(false);
    }
  };

  if (created) {
    const credentials = `رابط الدخول: ${window.location.origin}/login\nالبريد: ${created.email}\nكلمة المرور: ${created.password}`;
    return (
      <Modal isOpen={isOpen} onClose={onClose} title="تم إنشاء الحساب">
        <div className="space-y-4">
          <p className="text-sm text-text-secondary">
            أرسل بيانات الدخول هذه للشخص. لن تظهر كلمة المرور مرة أخرى.
          </p>
          <div className="rounded-xl bg-surface p-4 space-y-2 text-sm">
            <div className="flex justify-between gap-4"><span className="text-text-secondary">البريد</span><span dir="ltr" className="font-medium">{created.email}</span></div>
            <div className="flex justify-between gap-4"><span className="text-text-secondary">كلمة المرور</span><span dir="ltr" className="font-mono font-medium">{created.password}</span></div>
          </div>
          <div className="flex gap-2 justify-end">
            <Button variant="secondary" onClick={onClose}>إغلاق</Button>
            <Button variant="primary" onClick={() => copy(credentials, 'تم نسخ بيانات الدخول')}>نسخ بيانات الدخول</Button>
          </div>
        </div>
      </Modal>
    );
  }

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="إضافة متابع للمسجلين">
      <form onSubmit={submit} className="space-y-4">
        <p className="text-sm text-text-secondary">
          هذا الحساب يرى صفحة المسجلين فقط، ويمكنه تغيير حالاتهم.
        </p>
        <Input label="الاسم" value={form.displayName} onChange={set('displayName')} required autoFocus />
        <Input label="البريد الإلكتروني" type="email" dir="ltr" value={form.email} onChange={set('email')} required />
        <div className="flex flex-col gap-1.5">
          <label className="text-sm font-medium text-text-primary">كلمة المرور</label>
          <div className="flex gap-2">
            <input
              value={form.password}
              onChange={set('password')}
              minLength={8}
              required
              dir="ltr"
              className="input-field font-mono flex-1"
            />
            <Button type="button" variant="secondary" onClick={() => setForm((f) => ({ ...f, password: generatePassword() }))}>
              توليد
            </Button>
          </div>
        </div>
        <div className="flex gap-2 justify-end pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>إلغاء</Button>
          <Button type="submit" variant="primary" loading={saving}>إنشاء الحساب</Button>
        </div>
      </form>
    </Modal>
  );
}

/**
 * Team page — admin creates and manages leads agents (leads page access only).
 */
export function TeamPage() {
  const [agents, setAgents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showCreate, setShowCreate] = useState(false);
  const [togglingId, setTogglingId] = useState(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      setAgents(await getLeadsAgents());
    } catch {
      setError('فشل تحميل الفريق');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  const toggle = async (agent) => {
    const status = agent.status === 'inactive' ? 'active' : 'inactive';
    setTogglingId(agent.id);
    try {
      await callSetLeadsAgentStatus({ uid: agent.id, status });
      toast.success(status === 'active' ? 'تم تفعيل الحساب' : 'تم تعطيل الحساب');
      load();
    } catch (err) {
      toast.error(err.message || 'فشل تحديث الحساب');
    } finally {
      setTogglingId(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-text-primary">فريق العمل</h1>
          <p className="text-text-secondary mt-1">حسابات تصل إلى صفحة المسجلين فقط</p>
        </div>
        <Button
          variant="primary"
          onClick={() => setShowCreate(true)}
          icon={
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
          }
        >
          إضافة عضو
        </Button>
      </div>

      {loading && agents.length === 0 ? (
        <div className="flex justify-center py-16"><Spinner size="lg" /></div>
      ) : error ? (
        <div className="text-center py-16 text-negative">{error}</div>
      ) : agents.length === 0 ? (
        <EmptyState
          title="لا يوجد أعضاء بعد"
          description="أضف أشخاصاً لمتابعة المسجلين والتواصل معهم"
          action={{ label: 'إضافة عضو', onClick: () => setShowCreate(true) }}
        />
      ) : (
        <div className="rounded-2xl border border-border bg-white shadow-card overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm text-right whitespace-nowrap">
              <thead>
                <tr className="border-b border-border bg-surface/70">
                  {['العضو', 'الصلاحية', 'الحالة', 'تاريخ الإضافة', ''].map((h, i) => (
                    <th key={i} className="px-5 py-3 text-xs font-semibold text-text-secondary">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-divider">
                {agents.map((agent) => {
                  const active = agent.status !== 'inactive';
                  return (
                    <tr key={agent.id} className={`hover:bg-surface/80 transition-colors ${active ? '' : 'opacity-60'}`}>
                      <td className="px-5 py-3">
                        <div className="flex items-center gap-3">
                          <LeadAvatar name={agent.displayName} />
                          <div>
                            <div className="font-semibold text-text-primary">{agent.displayName}</div>
                            <div className="text-xs text-text-secondary text-right" dir="ltr">{agent.email}</div>
                          </div>
                        </div>
                      </td>
                      <td className="px-5 py-3">
                        <span className="px-2 py-0.5 rounded-md text-xs font-medium bg-primary/10 text-primary">المسجلون فقط</span>
                      </td>
                      <td className="px-5 py-3">
                        <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold ring-1 ring-inset ${
                          active ? 'bg-emerald-50 text-emerald-700 ring-emerald-200' : 'bg-slate-100 text-slate-600 ring-slate-200'
                        }`}>
                          <span className={`w-1.5 h-1.5 rounded-full ${active ? 'bg-emerald-500' : 'bg-slate-400'}`} />
                          {active ? 'نشط' : 'معطل'}
                        </span>
                      </td>
                      <td className="px-5 py-3 text-text-secondary">{formatLeadDate(agent.createdAt)}</td>
                      <td className="px-5 py-3 text-left">
                        <button
                          onClick={() => toggle(agent)}
                          disabled={togglingId === agent.id}
                          className={`px-3 py-1.5 rounded-lg text-xs font-semibold ring-1 ring-inset transition-colors disabled:opacity-50 ${
                            active
                              ? 'text-red-600 ring-red-200 hover:bg-red-50'
                              : 'text-primary ring-primary/20 hover:bg-primary/10'
                          }`}
                        >
                          {active ? 'تعطيل' : 'تفعيل'}
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      <CreateAgentModal isOpen={showCreate} onClose={() => setShowCreate(false)} onCreated={load} />
    </div>
  );
}
