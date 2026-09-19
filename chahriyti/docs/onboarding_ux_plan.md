# خطة UX/UI — إعادة تصميم شاشات الأونبوردينغ

**التاريخ:** سبتمبر 2026  
**الحالة:** مقترح — في انتظار الموافقة قبل التنفيذ

---

## 1. نظرة عامة على التغيير

### الفلسفة الجديدة
الفلسفة القديمة: "أقنعني بالتطبيق" → قائمة فوائد + ترويج للكتاب  
الفلسفة الجديدة: **"أخبرني عن نفسك حتى أجهّز التجربة لك"**

هذا تحول جوهري من onboarding تحفيزي إلى onboarding شخصي (personalized). المستخدم يشعر أنه يُبنى له شيء مخصص، لا أنه يقرأ نشرة إعلانية.

---

## 2. الفلو الجديد

```
[1] Welcome (احتفظ به)
     ↓
[2] معلوماتك الشخصية — الاسم + الولاية + الهاتف
     ↓
[3] فئتك العمرية — hook تحفيزي + radio buttons
     ↓
[4] وضعك المالي — الراتب + الحالة الاجتماعية + عادات المصاريف
     ↓
[5] لماذا شهريتي؟ — multi-select (أهدافك من التطبيق)
     ↓
[6] مبروك! — احتفالية + CTA كود التفعيل
```

**الشاشات التي تُحذف من الفلو القديم:**
- `OnboardingExclusivePage` → تُحذف
- `ValuePropositionPage` → تُحذف (محتواها انتقل إلى شاشة 5 كـ multi-select)
- `OnboardingCtaPage` → تُندمج في شاشة 6

**ما يبقى من الكود الحالي ويُعاد استخدامه:**
- `SalarySetupPage`: الحقول تُوزَّع على شاشتي 2 و4
- `OnboardingCubit`: يُعاد كتابته ليدعم الحالة الجديدة
- `Wilayas.all`: يُستخدم في شاشة 2
- أنيميشن الـ fade/slide الموجود: يُحتفظ به

---

## 3. عناصر التصميم المشتركة

### Progress Indicator
- يظهر في شاشات 2 → 5 فقط (شاشة 6 هي نهاية الرحلة، لا مؤشر)
- 4 نقاط دائرية صغيرة (4px مملوءة = الخطوة الحالية، 4px فارغة = القادمة)
- موقعه: أعلى الشاشة تحت الـ safe area مباشرة، محاذاة للوسط

```
●  ○  ○  ○   ← شاشة 2
●  ●  ○  ○   ← شاشة 3
●  ●  ●  ○   ← شاشة 4
●  ●  ●  ●   ← شاشة 5
```

### Tappable Selection Cards (مكوّن مشترك)
يُستخدم في: شاشة 3 (العمر) + شاشة 4 (الحالة الاجتماعية، عادات المصاريف) + شاشة 5 (الأهداف)

```
┌─────────────────────────────────┐
│  ◉  متزوج ولدي طفل واحد      ▕█▌│  ← selected: خلفية خضراء فاتحة + حد أيمن 3px تيل
├─────────────────────────────────┤
│  ○  أعزب                        │  ← unselected: خلفية بيضاء + حد رمادي
└─────────────────────────────────┘
```

التفاصيل:
- **غير محدد:** خلفية `Colors.white`، حد `AppColors.border (1px)`، زاوية `12px`
- **محدد (radio):** خلفية `AppColors.primary.withOpacity(0.06)`، حد `AppColors.primary (1.5px)`، أيقونة `Icons.radio_button_checked` بلون `AppColors.primary`
- **محدد (checkbox):** نفس الشيء لكن أيقونة `Icons.check_box_rounded`
- **الأنيميشن:** `AnimatedContainer` مع مدة `150ms`، لا مؤثرات مبالغ فيها

