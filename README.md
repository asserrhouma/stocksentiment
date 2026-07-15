# 📈 StockSentiment - Real-time Market Sentiment Analysis

**Analyse de l'humeur des marchés en temps réel par le scan de titres financiers (NLP/Sentiment Analysis)**

A Flutter cross-platform application that analyzes financial headlines using NLP and sentiment analysis to provide real-time market sentiment insights.

---

## 📋 Project Overview

StockSentiment is a financial sentiment analysis application that:
- Scans financial news headlines in real-time
- Applies NLP (Natural Language Processing) and sentiment analysis algorithms
- Classifies news as **Positive 📈 (Bullish)**, **Negative 📉 (Bearish)**, or **Neutral ➡️**
- Provides sentiment scores to help investors understand market mood
- Displays articles with sentiment indicators and filters
- Supports multi-platform deployment (iOS, Android, Windows, Web, Linux, macOS)

---

## ✅ Completed Features

### 1. **Project Setup & Architecture**
- ✅ Flutter project initialized with cross-platform support (iOS, Android, Windows, Web, Linux, macOS)
- ✅ State management setup with **Flutter Riverpod** (modern state management pattern)
- ✅ Material Design 3 theme implementation
- ✅ Dark-themed UI with custom color scheme (Primary: `#1E3A5F`, Accent: Amber)

### 2. **Authentication System** (`features/auth/login_screen.dart`)
- ✅ Login/Register UI with form validation
- ✅ Email and password fields with proper validation
- ✅ Password visibility toggle
- ✅ Full Name field for registration
- ✅ Loading states during authentication
- ✅ SnackBar notifications for user feedback
- ✅ Form state management with `GlobalKey<FormState>`
- ✅ Navigation between Login and Register modes
- ✅ Test credentials: `test@test.com` / `123456`
- **Status**: Mock authentication (real backend integration planned for next phase)

### 3. **Home Screen** (`features/home/home_screen.dart`)
- ✅ Displays list of financial articles with sentiment analysis
- ✅ Real-time sentiment filtering (All, Positive, Negative, Neutral)
- ✅ Dynamic filtering logic based on sentiment category
- ✅ Bottom navigation with multiple tabs (Home, Dashboard, Favorites)
- ✅ Proper app state management
- ✅ Mock data with 4 sample articles for testing
- **Status**: Using static/mock data (API integration in progress)

### 4. **Data Models** (`lib/models/article.dart`)
- ✅ `Article` class with complete structure:
  - Article metadata (id, title, description, URL, image, source, publication date)
  - Sentiment fields (`sentiment`: positive/negative/neutral, `sentimentScore`: -1.0 to 1.0)
  - Factory method `fromMap()` for JSON deserialization
  - `toMap()` method for data persistence
- ✅ Proper handling of missing images with fallback icons

### 5. **UI Components** (`lib/widgets/article_card.dart`)
- ✅ **ArticleCard Widget**: Reusable card component displaying articles
  - Article image with error handling
  - Dynamic sentiment badge (color & icon based on sentiment)
  - Sentiment labels with emojis (📈 Bullish, 📉 Bearish, ➡️ Neutral)
  - Favorite action button
  - Source and publication date display
- ✅ Sentiment-based color coding (Green = Positive, Red = Negative, Orange = Neutral)
- ✅ Sentiment icons (Trending Up, Down, Flat)

### 6. **Dependencies & Libraries**
- ✅ **flutter_riverpod** (^3.3.1) - State management
- ✅ **dio** (^5.9.2) - HTTP client for API calls
- ✅ **hive** (^2.2.3) - Local database
- ✅ **hive_flutter** (^1.1.0) - Hive integration
- ✅ **fl_chart** (^1.2.0) - Charts and graphs
- ✅ **shared_preferences** (^2.5.5) - Key-value storage
- ✅ **flutter_lints** (^6.0.0) - Code quality

---

## 🔄 In-Progress / Partially Implemented

### 1. **Sentiment Provider** (`lib/providers/sentiment_provider.dart`)
- ⏳ State: File exists but empty
- 📝 Purpose: Should manage sentiment analysis business logic with Riverpod
- 📋 Planned: Integrate NLP API for real sentiment analysis

### 2. **Dashboard Screen** (`features/dashboard/dashboard_screen.dart`)
- ⏳ State: File exists but empty
- 📝 Purpose: Display analytics, charts, and sentiment trends
- 📋 Planned: Use `fl_chart` for visualizations

