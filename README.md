# INCUE Doctor

INCUE Doctor is a cross-platform Flutter application that gives clinicians a complete, real-time cockpit for managing their practice. It streamlines the entire in-clinic patient journey — from appointment booking and live waiting-room queues to prescriptions, billing, medical records, and patient feedback — backed by a hosted REST API.

The application ships from a single Dart codebase to **Android**, **iOS**, and **Web**.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Environment & Configuration](#environment--configuration)
- [Testing](#testing)
- [Deployment](#deployment)
- [API Overview](#api-overview)
- [Tech Stack](#tech-stack)

---

## Features

- **Authentication & Onboarding** — Phone-number sign-up with OTP verification, login, password reset, and multi-profile support.
- **Live Patient Queues** — Real-time *waiting* and *reached* queues, "send in" and "end appointment" controls, and estimated time-left tracking.
- **Appointment Management** — Single, extra, and batch (multiple) bookings; earliest-slot discovery; available dates and slots; and full booking history.
- **Scheduling & Availability** — Configurable clinic timings, reschedules, delay announcements, and leave management.
- **Clinical Records** — Treatment notes, editable treatments, prescriptions, and medical file upload/download/delete.
- **Billing** — Per-booking balance tracking, installments, dues, and account summaries.
- **Patients** — Searchable patient directory, editable patient details, and per-patient booking history.
- **Feedback & Reviews** — Patient review browsing and in-app feedback capture with emoji ratings.
- **Account** — Profile editing and account deletion.

---

## Architecture

The app follows a **feature-first, layered architecture** built on top of Flutter's widget tree and the `provider` state-management pattern.

```
┌──────────────────────────────────────────────────────────┐
│                        UI Layer                            │
│   lib/screens/**  (feature folders → components/ + views)  │
└───────────────────────────┬──────────────────────────────┘
                            │  reads/writes
┌───────────────────────────▼──────────────────────────────┐
│                     State Layer                            │
│   lib/providers/**  (ChangeNotifier: Appointment, Conn.)   │
└───────────────────────────┬──────────────────────────────┘
                            │  calls
┌───────────────────────────▼──────────────────────────────┐
│                   Data Access Layer                        │
│   requests.dart per feature  +  lib/components/urls.dart   │
│   (http.Client, JSON encode/decode, Basic Auth headers)    │
└───────────────────────────┬──────────────────────────────┘
                            │  serializes into
┌───────────────────────────▼──────────────────────────────┐
│                      Domain Models                         │
│   lib/Models/**  (Doctor, Patient, Booking, Prescription…) │
└───────────────────────────┬──────────────────────────────┘
                            │  HTTPS (REST/JSON)
┌───────────────────────────▼──────────────────────────────┐
│         INCUE Backend  (Google Cloud Run service)          │
└──────────────────────────────────────────────────────────┘
```

**Key conventions**

- **Feature-first screens** — Each feature under `lib/screens/<feature>/` contains its view(s) and a `components/` folder, typically including a `requests.dart` that encapsulates the feature's API calls.
- **State management** — `provider` with `ChangeNotifier`. `AppointmentProvider` holds queue/appointment state; `ConnectionService` provides a shared `http.Client`.
- **Networking** — All endpoints are centralized in `lib/components/urls.dart`. Requests use Basic Auth headers built from stored credentials via `initializeHeader()`.
- **Persistence** — `shared_preferences` caches session state (login flag) and the doctor's profile for fast cold starts (see `_getMetaData()` in `lib/main.dart`).
- **Models** — Plain Dart classes with `fromJson` factories for (de)serialization.

---

## Project Structure

```
doctor-app/
└── doctor/                     # Flutter application root
    ├── lib/
    │   ├── main.dart           # App entry point, providers, routing, bootstrap
    │   ├── components/         # Shared widgets, urls.dart (API endpoints), helpers
    │   ├── providers/          # ChangeNotifier state (appointments, http client)
    │   ├── Models/             # Domain models with JSON serialization
    │   └── screens/            # Feature modules (auth, home, bookings, leaves…)
    ├── assets/                 # Images, icons, fonts
    ├── android/                # Android platform project
    ├── ios/                    # iOS platform project
    ├── web/                    # Web platform project
    ├── test/                   # Widget/unit tests
    ├── firebase.json           # Firebase Hosting config (web)
    ├── .firebaserc             # Firebase project aliases
    └── pubspec.yaml            # Dependencies & asset/font manifest
```

---

## Prerequisites

- **Flutter SDK** with Dart `>=2.12.0 <3.0.0` (Flutter 3.x recommended)
- **Android Studio** / Xcode for native builds
- **Firebase CLI** (for web deployment)
- A configured device, emulator, or simulator

Verify your toolchain:

```bash
flutter doctor
```

---

## Installation

```bash
git clone https://github.com/udbajaj7/doctor-app.git
cd doctor-app/doctor
flutter pub get
```

---

## Running the App

From the `doctor/` directory:

```bash
# List available devices
flutter devices

# Run on the default connected device / emulator
flutter run

# Run on the web (Chrome)
flutter run -d chrome

# Run on a specific device
flutter run -d <device_id>
```

Build release artifacts:

```bash
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle (Play Store)
flutter build ios --release        # iOS
flutter build web --release        # Web
```

---

## Environment & Configuration

This project does not use a `.env` file; configuration is compiled in. The primary values to be aware of:

| Setting | Location | Description |
| --- | --- | --- |
| `siteUrl` | `lib/components/urls.dart` | Base URL of the INCUE backend API (Cloud Run). All endpoints derive from it. |
| Auth header | `lib/components/urls.dart` (`initializeHeader`) | Basic Auth built from the doctor's phone number + password stored in `shared_preferences`. |
| Session/profile cache | `shared_preferences` (`lib/main.dart`) | Persists `isLoggedIn` and profile fields (name, city, fees, IDs, etc.). |
| Firebase project | `.firebaserc` | Default Firebase Hosting project (`incue-doctor`). |
| Android application id | `android/app/build.gradle` | `com.incue.incuedoctor` (targetSdk 33). |

To point the app at a different backend, update `siteUrl` in `lib/components/urls.dart`.

---

## Testing

Widget and unit tests live in `test/`. Run them from the `doctor/` directory:

```bash
# Run the full test suite
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# Static analysis / linting
flutter analyze
```

---

## Deployment

### Web (Firebase Hosting)

The web target is configured to serve from `build/web` (see `firebase.json`) against the `incue-doctor` Firebase project.

```bash
# From the doctor/ directory
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Android (Google Play)

```bash
flutter build appbundle --release
# Upload the generated .aab (build/app/outputs/bundle/release/) to the Play Console
```

### iOS (App Store)

```bash
flutter build ipa --release
# Distribute the archive via Xcode / Transporter to App Store Connect
```

App launcher icons across platforms are generated via `flutter_launcher_icons`:

```bash
flutter pub run flutter_launcher_icons
```

---

## API Overview

The app communicates with the INCUE backend over HTTPS using JSON payloads and **HTTP Basic Authentication**. The base URL and all endpoints are defined in `lib/components/urls.dart`.

**Base URL:** `https://incue-oep43kcksq-el.a.run.app/`

Most doctor-scoped endpoints are namespaced under `/doctor/`.

### Authentication & Account

| Endpoint | Purpose |
| --- | --- |
| `POST /send_otp/` | Send OTP for phone registration |
| `POST /resend_otp/` | Resend OTP |
| `POST /verify_otp/` | Verify OTP |
| `POST /login/` | Doctor login |
| `POST /change_pwd/` | Change password |
| `POST /forget_pwd_send_otp/` | Password-reset OTP |
| `GET  /cities/` | Fetch supported cities |
| `POST /doctor/addDoctor/` | Register/onboard a doctor |
| `POST /doctor/editProfile/` | Update doctor profile |
| `POST /doctor/getDocInfo/` | Fetch doctor info |

### Queues & Live Appointment Flow

| Endpoint | Purpose |
| --- | --- |
| `POST /doctor/getWaitingQueue/` | Waiting-room queue |
| `POST /doctor/getReachedQueue/` | Patients who have arrived |
| `POST /doctor/getCurrentPatient/` | Currently-in-consultation patient(s) |
| `POST /doctor/reachedBtn/` | Mark patient as arrived |
| `POST /doctor/sendInBtn/` | Send next patient in |
| `POST /doctor/endBooking/` | End the current appointment |

### Bookings & Scheduling

| Endpoint | Purpose |
| --- | --- |
| `POST /doctor/addBooking/` | Create a booking |
| `POST /doctor/addBookingExtra/` | Create an extra booking |
| `POST /doctor/addBookingMultiple/` | Batch booking |
| `POST /doctor/cancelBooking/` | Cancel a booking |
| `POST /doctor/getBookings/` | Bookings for the doctor |
| `POST /doctor/getAllBookings/` | All patient bookings |
| `POST /doctor/getEarliestSlot/` | Earliest available slot |
| `POST /doctor/getSlots/` | Available slots |
| `POST /doctor/getAvalDates/` | Available dates |
| `POST /doctor/addReschedule/` | Reschedule a booking |
| `POST /doctor/addRescheduleTimings/` | Add reschedule timings |
| `POST /doctor/getRescheduledTimings/` | Get reschedule timings |
| `POST /doctor/deleteRescheduleTimings/` | Delete reschedule timings |
| `POST /doctor/addDelay/` | Announce a delay |
| `POST /doctor/addLeave/`, `getLeaves/`, `deleteLeave/` | Leave management |

### Patients, Clinical Records & Billing

| Endpoint | Purpose |
| --- | --- |
| `POST /doctor/getAllPatients/` | Patient directory |
| `POST /doctor/editPatientInfo/` | Edit patient details |
| `POST /doctor/addTreatmentNotes/` | Add treatment notes |
| `POST /doctor/editTreatment/` | Edit treatment |
| `POST /doctor/getTreatments/` | Available treatments |
| `POST /doctor/getPrescription/` | Fetch prescription |
| `POST /doctor/addTreatmentFiles/`, `getTreatmentFiles/`, `deleteTreatmentFiles/` | Medical file management |
| `POST /doctor/updateBalance/`, `getBalance/` | Billing / dues |
| `POST /doctor/getReviews/`, `writeFeedback/` | Reviews & feedback |

> **Authentication:** Requests attach a `Basic <base64(phone:password)>` `authorization` header and `Content-Type: application/json`, constructed by `initializeHeader()` from credentials cached in `shared_preferences`.

---

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** `provider`
- **Networking:** `http` (REST/JSON, Basic Auth)
- **Local Storage:** `shared_preferences`
- **Backend:** REST API on Google Cloud Run
- **Web Hosting:** Firebase Hosting
- **Notable packages:** `google_fonts`, `table_calendar`, `flutter_rating_bar`, `file_picker`, `permission_handler`, `flutter_svg`, `photo_view`, `pull_to_refresh`, `skeletonizer`, `flutter_spinkit`
