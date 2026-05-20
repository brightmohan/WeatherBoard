import Foundation

public struct WeatherReading: Sendable, Identifiable {
    public let id: UUID
    public let city: City
    public let temperatureCelsius: Double
    public let weatherCode: Int

    public init(city: City, temperatureCelsius: Double, weatherCode: Int) {
        self.id = UUID()
        self.city = city
        self.temperatureCelsius = temperatureCelsius
        self.weatherCode = weatherCode
    }

    public var temperatureDisplay: String {
        String(format: "%.1f°C", temperatureCelsius)
    }

    public var weatherDescription: String {
        switch weatherCode {
        case 0: return "Clear sky"
        case 1...3: return "Partly cloudy"
        case 45, 48: return "Foggy"
        case 51...67: return "Drizzle/Rain"
        case 71...77: return "Snow"
        case 80...82: return "Rain showers"
        case 95: return "Thunderstorm"
        default: return "Unknown"
        }
    }
}
