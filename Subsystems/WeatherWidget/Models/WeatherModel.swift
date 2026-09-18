import Foundation

// MARK: - Weather Condition
public enum WeatherCondition: String, Codable {
    case sunny = "Sunny"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case stormy = "Stormy"
    case snowy = "Snowy"
    case windy = "Windy"
    
    public var sfSymbolName: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .stormy: return "cloud.bolt.rain.fill"
        case .snowy: return "snowflake"
        case .windy: return "wind"
        }
    }
}

// MARK: - Hourly Forecast Item
public struct HourlyForecast: Identifiable, Codable {
    public let id: UUID
    public let timeString: String
    public let temperature: Int
    public let condition: WeatherCondition
    
    public init(id: UUID = UUID(), timeString: String, temperature: Int, condition: WeatherCondition) {
        self.id = id
        self.timeString = timeString
        self.temperature = temperature
        self.condition = condition
    }
}

// MARK: - Weather Snapshot Model
public struct WeatherData: Codable {
    public let cityName: String
    public let currentTemperature: Int
    public let highTemperature: Int
    public let lowTemperature: Int
    public let condition: WeatherCondition
    public let hourlyForecast: [HourlyForecast]
    public let lastUpdated: Date
    
    public init(
        cityName: String,
        currentTemperature: Int,
        highTemperature: Int,
        lowTemperature: Int,
        condition: WeatherCondition,
        hourlyForecast: [HourlyForecast],
        lastUpdated: Date = Date()
    ) {
        self.cityName = cityName
        self.currentTemperature = currentTemperature
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.condition = condition
        self.hourlyForecast = hourlyForecast
        self.lastUpdated = lastUpdated
    }
    
    public static var previewData: WeatherData {
        WeatherData(
            cityName: "San Francisco",
            currentTemperature: 72,
            highTemperature: 74,
            lowTemperature: 58,
            condition: .partlyCloudy,
            hourlyForecast: [
                HourlyForecast(timeString: "11 AM", temperature: 72, condition: .partlyCloudy),
                HourlyForecast(timeString: "12 PM", temperature: 72, condition: .sunny),
                HourlyForecast(timeString: "1 PM", temperature: 72, condition: .sunny),
                HourlyForecast(timeString: "2 PM", temperature: 72, condition: .sunny),
                HourlyForecast(timeString: "3 PM", temperature: 72, condition: .sunny)
            ]
        )
    }
}
