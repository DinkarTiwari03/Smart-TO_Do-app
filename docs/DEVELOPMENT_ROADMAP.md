# Smart Professor Assistant — Development Roadmap

## Phase Overview

| Phase | Milestone Name | Focus Area | Status |
|---|---|---|---|
| **Phase 1** | **Foundation & Project Architecture** | Clean Architecture, Material 3 Theme, GoRouter Navigation, Drift SQLite setup, Dio Networking, Test Suite | **COMPLETED** |
| **Phase 2** | **Task & Academic Deadline Management** | Task Drift schema, Task CRUD, Priority matrix, Course/Semester tags, Deadline filters | Scheduled |
| **Phase 3** | **Smart AI Assistant Engine** | LLM API integration, Chat history schema, Academic prompt templates, Streaming responses | Scheduled |
| **Phase 4** | **Academic Writing & Editing Suite** | Paper drafting, Abstract generator, Letter of recommendation builder, Markdown export | Scheduled |
| **Phase 5** | **Document & Syllabus Vault** | PDF/Document attachment manager, Search indexing, Syllabus parser | Scheduled |
| **Phase 6** | **Notifications, Calendar & Analytics** | Local academic alerts, Google Calendar/iCal integration, Teaching productivity analytics | Scheduled |
| **Phase 7** | **Release Polish, Security & Distribution** | Biometric lock, Encrypted backups, Android APK/AAB release packaging | Scheduled |

---

## Detailed Next Steps for Phase 2: Tasks & Deadlines
1. Define `TasksTable` and `CourseTagsTable` in Drift under `lib/features/tasks/data/tables/`.
2. Generate Drift migration from schema version 1 to 2 in `AppDatabase`.
3. Implement `TaskEntity`, `TaskRepository` contract in `lib/features/tasks/domain/`.
4. Implement `TaskRepositoryImpl` and Riverpod providers in `lib/features/tasks/presentation/`.
5. Build Task List UI, Task Creator dialog, Filter chips, and sorting controls.