### الهيكل العام لكل شاشة
```
SafeArea
  └─ Column
       ├─ ProgressDots (إن وجد)
       ├─ Expanded → SingleChildScrollView
       │    └─ Padding(horizontal: 24)
       │         ├─ SizedBox(height: 32)
       │         ├─ Title
       │         ├─ Subtitle (اختياري)
       │         ├─ SizedBox(height: 28)
       │         └─ المحتوى (fields / cards)
       └─ BottomCTA (خارج الـ scroll، ثابت)
            ├─ ElevatedButton (الرئيسي)
            └─ SizedBox(height: 24)
```

الـ CTA ثابت أسفل الشاشة خارج الـ scroll في كل الشاشات. هذا يمنع المشكلة الشائعة حيث يضطر المستخدم للتمرير للأسفل ليجد الزر.

---

## 4. تفاصيل كل شاشة

---

### شاشة 1 — Welcome (بدون تغيير)
`SplashPage` — يبقى كما هو.

---

### شاشة 2 — معلوماتك الشخصية

**الهدف:** جمع الاسم + الولاية + الهاتف  
**المسار:** `/onboarding/profile`  
**الـ widget الحالي المرتبط:** جزء من `SalarySetupPage` → يُستخرج إلى صفحة مستقلة

**التخطيط:**
```
[ ProgressDots: ● ○ ○ ○ ]

لنجهّز شهريتي لك ✨          ← headlineMedium, primary color
أدخل بعض المعلومات البسيطة  ← bodyMedium, textSecondary
لنبدأ إعداد تجربتك الشخصية

─────────────────────────────
كيف تحب أن نناديك؟           ← labelMedium
[ اكتب اسمك الكامل         ]  ← TextFormField

أين تقيم؟                    ← labelMedium
[ اختر ولايتك ▼            ]  ← bottom sheet (لا dropdown native)

رقم الهاتف                   ← labelMedium
[ 0XXXXXXXXX               ]  ← TextFormField, keyboardType: phone

🔒 نستخدم هذه المعلومات لإنشاء حسابك وحفظ بياناتك وتأمين الوصول  ← bodySmall, textSecondary
─────────────────────────────

[ لنبدأ ← ]
```

**ملاحظات التنفيذ:**
- الولاية: بدل `DropdownButtonFormField` native (68 ولاية تصير مشكلة UX)، نستخدم `GestureDetector` يفتح `showModalBottomSheet` مع `TextField` للبحث + `ListView.builder` للنتائج. أسرع وأنظف.
- التحقق: الاسم (غير فارغ)، الهاتف (يبدأ بـ 0، 10 أرقام)، الولاية (مطلوبة)
- لا نحفظ في DB هنا — كل البيانات تُخزّن في `OnboardingCubit` state حتى الشاشة الأخيرة

---

### شاشة 3 — فئتك العمرية

**الهدف:** hook عاطفي + جمع الفئة العمرية  
**المسار:** `/onboarding/age`

**التخطيط:**
```
[ ProgressDots: ● ● ○ ○ ]

قليل يعرفون أين يذهب مالهم.  ← headlineMedium, textPrimary
اليوم بدأت خطوة مختلفة.       ← bodyLarge, primary, bold

─────────────────────────────

في أي فئة عمرية تقع؟         ← labelLarge, textPrimary

┌──────────────────────────┐
│  ○  من 20 إلى 30 سنة    │
├──────────────────────────┤
│  ○  من 31 إلى 40 سنة    │
├──────────────────────────┤
│  ○  من 41 إلى 50 سنة    │
├──────────────────────────┤
│  ○  أكثر من 50 سنة      │
└──────────────────────────┘

─────────────────────────────
[ ابدأ الآن ]
```

**ملاحظات:**
- الـ hook النصي يُعرض أولاً بـ fade-in خفيف (300ms)، ثم تظهر الـ cards بعدها (200ms delay)
- الزر "ابدأ الآن" مفعّل حتى قبل الاختيار — الفئة العمرية اختيارية (لكن يُحفظ إن اختار)
- نص الزر: "ابدأ الآن" (وليس "التالي") لأنه يُحس أنه لحظة بدء حقيقية

