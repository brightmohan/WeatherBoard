import Foundation
import Observation
import WeatherCore

@MainActor
@Observable
public final class WeatherViewModel {
    
    public private(set) var readings: [WeatherReading]=[]
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?
    
    private let service = WeatherService()
    
    public static let australianCities: [City] = [
        City(name: "Sydney",    latitude: -33.8688, longitude: 151.2093),
        City(name: "Melbourne", latitude: -37.8136, longitude: 144.9631),
        City(name: "Brisbane",  latitude: -27.4698, longitude: 153.0251),
        City(name: "Perth",     latitude: -31.9505, longitude: 115.8605),
        City(name: "Adelaide",  latitude: -34.9285, longitude: 138.6007),
        City(name: "Hobart",    latitude: -42.8821, longitude: 147.3272),
        City(name: "Darwin",    latitude: -12.4634, longitude: 130.8456),
        City(name: "Canberra",  latitude: -35.2809, longitude: 149.1300),
    ]
    
    public init() {}
    
    public func fetchAll() async {
        isLoading = true
        errorMessage = nil
        readings = []

        do {
            readings = try await withThrowingTaskGroup(of: WeatherReading.self) { group in
                for city in Self.australianCities {
                    group.addTask {
                        try await self.service.fetchWeather(for: city)
                    }
                }
                var results: [WeatherReading] = []
                for try await reading in group {
                    results.append(reading)
                }
                return results
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        
    }
    
}
