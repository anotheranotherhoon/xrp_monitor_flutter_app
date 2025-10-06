# flutter_default_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



```mermaid
flowchart TD
    Start([App Start]) --> Init[Initialize App]
    Init --> Version{Version Check}
    Version -->|Invalid Version| VersionError[Version Error Screen]
    Version -->|Valid Version| Auth{Authentication}

    Auth -->|Not Authenticated| Login[Login Screen]
    Auth -->|Authenticated| TabsRoot[Tabs Root Screen]

    Login --> LoginForm{Login Form}
    LoginForm -->|Success| TabsRoot
    LoginForm -->|Need Account| Signup[Signup Screen]
    LoginForm -->|Failed| Login

    Signup --> SignupForm{Signup Form}
    SignupForm -->|Success| TabsRoot
    SignupForm -->|Back to Login| Login
    SignupForm -->|Failed| Signup

    TabsRoot --> Monitor[Monitor Tab<br/>XRP Price Chart]
    TabsRoot --> Twitter[Twitter Tab<br/>XRP Twitters]
    TabsRoot --> YouTube[YouTube Tab<br/>XRP Videos]
    TabsRoot --> News[News Tab<br/>XRP News]
    TabsRoot --> Settings[Settings Tab<br/>Portfolio & Profile]

    Monitor --> ChartData[Real-time Chart Data]
    Monitor --> PriceCard[Current Price Display]

    Twitter --> TwitterAPI[Twitter Service]
    TwitterAPI --> TwitterCards[Twitter Cards Display]
    TwitterCards --> LazyLoad[Lazy Loading]

    YouTube --> YouTubeAPI[YouTube Service]
    YouTubeAPI --> VideoCards[Video Cards Display]
    VideoCards --> VideoPlayer[Video Player Modal]

    News --> NewsAPI[News Service]
    NewsAPI --> NewsCards[News Cards Display]

    Settings --> Portfolio[Portfolio Management]
    Settings --> Profile[Profile Settings]
    Portfolio --> PortfolioService[Portfolio Service]

    %% Data Flow
    ChartData --> CandleService[Chart Service]
    TwitterAPI --> TwitterService[Twitter Service]
    YouTubeAPI --> YouTubeService[YouTube Service]
    NewsAPI --> NewsService[News Service]

    %% State Management
    CandleService -.-> Riverpod[Riverpod State Management]
    TwitterService -.-> Riverpod
    YouTubeService -.-> Riverpod
    NewsService -.-> Riverpod
    PortfolioService -.-> Riverpod

    %% Storage
    Riverpod -.-> LocalStorage[Local Storage Service]

    classDef screen fill:#e1f5fe
    classDef service fill:#f3e5f5
    classDef state fill:#e8f5e8
    classDef api fill:#fff3e0

    class Login,Signup,TabsRoot,Monitor,Twitter,YouTube,News,Settings screen
    class TwitterAPI,YouTubeAPI,NewsAPI,CandleService,TwitterService,YouTubeService,NewsService,PortfolioService service
    class Riverpod,LocalStorage state
    class ChartData,TwitterCards,VideoCards,NewsCards api
```