---

### شاشة 4 — وضعك المالي

**الهدف:** الراتب + يوم الاستلام + الحالة الاجتماعية + عادات المصاريف  
**المسار:** `/onboarding/financial`  
**الـ widget الحالي المرتبط:** باقي `SalarySetupPage`

**التخطيط:**
```
[ ProgressDots: ● ● ● ○ ]

أخبرنا عن وضعك المالي        ← headlineMedium, primary

─────────────────────────────
كم يبلغ راتبك الشهري؟

[ 50,000                  دج ]  ← TextFormField, digits only, suffix "دج"

متى تستلم راتبك؟
  [ أول الشهر ]  [ تاريخ محدد ]  ← DayChip (يُعاد استخدام الكود الموجود)

─────────────────────────────
ما هي حالتك الاجتماعية؟

┌──────────────────────────┐
│  ○  أعزب                │
│  ○  متزوج               │
│  ○  متزوج ولدي طفل      │
│  ○  متزوج ولدي طفلان    │
│  ○  متزوج ولدي 3 أطفال  │
│  ○  متزوج ولدي 4+ أطفال │
└──────────────────────────┘

─────────────────────────────
هل تكتب مصاريفك وتتابعها؟

┌──────────────────────────┐
│  ○  نعم، أكتب وأتابع    │
│  ○  لا، لا أكتب         │
└──────────────────────────┘

─────────────────────────────
[ التالي ]
```

**ملاحظات:**
- الراتب إلزامي، باقي الأسئلة اختيارية (الزر يبقى مفعّلاً دائماً)
- الـ scroll يعمل لأن المحتوى طويل — لكن الزر ثابت أسفل الشاشة
- يوم الاستلام: يُعاد استخدام `_DayChip` من `SalarySetupPage` الحالية

---

### شاشة 5 — لماذا شهريتي؟

**الهدف:** multi-select أهداف المستخدم  
**المسار:** `/onboarding/goals`

**التخطيط:**
```
[ ProgressDots: ● ● ● ● ]

لماذا تريد استعمال شهريتي؟   ← headlineMedium, primary
اختر كل ما ينطبق عليك        ← bodyMedium, textSecondary

─────────────────────────────
┌──────────────────────────────┐
│ ☐  معرفة رصيدي الحقيقي     │  ← checkbox card
│ ☑  تسجيل مصاريفي بسهولة    │  ← selected
│ ☐  معرفة أين يذهب راتبي    │
│ ☐  التخطيط لأهدافي المالية │
│ ☐  متابعة ديوني والتزاماتي │
│ ☐  تحديد سقف يومي آمن      │
│ ☐  بناء مدخراتي تدريجياً   │
│ ☐  تسجيل مصادر دخلي        │
│ ☐  متابعة إحصائياتي        │
│ ☐  قرارات مبنية على أرقام  │
└──────────────────────────────┘

─────────────────────────────
[ التالي ]   ← يعمل حتى دون اختيار (skip ضمني)
```

**ملاحظات:**
- Multi-select: يمكن اختيار أكثر من خيار
- الاختيارات تُخزّن كـ `List<String>` في `OnboardingCubit`
- لا يوجد "اختر على الأقل خياراً واحداً" — التطبيق يقبل حتى بلا اختيار
- الشاشة الأطول في الفلو — يجب أن تكون قابلة للتمرير بسهولة

---

### شاشة 6 — مبروك! أهلاً بك

**الهدف:** احتفالية + CTA للتفعيل  
**المسار:** `/onboarding/welcome`

**هنا تُحفظ كل البيانات في DB** (اسم الراتب والولاية والهاتف والراتب ويوم الراتب)

