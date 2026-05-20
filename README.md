# WeatherBoard 🇦🇺

A real-data iOS app fetching live weather for 8 Australian cities — built to learn **Swift 6 concurrency** hands-on. Every concurrency concept is used naturally, not as a toy example.

## What it does

Fetches current temperature and weather conditions for Sydney, Melbourne, Brisbane, Perth, Adelaide, Hobart, Darwin, and Canberra — **all simultaneously** — from the free [Open-Meteo API](https://open-meteo.com) (no API key required).

## Swift 6 concurrency concepts demonstrated

| Concept | Where | What you learn |
|---------|-------|----------------|
| `Sendable` | `City`, `WeatherReading` in WeatherCore | Structs are safe to cross actor boundaries; compiler verifies the whole chain |
| `actor` | `WeatherService` in WeatherFeature | Mutable cache (`[String: WeatherReading]`) protected from data races; `await` required from outside |
| `@MainActor` | `WeatherViewModel` | All UI state updates guaranteed on the main thread; no `DispatchQueue.main.async` needed |
| `withThrowingTaskGroup` | `WeatherViewModel.fetchAll()` | All 8 cities fetched concurrently; results stream in as each finishes |
| `async/await` | `WeatherService.fetchWeather(for:)` | Suspends without blocking a thread; resumes on the next line when network responds |
| `.task { }` | `ContentView` | SwiftUI's async task launcher tied to view lifecycle |

## Architecture (layered modular SPM)

```
WeatherBoard/
├── Packages/
│   ├── WeatherCore/          # Domain models — no dependencies
│   │   ├── City.swift        # Sendable struct: name, lat, lon
│   │   └── WeatherReading.swift  # Sendable struct: city, temp, weatherCode
│   └── WeatherFeature/       # Business logic — depends on WeatherCore
│       ├── WeatherService.swift  # actor: fetches API, caches results
│       └── WeatherViewModel.swift # @MainActor @Observable: drives UI
└── WeatherBoard/
    └── ContentView.swift     # SwiftUI view — depends on WeatherFeature
```

Dependency direction: **UI → Feature → Core**. Core knows nothing about Feature or UI.

## Key insight: why `Sendable` matters

```swift
// City crosses from @MainActor → actor WeatherService → back to @MainActor
// Swift 6 checks: is City safe to hand between concurrency domains?
// Yes — it's a struct with only value-type properties. Compiler verifies this.
public struct City: Sendable, Identifiable { ... }
```

Without `Sendable`, Swift 6 strict concurrency mode refuses to compile. The compiler is catching potential data races at build time, not at runtime.

## Key insight: actor isolation

```swift
actor WeatherService {
    private var cache: [String: WeatherReading] = [:]  // protected state

    func fetchWeather(for city: City) async throws -> WeatherReading {
        cache[city.name] = reading  // ✅ fine — inside the actor
    }
}

// From outside:
let reading = await service.fetchWeather(for: city)  // await required
// service.cache["Sydney"]  // ❌ compiler error — can't touch actor state directly
```

## Key insight: TaskGroup vs sequential fetching

```swift
// ❌ Sequential — 8 network calls one after another (~8 seconds)
for city in cities {
    let reading = try await service.fetchWeather(for: city)
}

// ✅ TaskGroup — all 8 fire simultaneously (~1 second for the slowest)
try await withThrowingTaskGroup(of: WeatherReading.self) { group in
    for city in cities {
        group.addTask { try await self.service.fetchWeather(for: city) }
    }
    for try await reading in group { results.append(reading) }
}
```

## Requirements

- Xcode 16+
- iOS 17+
- Swift 6
- Internet connection (live API calls to open-meteo.com)

## Running

Open `WeatherBoard.xcodeproj`, select an iPhone simulator, press **⌘R**.

The loading spinner appears while all 8 cities fetch concurrently, then the list populates.
