//
//  WeatherBoardTests.swift
//  WeatherBoardTests
//

import XCTest
import WeatherCore
@testable import WeatherBoard

final class WeatherBoardTests: XCTestCase {

    func testCityHasCorrectName() {
        let city = City(name: "Sydney", latitude: -33.8688, longitude: 151.2093)
        XCTAssertEqual(city.name, "Sydney")
    }

    func testWeatherReadingTemperatureDisplay() {
        let city = City(name: "Melbourne", latitude: -37.8136, longitude: 144.9631)
        let reading = WeatherReading(city: city, temperatureCelsius: 22.5, weatherCode: 0)
        XCTAssertEqual(reading.temperatureDisplay, "22.5°C")
    }

    func testWeatherReadingDescription() {
        let city = City(name: "Brisbane", latitude: -27.4698, longitude: 153.0251)
        let reading = WeatherReading(city: city, temperatureCelsius: 28.0, weatherCode: 0)
        XCTAssertEqual(reading.weatherDescription, "Clear sky")
    }

}