**التخطيط:**
```
(لا progress indicator)

[ صورة الكتاب — assets/illustrations/225 copy.png ]  ← height: 200

🎉 مبروك! أهلاً بك في شهريتي ❤️   ← headlineMedium, primary, bold
                                       (يُعرض الاسم الشخصي: "أهلاً يا [الاسم]!")

لقد أصبحنا الآن على تواصل معك.   ← bodyMedium, textSecondary
سنقوم بتجهيز حسابك في شهريتي    ← bodyMedium, textSecondary
باسمك ومعلوماتك.

─────────────────────────────
┌──────────────────────────────────────────┐
│  إذا لم يكن لديك الكود بعد، فلا تقلق. │  ← container مع خلفية خضراء فاتحة
│  سنتواصل معك قريباً لمساعدتك وإتمام   │
│  خطوات حصولك على شهريتي.              │
└──────────────────────────────────────────┘

🇩🇿 شهريتي — الرفيق الأول للموظف الجزائري  ← bodySmall, textSecondary, centered

─────────────────────────────
[ 🔑 لدي كود التفعيل ]   ← ElevatedButton رئيسي
```

**ملاحظات:**
- هنا فقط يُستدعى `OnboardingCubit.submit()` الذي يحفظ كل البيانات ثم يروح للـ activation
- الاسم الشخصي في العنوان يعطي لمسة دافئة
- صورة الكتاب هي نفس الـ asset الموجود `assets/illustrations/225 copy.png`
- زر "اطلب نسختك" اختفى من هنا — الـ store URL يمكن الوصول إليه من مكان آخر لاحقاً

---

## 5. هيكل البيانات — ما يُحفظ وأين

### الحقول الحالية في DB (تُحفظ عند الضغط على CTA في شاشة 6)
| الحقل | الشاشة | الحالة |
|---|---|---|
| `fullName` | شاشة 2 | موجود في `UserEntity` ✅ |
| `wilayaCode` | شاشة 2 | موجود في `UserEntity` ✅ |
| `phoneNumber` | شاشة 2 | موجود في `UserEntity` ✅ |
| `monthlySalary` | شاشة 4 | موجود في `UserEntity` ✅ |
| `salaryDay` | شاشة 4 | موجود في `UserEntity` ✅ |

### الحقول الجديدة (تحتاج قرار)
| الحقل | الشاشة | الاقتراح |
|---|---|---|
| `ageGroup` | شاشة 3 | أضفه كـ column جديدة `TEXT NULLABLE` في جدول `users` |
| `maritalStatus` | شاشة 4 | نفس الشيء |
| `tracksExpenses` | شاشة 4 | نفس الشيء |
| `appGoals` | شاشة 5 | أضفها كـ `TEXT` تُخزّن `JSON array` |

**Migration:** الانتقال من `schemaVersion 14` إلى `15`، إضافة 4 أعمدة nullable إلى جدول `users`.

**البديل الأبسط:** لا تُضف أعمدة جديدة — احتفظ بالبيانات في `OnboardingCubit` فقط ولا تحفظها. تُستخدم فقط لتخصيص رسالة شاشة 6 أو لاحقاً في analytics. **هذا هو التوصية إذا كنت تريد تسريع التنفيذ.**

---

## 6. الـ OnboardingCubit — الحالة الجديدة

### States الجديدة
```dart
// Replaces current OnboardingState hierarchy
sealed class OnboardingState { ... }

class OnboardingProfile extends OnboardingState {}        // شاشة 2
class OnboardingAgeGroup extends OnboardingState {}       // شاشة 3
class OnboardingFinancial extends OnboardingState {}      // شاشة 4
class OnboardingGoals extends OnboardingState {}          // شاشة 5
class OnboardingCelebration extends OnboardingState {     // شاشة 6
  final String firstName;
}
class OnboardingLoading extends OnboardingState {}
class OnboardingError extends OnboardingState { final String message; }
class OnboardingDone extends OnboardingState {}           // → /activation
```

