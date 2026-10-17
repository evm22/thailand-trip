# חיבור האתר ל-Supabase

פעם אחת, בערך 10 דקות:

1. נכנסים ל-[supabase.com](https://supabase.com), פותחים חשבון חינמי ו-**New project**.
2. **SQL Editor** → מדביקים את כל התוכן של [`schema.sql`](schema.sql) → **Run**.
3. **Authentication → Sign In / Providers**: מכבים את **Allow new users to sign up**, כדי שרק מי שהוספתם יוכל להיכנס.
4. **Authentication → Users → Add user → Create new user**: משתמש (אימייל + סיסמה) לכל נוסע. מסמנים **Auto Confirm User**.
5. **Project Settings → API**: מעתיקים את **Project URL** ואת המפתח **anon public**, ושמים אותם ב-`index.html` ב-`SB_URL` וב-`SB_KEY`.
   המפתח הזה ציבורי בכוונה ומותר שיהיה בריפו. מה שמגן על הנתונים הם חוקי ה-RLS ב-`schema.sql`.
   **אסור** לשים בקוד את המפתח `service_role`.

## מה קורה בכניסה הראשונה

- הכניסה הראשונה (מכל מכשיר) מעלה ל-Supabase את מה ששמור בדפדפן, וכשהשרת עוד ריק, גם את מה שנשאר בשרתי הסנכרון הישנים (npoint ו-extendsclass), באיחוד לפי מזהה, כדי שלא יאבד אף פריט.
- קבצים מצורפים שהיו ב-npoint מועתקים ל-Supabase Storage (bucket פרטי בשם `trip-files`).
- שרתי npoint ו-extendsclass לא נמחקים ולא נכתבים יותר. מומלץ ללחוץ קודם על "☁️ גיבוי מלא מהענן" ולשמור את הקובץ.
