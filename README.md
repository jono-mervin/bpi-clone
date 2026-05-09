<div align="center">

# 🏦 BPI Bank of the Philippine Islands
### Mobile Banking Simulation App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![PHP](https://img.shields.io/badge/Core_PHP-8.x-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://php.net)
[![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

> A feature-rich **mobile banking simulation** built with Flutter, designed to demonstrate enterprise-level fintech architecture, secure authentication workflows, and realistic banking experiences — using dummy data and mock transactions.

**⚠️ Disclaimer: This is a simulation application for academic/demonstration purposes only. No real money movement occurs. Not affiliated with any licensed financial institution.**

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Getting Started](#-getting-started)
- [API Documentation](#-api-documentation)
- [Security Implementation](#-security-implementation)
- [Dummy Data](#-dummy-data)
- [Development Roadmap](#-development-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**BPI Bank of the Philippine Islands** is a capstone/thesis-grade mobile banking simulation that replicates the look, feel, and workflow of a real digital banking app. Built using **Flutter** for the frontend and a **Core PHP REST API** with **MySQL** for the backend, the app demonstrates:

- Secure authentication flows with JWT and biometrics
- Real-time simulated fund transfers
- QR code payment simulation
- Financial analytics with interactive charts
- AI-powered spending insights

This project follows **Clean Architecture** principles and is structured to reflect enterprise-level fintech development practices.

---

## ✨ Features

### 🔐 Authentication Module
| Feature | Status |
|---|---|
| User Registration | ✅ |
| Login with JWT | ✅ |
| Forgot Password | ✅ |
| OTP Verification (Simulated) | ✅ |
| Biometric Login (Fingerprint / Face ID) | ✅ |
| Session Expiry & Auto-Logout | ✅ |

### 🏠 Dashboard Module
- Personalized user greeting with account summary
- Animated balance card (current & savings)
- Recent transaction feed
- Spending overview chart
- Quick action shortcuts (Send, Receive, Pay, Scan)

### 💳 Wallet Module
- Simulated balance management (add / deduct funds)
- Peer-to-peer wallet transfers
- Full transaction history with filters
- Balance hidden/show toggle

### 💸 Transaction Module
- Send money to registered users
- Receive money simulation
- Simulated interbank transfers
- Scheduled / recurring transfers
- Downloadable transaction receipt (PDF)
- Real-time transaction status updates

### 📷 QR Payment Module
- Generate personal QR code
- Scan QR code to pay
- Simulated merchant payments
- QR-based receive flow

### 🔔 Notification Module
- In-app transfer alerts
- Payment confirmation notifications
- Simulated OTP push notifications
- Suspicious activity alerts

### 📊 Financial Analytics Module
- Monthly income vs. expense breakdown
- Spending by category (Food, Transport, Bills, etc.)
- Interactive bar & line charts
- Exportable reports

### 🤖 AI-Powered Insights *(Simulated)*
- Smart spending insights ("You spent 35% more on food this month.")
- Fraud detection alerts ("Suspicious login detected from another device.")
- Financial health score
- AI chatbot financial assistant

---

## 📱 Screenshots

> *(Add screenshots here once UI is finalized)*

| Splash | Login | Dashboard |
|--------|-------|-----------|
| ![splash](docs/screenshots/splash.png) | ![login](docs/screenshots/login.png) | ![dashboard](docs/screenshots/dashboard.png) |

| Wallet | Transfer | Analytics |
|--------|----------|-----------|
| ![wallet](docs/screenshots/wallet.png) | ![transfer](docs/screenshots/transfer.png) | ![analytics](docs/screenshots/analytics.png) |

---

## 🛠 Tech Stack

### Frontend
| Technology | Purpose |
|---|---|
| [Flutter 3.x](https://flutter.dev) | Cross-platform mobile UI framework |
| [Dart 3.x](https://dart.dev) | Programming language |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | State management |
| [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) | Encrypted local storage |
| [local_auth](https://pub.dev/packages/local_auth) | Biometric authentication |
| [dio](https://pub.dev/packages/dio) | HTTP networking client |
| [fl_chart](https://pub.dev/packages/fl_chart) | Financial charts & graphs |
| [qr_flutter](https://pub.dev/packages/qr_flutter) | QR code generation |
| [mobile_scanner](https://pub.dev/packages/mobile_scanner) | QR code scanning |
| [lottie](https://pub.dev/packages/lottie) | Success/loading animations |
| [shimmer](https://pub.dev/packages/shimmer) | Loading skeleton UI |

### Backend
| Technology | Purpose |
|---|---|
| Core PHP 8.x | REST API server |
| MySQL 8.x | Relational database |
| JWT (Firebase JWT) | Token-based authentication |
| Apache / Nginx | Web server |

---

## 🏛 Architecture

This project implements **Clean Architecture** with a **Repository Pattern** and **Service Layer**, keeping business logic separate from UI and data sources.

```
Presentation Layer  →  Use Case / Application Layer  →  Domain Layer  →  Data Layer
   (Flutter UI)           (Riverpod Providers)          (Entities)     (Repositories + API)
```

### State Management
[Riverpod](https://riverpod.dev) is used for reactive state management across all modules, providing:
- Dependency injection
- Asynchronous state handling
- Testable and modular providers

### Transaction Workflow
```
1. User inputs amount & recipient
        ↓
2. Validate input & check balance
        ↓
3. Call Transfer API (POST /transactions/transfer)
        ↓
4. Deduct sender balance  →  Credit receiver balance
        ↓
5. Log transaction to DB
        ↓
6. Generate transaction receipt
        ↓
7. Trigger push notification
        ↓
8. Display success animation
```

---

## 📁 Project Structure

```
neobank_ph/
├── lib/
│   ├── core/
│   │   ├── constants/          # App-wide constants (colors, strings, endpoints)
│   │   ├── errors/             # Failure and exception classes
│   │   ├── network/            # Dio client, interceptors
│   │   ├── security/           # JWT handler, biometric service
│   │   └── utils/              # Formatters, validators, helpers
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── account_model.dart
│   │   ├── transaction_model.dart
│   │   └── notification_model.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── wallet_service.dart
│   │   ├── transaction_service.dart
│   │   └── notification_service.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── wallet_repository.dart
│   │   └── transaction_repository.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── providers/
│   │   │   ├── screens/        # login, register, otp, biometric
│   │   │   └── widgets/
│   │   ├── dashboard/
│   │   │   ├── providers/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── wallet/
│   │   ├── transfers/
│   │   ├── qr/
│   │   ├── analytics/
│   │   ├── notifications/
│   │   └── settings/
│   ├── widgets/                # Shared/reusable widgets
│   └── main.dart
│
├── backend/
│   ├── api/
│   │   ├── auth/               # login.php, register.php, otp.php
│   │   ├── transactions/       # transfer.php, history.php
│   │   ├── wallet/             # balance.php, topup.php
│   │   └── notifications/
│   ├── config/
│   │   ├── database.php
│   │   └── jwt_config.php
│   ├── middleware/
│   │   └── auth_middleware.php
│   └── models/
│
├── database/
│   ├── schema.sql              # Full database schema
│   └── seeders/                # Dummy data seeders
│
├── docs/
│   ├── screenshots/
│   └── api_docs.md
│
├── pubspec.yaml
└── README.md
```

---

## 🗄 Database Schema

```sql
-- Core Tables
users               -- Account holders
accounts            -- Bank accounts per user
wallets             -- Digital wallet balances
transactions        -- All transaction records
transaction_types   -- (transfer, payment, topup, etc.)
beneficiaries       -- Saved recipients
notifications       -- In-app notification log
devices             -- Registered devices (for biometrics)
otp_codes           -- OTP generation & expiry tracking
sessions            -- Active JWT sessions
audit_logs          -- Security & activity audit trail
```

See [`database/schema.sql`](database/schema.sql) for the full normalized schema.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- PHP `>=8.0` with PDO extension
- MySQL `>=8.0`
- Composer (for PHP dependencies)
- Android Studio / Xcode (for device emulation)

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/neobank_ph.git
cd neobank_ph
```

### 2. Set Up the Backend

```bash
cd backend

# Copy and configure environment
cp config/env.example.php config/env.php

# Edit database credentials
nano config/env.php
```

```php
// config/env.php
define('DB_HOST', 'localhost');
define('DB_NAME', 'neobank_db');
define('DB_USER', 'root');
define('DB_PASS', 'your_password');
define('JWT_SECRET', 'your_jwt_secret_key');
```

```bash
# Import the database schema
mysql -u root -p < ../database/schema.sql

# Seed dummy data
mysql -u root -p neobank_db < ../database/seeders/seed_users.sql
```

### 3. Set Up the Flutter App

```bash
cd ..  # back to project root

# Install Flutter dependencies
flutter pub get

# Configure API base URL
# Edit lib/core/constants/api_constants.dart
```

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2/neobank_ph/backend/api'; // Android emulator
  // static const String baseUrl = 'http://localhost/neobank_ph/backend/api'; // iOS simulator
}
```

### 4. Run the App

```bash
# Check connected devices
flutter devices

# Run on emulator or device
flutter run

# Run in release mode
flutter run --release
```

---

## 📡 API Documentation

### Base URL
```
http://your-server/api/v1
```

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/register` | Register a new user |
| `POST` | `/auth/login` | Login and receive JWT |
| `POST` | `/auth/otp/verify` | Verify OTP code |
| `POST` | `/auth/logout` | Invalidate session |
| `GET`  | `/auth/me` | Get authenticated user |

### Wallet Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET`  | `/wallet/balance` | Get wallet balance |
| `POST` | `/wallet/topup` | Simulate adding funds |

### Transaction Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/transactions/transfer` | Execute a transfer |
| `GET`  | `/transactions/history` | Get transaction history |
| `GET`  | `/transactions/{id}` | Get transaction details |
| `GET`  | `/transactions/{id}/receipt` | Download receipt |

All protected endpoints require the `Authorization: Bearer <token>` header.

Full API docs: [`docs/api_docs.md`](docs/api_docs.md)

---

## 🔒 Security Implementation

| Feature | Implementation |
|---|---|
| **Authentication** | JWT with expiry + refresh token rotation |
| **Local Storage** | `flutter_secure_storage` (AES-256 encrypted) |
| **Biometrics** | `local_auth` — Fingerprint & Face ID |
| **OTP** | Time-based 6-digit code with 5-minute expiry |
| **Session Management** | Auto-logout on inactivity timeout |
| **Password Hashing** | PHP `password_hash()` with `PASSWORD_BCRYPT` |
| **HTTPS** | All API calls over HTTPS (enforce in production) |
| **Input Validation** | Client-side + server-side validation |

> These security features are implemented following real-world fintech patterns to demonstrate enterprise-level practices, even within a simulation environment.

---

## 🧪 Dummy Data

Pre-seeded accounts for testing:

| Name | Account No. | Balance | PIN |
|------|------------|---------|-----|
| Juan dela Cruz | 0001-2345-6789 | ₱25,000.00 | 1234 |
| Maria Santos | 0002-3456-7890 | ₱18,500.00 | 1234 |
| Pedro Reyes | 0003-4567-8901 | ₱9,750.00 | 1234 |

**OTP for all test accounts:** `123456`

**Simulated Transaction Sample:**
```
Transfer to Maria Santos
Amount:   ₱1,500.00
Status:   ✅ Completed
Date:     May 7, 2026
Ref No.:  TXN-20260507-00142
```

---

## 🗺 Development Roadmap

| Phase | Description | Status |
|-------|-------------|--------|
| **Phase 1** | Planning, wireframing & UI design (Figma) | ✅ Done |
| **Phase 2** | Flutter project setup & architecture | ✅ Done |
| **Phase 3** | Authentication module (Login, Register, OTP, Biometrics) | 🔄 In Progress |
| **Phase 4** | Wallet & Transaction module | ⏳ Pending |
| **Phase 5** | Analytics & Charts (fl_chart) | ⏳ Pending |
| **Phase 6** | QR Payment module | ⏳ Pending |
| **Phase 7** | AI Insights & Chatbot simulation | ⏳ Pending |
| **Phase 8** | UI polish, animations & dark mode | ⏳ Pending |
| **Phase 9** | Testing, documentation & final presentation | ⏳ Pending |

---

## 🤝 Contributing

This project is primarily for academic purposes. If you'd like to suggest improvements:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add: your feature description'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

---

## 👨‍💻 Authors

| Name | Role |
|------|------|
| [Your Name](https://github.com/yourusername) | Lead Developer / Designer |

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

<div align="center">

Made with ❤️ for academic purposes · Built with Flutter

**BPI Bank of the Philippine Islands** — *Banking, Simulated.*

</div>