### البيانات المجمّعة في الـ Cubit
```dart
// Internal state held throughout the wizard
String _name = '';
String _phone = '';
int _wilayaCode = 16;
String? _ageGroup;          // nullable — اختياري
int _salary = 0;
int _salaryDay = 1;
String? _maritalStatus;     // nullable — اختياري
bool? _tracksExpenses;      // nullable — اختياري
List<String> _goals = [];   // قد تكون فارغة
```

---

## 7. الأنيميشن

### ما يُضاف
- **Screen transitions:** `PageRouteBuilder` مع slide من اليسار لليمين (RTL: من اليمين للشمال) بـ `300ms easeOut`. بسيط ومتسق.
- **Selection cards:** `AnimatedContainer` على تغيير اللون `150ms` — موجود بالفعل في `_DayChip`، يُعاد استخدام نفس النمط.
- **شاشة 6 (احتفالية):** fade-in للمحتوى مع delay طفيف (نفس نمط `OnboardingExclusivePage` الحالي).

### ما لا يُضاف
- لا confetti، لا particle effects — تبدو مصنوعة بـ AI وتثقّل الشاشة
- لا staggered animations معقدة في شاشات الإدخال — تُشتّت المستخدم عن الحقول

---

## 8. الراوتر — التغييرات المطلوبة

### الراوتات الجديدة
```
/onboarding/profile   ← جديد (شاشة 2)
/onboarding/age       ← جديد (شاشة 3)
/onboarding/financial ← جديد (شاشة 4، يحل محل /onboarding/salary)
/onboarding/goals     ← جديد (شاشة 5)
/onboarding/welcome   ← جديد (شاشة 6)
```

### الراوتات التي تُحذف
```
/onboarding/exclusive  ← يُحذف
/onboarding/value      ← يُحذف
/onboarding/cta        ← يُحذف
/onboarding/salary     ← يُحذف (يُستعاض عنه بـ /onboarding/financial)
```

### تحديث redirect guard
```dart
// في app_router.dart
const onboardingPaths = [
  '/',
  '/onboarding/profile',
  '/onboarding/age',
  '/onboarding/financial',
  '/onboarding/goals',
  '/onboarding/welcome',
];
```

---

## 9. نقاط مفتوحة — تحتاج قرارك

| السؤال | الخيار A | الخيار B |
|---|---|---|
| هل نحفظ الحقول الجديدة (عمر، حالة اجتماعية، أهداف)؟ | نعم، migration لـ schemaVersion 15 | لا، in-memory فقط |
| الولاية — كيف يختارها؟ | Bottom sheet مع بحث (تجربة أفضل) | Dropdown native (أسرع في التنفيذ) |
| هل يوم الراتب يبقى في شاشة 4؟ | نعم، تحت حقل الراتب | لا، ينتقل للـ financial setup لاحقاً |
| شاشة "اطلب نسختك" (store URL)؟ | تُحذف من الأونبوردينغ نهائياً | تبقى كـ button ثانوي في شاشة 6 |

---

## 10. ملخص التنفيذ بالترتيب

1. **أضف `OnboardingCubit` state الجديد** وبياناته الداخلية
2. **أضف الراوتات الجديدة** وأزل القديمة من `app_router.dart`
3. **نفّذ شاشة 2** (Profile) — استخرج الحقول من `SalarySetupPage`
4. **نفّذ شاشة 3** (AgeGroup) — hook + radio cards
5. **نفّذ شاشة 4** (Financial) — استكمل حقول `SalarySetupPage` + حالة اجتماعية + عادات
6. **نفّذ شاشة 5** (Goals) — multi-select
7. **نفّذ شاشة 6** (Celebration) — احتفالية + CTA
8. **إذا قررت حفظ الحقول الجديدة:** migration + تحديث `UserEntity` + `UserRepository`
9. **احذف الشاشات القديمة:** `OnboardingExclusivePage`، `ValuePropositionPage`، `OnboardingCtaPage`، `SalarySetupPage`
