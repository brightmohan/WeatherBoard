
import Foundation
import WeatherCore

public actor WeatherService{
    
    private var cache: [String: WeatherReading] = [:]
    
    public func fetchWeather(for city: City) async throws -> WeatherReading {
            if let cached = cache[city.name] {
                return cached
            }
    
            let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(city.latitude)&longitude=\(city.longitude)&current=temperature_2m,weather_code")!
    
            let (data, _) = try await URLSession.shared.data(from: url) //Suspends the thread here as the network request happens.
            let response = try JSONDecoder().decode(OpenMeteoResponse.self, from: data) //Once the response arrives, resumes right here.
    
            let reading = WeatherReading(
                city: city,
                temperatureCelsius: response.current.temperature2m,
                weatherCode: response.current.weatherCode
            )
    
            cache[city.name] = reading
            return reading
        }
}

// MARK: - API Response Shape
private struct OpenMeteoResponse: Decodable {
    let current: Current

    struct Current: Decodable {
        let temperature2m: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case weatherCode = "weather_code"
        }
    }
}

