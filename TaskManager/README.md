# StudentConnect

**StudentConnect** is a cross-platform Flutter application built to streamline academic project management and team collaboration. Designed for students, researchers, and university project teams, StudentConnect simplifies workspace organization, milestone tracking, task delegation, team communication, and project documentation.

---

## 🌟 Key Features

1. **Authentication & Profile Management**
   - Secure Google Sign-In powered by Firebase Authentication.
   - Synchronized user profiles and avatars stored in Cloud Firestore.

2. **Project & Workspace Management**
   - Create multi-member academic workspaces (capstones, assignments, research).
   - Real-time project progress calculation and visual completion indicators.
   - Dynamic team lead identification and creation date tracking.

3. **Task Delegation & Tracking**
   - Break projects down into actionable tasks with due dates and timestamps.
   - Assign tasks to specific teammates.
   - Categorize tasks by status: *Assigned*, *In Progress*, and *Completed*.
   - Filter and view tasks in real-time across all projects.

4. **Team Collaboration & Communication**
   - Real-time task comment threads for context-specific discussions.
   - In-app Project Documentation hub for storing requirements, notes, and meeting logs.
   - Automated email notifications to teammates when invited to a project via EmailJS.

5. **Notification System**
   - Daily deadline reminders for pending tasks.
   - Foreground, background, and terminated push notifications via Firebase Cloud Messaging (FCM).
   - Local system notification banners with Flutter Local Notifications.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `>=3.2.6 <4.0.0`)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Event-Driven State Architecture)
- **Navigation & DI**: [GetX](https://pub.dev/packages/get) & [get_it](https://pub.dev/packages/get_it)
- **Backend & Cloud Database**:
  - [Cloud Firestore](https://firebase.google.com/docs/firestore) (NoSQL Real-time database)
  - [Firebase Auth](https://firebase.google.com/docs/auth) (Google OAuth)
  - [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) (FCM)
- **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Email Service**: [EmailJS REST API](https://www.emailjs.com/)

---

## 📂 Project Structure

```
TaskManager/
├── lib/
│   ├── bloc/              # BLoC state management (events, states, blocs)
│   ├── constants/         # Design system tokens (colors, fonts, icons, labels)
│   ├── controllers/       # GetX controllers for active project state
│   ├── data/              # Firebase services, database functions, and EmailJS
│   ├── injection/         # Dependency injection setup (GetIt)
│   ├── notification/      # Push and local notification services
│   ├── routes/            # App routes and page transition declarations
│   ├── screens/           # UI screens (Home, Workspaces, Tasks, Comments, Docs)
│   ├── widgets/           # Modular reusable UI components
│   ├── firebase_options.dart # Platform-specific Firebase configuration
│   └── main.dart          # Application entry point
├── assets/                # Local graphic assets & logos
└── pubspec.yaml           # Dependencies and environment constraints
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Version `>=3.2.6`)
- Android Studio / VS Code / Xcode
- A connected physical device or emulator

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd StudentConnect_Flutter/TaskManager
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📄 License
This project was developed for academic collaboration purposes.
