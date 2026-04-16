# Implement All Screen Designs

## Goal Description
Create the full set of UI screens for all three roles (Institute, Parent, Student) as defined in the Stitch project, wire up navigation, and add ViewModel stubs following Clean MVVM architecture. All screens will reuse the common widgets already created.

## User Review Required
> [!IMPORTANT]
> Please confirm that you want to generate **all** screens listed in the implementation plan and that the navigation should start at the login screen, then route to role‑specific home dashboards based on the logged‑in user.

## Proposed Changes
---
### Navigation & Routing
- **[MODIFY] lib/config/app_routes.dart** – Define route names for every screen.
- **[MODIFY] lib/config/app_pages.dart** – Register GetX pages linking routes to screen widgets.
- **[MODIFY] lib/main.dart** – Initialize GetX, set initial route to `/login`.

### ViewModel Stubs
- **[NEW] lib/presentation/parent/viewmodel/parent_dashboard_viewmodel.dart** – Placeholder ViewModel for ParentDashboard.
- **[NEW] lib/presentation/parent/viewmodel/fees_viewmodel.dart** – Placeholder for FeesScreen.
- **[NEW] lib/presentation/parent/viewmodel/attendance_viewmodel.dart** – Placeholder for AttendanceScreen.
- **[NEW] lib/presentation/student/viewmodel/...** – Similar stubs for each Student screen.
- **[NEW] lib/presentation/institute/viewmodel/...** – Similar stubs for Institute screens.

### Parent Module Screens
- **[NEW] lib/presentation/parent/view/fees_screen.dart** (already created)
- **[NEW] lib/presentation/parent/view/attendance_screen.dart** (already created)
- **[NEW] lib/presentation/parent/view/reports_screen.dart**
- **[NEW] lib/presentation/parent/view/settings_screen.dart**
- **[NEW] lib/presentation/parent/view/notifications_screen.dart**
- **[NEW] lib/presentation/parent/view/student_switcher.dart**
- **[NEW] lib/presentation/parent/view/homework_center.dart**

### Student Module Screens
- **[NEW] lib/presentation/student/view/dashboard.dart**
- **[NEW] lib/presentation/student/view/fees_screen.dart**
- **[NEW] lib/presentation/student/view/attendance_screen.dart**
- **[NEW] lib/presentation/student/view/reports_screen.dart**
- **[NEW] lib/presentation/student/view/settings_screen.dart**
- **[NEW] lib/presentation/student/view/notifications_screen.dart**
- **[NEW] lib/presentation/student/view/homework_center.dart**

### Institute Module Screens
- **[NEW] lib/presentation/institute/view/dashboard.dart**
- **[NEW] lib/presentation/institute/view/fees_screen.dart**
- **[NEW] lib/presentation/institute/view/attendance_screen.dart**
- **[NEW] lib/presentation/institute/view/reports_screen.dart**
- **[NEW] lib/presentation/institute/view/settings_screen.dart**
- **[NEW] lib/presentation/institute/view/notifications_screen.dart**
- **[NEW] lib/presentation/institute/view/contact_screen.dart**

### Shared Assets & Widgets
- Ensure all screens import the common widgets (`glass_card.dart`, `primary_button.dart`, `quick_action_card.dart`, `carousel.dart`, `bottom_nav.dart`).
- Update `pubspec.yaml` if any new assets are required.

---
## Open Questions
> [!WARNING]
> - Do you prefer a **bottom navigation bar** for all roles, or should the Institute role use a **drawer** navigation?
> - Any specific naming convention for ViewModel classes (e.g., `ParentDashboardViewModel` vs `ParentDashboardVM`)?

## Verification Plan
### Automated Tests
- Run `flutter pub get` and `flutter analyze` after generation.
- Ensure no duplicate imports or naming conflicts.

### Manual Verification
- Launch the app, log in as each role, and verify navigation to the correct home dashboard and ability to access each screen via the bottom nav.

---
