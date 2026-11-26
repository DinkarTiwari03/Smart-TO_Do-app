# Smart Professor Assistant — System Architecture

## 1. Architectural Philosophy
Smart Professor Assistant adopts **Clean Architecture** organized with a **feature-first (modular)** hierarchy. This guarantees strict separation of concerns, testability, maintainability, and clean dependency boundaries across future development phases.

```
lib/
├── app.dart                   # Root MaterialApp with theme & router bindings
├── main.dart                  # Application entry point with ProviderScope
├── core/                      # Global cross-cutting infrastructure
│   ├── constants/             # App-wide string, timeout, and configuration constants
│   ├── database/              # Drift SQLite setup, connection management, migrations
│   │   ├── app_database.dart
│   │   ├── base_repository.dart
│   │   ├── connection/
│   │   └── tables/
│   ├── errors/                # App-level exceptions & failure objects
│   ├── network/               # Dio HTTP client, interceptors, error mapping
│   ├── router/                # GoRouter configuration with StatefulShellRoute
│   ├── theme/                 # Material 3 Academic theme, typography, color palette
│   ├── utils/                 # General-purpose utility functions
│   └── widgets/               # Reusable atomic UI components (Card, Button, Field, Shell)
├── features/                  # Domain-specific feature modules
│   ├── dashboard/             # Academic overview & quick stats
│   ├── tasks/                 # Task and grading deadline management
│   ├── ai_assistant/          # Academic LLM conversational assistant
│   ├── writing_assistant/     # Paper, letter, and review drafting suite
│   ├── documents/             # Syllabus and research paper vault
│   ├── notifications/         # Deadline alerts and academic reminders
│   └── settings/              # Appearance, storage diagnostics, preferences
└── shared/                    # Cross-feature shared abstractions
    ├── models/
    ├── providers/
    └── services/
```

## 2. Layer Definitions within Features
Each feature in `lib/features/<feature_name>/` follows the three-tier Clean Architecture model:
1. **Domain Layer**:
   - Pure Dart entities representing business concepts.
   - Abstract repository contracts defining data operations.
   - Use cases encapsulate business workflows.
2. **Data Layer**:
   - Drift database DAO implementations and data sources (local SQLite and remote APIs).
   - Data transfer models (DTOs) and entity mappers.
   - Concrete repository implementations fulfilling domain contracts.
3. **Presentation Layer**:
   - Riverpod StateNotifier / Notifier providers holding UI state.
   - Stateless and Consumer widgets rendering responsive Material 3 components.

## 3. Technology Stack & Technical Decisions
- **Framework**: Flutter 3.29.1 / Dart 3.7.0.
- **State Management**: `flutter_riverpod` (v2.6.1) with ProviderScope dependency injection.
- **Routing & Navigation**: `go_router` (v14.8.1) utilizing `StatefulShellRoute.indexedStack` for seamless persistent bottom navigation across top-level destinations.
- **Local Persistence**: `drift` (v2.28.2) + `sqlite3_flutter_libs` + `path_provider` for cross-platform ACID-compliant relational SQLite storage with reactive queries and automated migrations.
- **Local Notifications & Timezone Engine**: `flutter_local_notifications` (v18.0.1) + `timezone` (v0.10.1) + `flutter_timezone` (v4.1.1) abstracted behind `LocalNotificationGateway` and orchestrated by `DeadlineNotificationEngine`.
- **Networking**: `dio` (v5.11.1) equipped with custom `NetworkInterceptor` for timeout handling, authentication headers, and automatic exception translation.
- **UI Design System**: Material 3 with an **Academic Navy & Accent Bronze** palette, consistent 8pt grid scale (`AppDimensions`), and hierarchy typography (`AppTypography`).

## 4. Dashboard & Notification Architecture (Phase 3)
- **Reactive Dashboard**: `dashboardSummaryProvider` watches `allTasksStreamProvider` and `categoriesMapProvider`, computing `DashboardSummary` (totals, pending, completed, overdue, priority breakdown, today's tasks, and 7-day upcoming deadlines) using the device's local calendar day.
- **Automatic Deadline Notification Engine (`DeadlineNotificationEngine`)**:
  - Hooks into `TaskRepositoryImpl` so every task creation, edit, deadline update, priority change, completion, reopening, and deletion automatically synchronizes local Android notifications.
  - Uses deterministic 31-bit FNV-1a IDs derived from `(taskId, reminderType)` to prevent duplicate scheduling and enable exact cancellation.
  - Persists scheduling metadata in `scheduled_notifications_table` to prevent overdue notification spam and reconcile pending alarms on startup, app resume, timezone shifts, and settings updates.
  - Handles Android 13+ notification permissions (`POST_NOTIFICATIONS`) and Android 12+/14+ exact-alarm restrictions (`SCHEDULE_EXACT_ALARM`) with automatic fallback to `inexactAllowWhileIdle`.