### 3. **Favorites Screen** (`features/favorites/favorites_screen.dart`)
- ⏳ State: File exists but empty
- 📝 Purpose: Manage user's saved favorite articles
- 📋 Planned: Use Hive for local persistence

### 4. **Navigation System**
- ⏳ Basic routing implemented (Login → Home)
- 📋 Planned: Complete bottom navigation bar integration for Dashboard & Favorites

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point, MaterialApp config
├── core/
│   └── constants.dart                 # Global constants
├── features/
│   ├── auth/
│   │   └── login_screen.dart         # ✅ Login/Register UI (completed)
│   ├── home/
│   │   └── home_screen.dart          # ✅ Article list display (completed)
│   ├── dashboard/
│   │   └── dashboard_screen.dart     # ⏳ Analytics (empty)
│   └── favorites/
│       └── favorites_screen.dart     # ⏳ Saved articles (empty)
├── models/
│   └── article.dart                   # ✅ Article data model (completed)
├── providers/
│   └── sentiment_provider.dart        # ⏳ State management (empty)
└── widgets/
    └── article_card.dart              # ✅ Reusable article card (completed)
```

---

## 🛠️ Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Framework** | Flutter | Latest |
| **Language** | Dart | ^3.11.0 |
| **State Management** | Riverpod | ^3.3.1 |
| **HTTP Client** | Dio | ^5.9.2 |
| **Database** | Hive | ^2.2.3 |
| **Charts** | FL Chart | ^1.2.0 |
| **UI Design** | Material Design 3 | Built-in |
| **Platforms** | iOS, Android, Windows, Web, Linux, macOS | Supported |

---

## 🎨 Design System

- **Primary Color**: `#1E3A5F` (Dark Navy Blue)
- **Accent Color**: Amber (Gold)
- **Background**: `#F5F7FA` (Light Gray)
- **Theme**: Material Design 3 with custom seeding
- **Font**: System default (Roboto)
- **Language**: Bilingual (French/English comments in code)

---

## 🚀 Getting Started

### Prerequisites
```bash
Flutter SDK: Latest stable version
Dart SDK: ^3.11.0
IDE: Android Studio, IntelliJ, VS Code
```

### Installation & Setup
```bash
# 1. Navigate to project directory
cd stock_sentiment

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run          # Desktop (Windows)
flutter run -d ios   # iOS device
flutter run -d android  # Android device
flutter run -d chrome   # Web browser
```

### Test Credentials
```
Email: test@test.com
Password: 123456
```

---

## 📝 Current State Summary

| Area | Status | Notes |
|------|--------|-------|
| **UI/UX** | 80% Complete | Core screens done, need Dashboard & Favorites |
| **Authentication** | 100% Complete | Mock auth working, ready for backend |
| **Article Display** | 70% Complete | Static data works, needs real API integration |
| **Sentiment Analysis** | 10% Complete | Model defined, NLP integration pending |
| **Data Persistence** | 0% Complete | Dependencies added, implementation pending |
| **Charts/Analytics** | 0% Complete | Library included, Dashboard pending |

---

## 📋 Next Steps / TODO

### Phase 1: Backend Integration
- [ ] Connect to financial news API (NewsAPI, Alpha Vantage, etc.)
- [ ] Implement real API calls with `dio` package
- [ ] Setup error handling and retry logic
- [ ] Add loading states and caching

### Phase 2: Sentiment Analysis Engine
- [ ] Integrate NLP library or API (HuggingFace, TextRazor, etc.)
- [ ] Implement sentiment scoring algorithm
- [ ] Store sentiment analysis results
- [ ] Add confidence/reliability scores

### Phase 3: Features Implementation
- [ ] **Favorites Screen**: Implement Hive persistence
- [ ] **Dashboard Screen**: Add sentiment trend charts with `fl_chart`
- [ ] **Search/Filter**: Add advanced filtering options
- [ ] **Article Details**: Create detailed article view

### Phase 4: User Features
- [ ] User authentication (Backend integration)
- [ ] Portfolio tracking
- [ ] Push notifications for sentiment changes
- [ ] User preferences/settings

### Phase 5: Polish & Deployment
- [ ] Unit testing
- [ ] UI/UX refinements
- [ ] Performance optimization
- [ ] Release to app stores

---

## 📞 Contact & Notes

- **Project Language**: Primarily French (UI text & comments)
- **Code Style**: Follows Flutter best practices
- **Version**: 1.0.0+1
- **Status**: Early development phase

---

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Dart Language Guide](https://dart.dev)
- [Material Design 3](https://m3.material.io/)

---

**Last Updated**: May 2026 | **Development Phase**: 2/5 ⏳
