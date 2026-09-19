import Foundation

// MARK: - Weather Condition
public enum WeatherCondition: String, Codable, Sendable {
    case sunny = "Sunny"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case stormy = "Stormy"
    case snowy = "Snowy"
    case windy = "Windy"
    case foggy = "Foggy"
    case clearNight = "Clear"
    
    public var sfSymbolName: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .stormy: return "cloud.bolt.rain.fill"
        case .snowy: return "snowflake"
        case .windy: return "wind"
        case .foggy: return "cloud.fog.fill"
        case .clearNight: return "moon.stars.fill"
        }
    }
}

// MARK: - Hourly Forecast Item
public struct HourlyForecast: Identifiable, Codable, Sendable {
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

// MARK: - Wind Data Model
public struct WindData: Codable, Sendable {
    public let speedKmh: Int
    public let gustKmh: Int
    public let directionDegrees: Double
    public let cardinalDirection: String
    
    public init(speedKmh: Int, gustKmh: Int, directionDegrees: Double, cardinalDirection: String) {
        self.speedKmh = speedKmh
        self.gustKmh = gustKmh
        self.directionDegrees = directionDegrees
        self.cardinalDirection = cardinalDirection
    }
    
    public static var preview: WindData {
        WindData(speedKmh: 14, gustKmh: 22, directionDegrees: 45, cardinalDirection: "NE")
    }
}

// MARK: - Solar / Lunar Events Model
public struct SolarEvents: Codable, Sendable {
    public let sunrise: Date
    public let sunset: Date
    public let isDaylight: Bool
    
    public init(sunrise: Date, sunset: Date, isDaylight: Bool) {
        self.sunrise = sunrise
        self.sunset = sunset
        self.isDaylight = isDaylight
    }
    
    public var daylightProgress: Double {
        let now = Date()
        guard isDaylight else { return 0.5 }
        let total = sunset.timeIntervalSince(sunrise)
        guard total > 0 else { return 0.5 }
        let elapsed = now.timeIntervalSince(sunrise)
        return max(0, min(1, elapsed / total))
    }
    
    public static var preview: SolarEvents {
        let calendar = Calendar.current
        let now = Date()
        let sunrise = calendar.date(bySettingHour: 6, minute: 12, second: 0, of: now) ?? now
        let sunset = calendar.date(bySettingHour: 19, minute: 2, second: 0, of: now) ?? now
        return SolarEvents(sunrise: sunrise, sunset: sunset, isDaylight: true)
    }
}

// MARK: - Master Weather Snapshot Model
public struct WeatherData: Codable, Sendable {
    public let cityName: String
    public let currentTemperature: Int
    public let highTemperature: Int
    public let lowTemperature: Int
    public let condition: WeatherCondition
    public let hourlyForecast: [HourlyForecast]
    public let uvIndex: Double
    public let wind: WindData
    public let solar: SolarEvents
    public let pressureHpa: Int
    public let lastUpdated: Date
    
    public init(
        cityName: String,
        currentTemperature: Int,
        highTemperature: Int,
        lowTemperature: Int,
        condition: WeatherCondition,
        hourlyForecast: [HourlyForecast],
        uvIndex: Double = 5.4,
        wind: WindData = .preview,
        solar: SolarEvents = .preview,
        pressureHpa: Int = 1016,
        lastUpdated: Date = Date()
    ) {
        self.cityName = cityName
        self.currentTemperature = currentTemperature
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.condition = condition
        self.hourlyForecast = hourlyForecast
        self.uvIndex = uvIndex
        self.wind = wind
        self.solar = solar
        self.pressureHpa = pressureHpa
        self.lastUpdated = lastUpdated
    }
    
    public static var previewData: WeatherData {
        WeatherData(
            cityName: "SURAT, GUJARAT",
            currentTemperature: 31,
            highTemperature: 34,
            lowTemperature: 24,
            condition: .partlyCloudy,
            hourlyForecast: [
                HourlyForecast(timeString: "Now", temperature: 31, condition: .partlyCloudy),
                HourlyForecast(timeString: "1 PM", temperature: 33, condition: .sunny),
                HourlyForecast(timeString: "2 PM", temperature: 34, condition: .sunny),
                HourlyForecast(timeString: "3 PM", temperature: 32, condition: .partlyCloudy),
                HourlyForecast(timeString: "4 PM", temperature: 30, condition: .cloudy),
                HourlyForecast(timeString: "5 PM", temperature: 29, condition: .cloudy)
            ],
            uvIndex: 5.4,
            wind: WindData(speedKmh: 14, gustKmh: 22, directionDegrees: 45, cardinalDirection: "NE"),
            solar: .preview,
            pressureHpa: 1016,
            lastUpdated: Date()
        )
    }
}
