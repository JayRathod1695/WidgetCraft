import Foundation

public final class WeatherService: Sendable {
    public static let shared = WeatherService()
    
    private init() {}
    
    public func fetchLiveWeather(cityName: String = "Surat", latitude: Double = 21.1981, longitude: Double = 72.8298) async throws -> WeatherData {
        #if DEBUG
        print("[WeatherService][DEBUG] Fetching live weather for \(cityName) (\(latitude), \(longitude))")
        #endif
        
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,weather_code&hourly=temperature_2m,weather_code&forecast_days=1"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            #if DEBUG
            print("[WeatherService][ERROR] HTTP request failed with non-200 status")
            #endif
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let openMeteoResponse = try decoder.decode(OpenMeteoResponse.self, from: data)
        
        // Parse current
        let currentTemp = Int(round(openMeteoResponse.current.temperature_2m))
        let condition = parseCondition(code: openMeteoResponse.current.weather_code)
        
        // Calculate high & low from hourly
        let allTemps = openMeteoResponse.hourly.temperature_2m
        let highTemp = Int(round(allTemps.max() ?? Double(currentTemp)))
        let lowTemp = Int(round(allTemps.min() ?? Double(currentTemp)))
        
        // Build 5 upcoming hours
        let currentHourIndex = Calendar.current.component(.hour, from: Date())
        var forecastItems: [HourlyForecast] = []
        
        for i in 0..<5 {
            let targetIndex = (currentHourIndex + i) % openMeteoResponse.hourly.time.count
            let temp = Int(round(openMeteoResponse.hourly.temperature_2m[targetIndex]))
            let hourCode = openMeteoResponse.hourly.weather_code[targetIndex]
            let hourCondition = parseCondition(code: hourCode)
            
            let hourNum = (currentHourIndex + i) % 24
            let period = hourNum >= 12 ? "PM" : "AM"
            let displayHour = hourNum % 12 == 0 ? 12 : hourNum % 12
            let timeString = i == 0 ? "Now" : "\(displayHour) \(period)"
            
            forecastItems.append(
                HourlyForecast(timeString: timeString, temperature: temp, condition: hourCondition)
            )
        }
        
        #if DEBUG
        print("[WeatherService][DEBUG] Live weather fetched successfully: \(currentTemp)°C, \(condition.rawValue)")
        #endif
        
        return WeatherData(
            cityName: cityName,
            currentTemperature: currentTemp,
            highTemperature: highTemp,
            lowTemperature: lowTemp,
            condition: condition,
            hourlyForecast: forecastItems,
            lastUpdated: Date()
        )
    }
    
    private func parseCondition(code: Int) -> WeatherCondition {
        switch code {
        case 0:
            return .sunny
        case 1, 2:
            return .partlyCloudy
        case 3:
            return .cloudy
        case 45, 48:
            return .cloudy
        case 51...67, 80...82:
            return .rainy
        case 71...77, 85, 86:
            return .snowy
        case 95...99:
            return .stormy
        default:
            return .partlyCloudy
        }
    }
}

// MARK: - Open-Meteo Decodable DTO
private struct OpenMeteoResponse: Codable {
    struct Current: Codable {
        let temperature_2m: Double
        let weather_code: Int
    }
    struct Hourly: Codable {
        let time: [String]
        let temperature_2m: [Double]
        let weather_code: [Int]
    }
    
    let current: Current
    let hourly: Hourly
}
