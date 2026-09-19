import Foundation
import CoreLocation
import WeatherKit

// MARK: - Apple WeatherKit Service
public final class WeatherService: Sendable {
    public static let shared = WeatherService()
    
    private init() {}
    
    /// Fetches live weather data using Apple's official WeatherKit framework.
    /// Falls back to a deterministic physical model if WeatherKit entitlement is not active.
    public func fetchLiveWeather(
        cityName: String = "SURAT, GUJARAT",
        latitude: Double = 21.1981,
        longitude: Double = 72.8298
    ) async -> WeatherData {
        #if DEBUG
        print("[WeatherService][DEBUG] Requesting Apple WeatherKit data for \(cityName) (\(latitude), \(longitude))")
        #endif
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        #if canImport(WeatherKit)
        do {
            let appleWeather = try await WeatherKit.WeatherService.shared.weather(for: location)
            return parseAppleWeather(appleWeather, cityName: cityName)
        } catch {
            #if DEBUG
            print("[WeatherService][WARNING] Apple WeatherKit call threw: \(error.localizedDescription). Falling back to synthetic physical model.")
            #endif
            return generatePhysicalFallbackWeather(cityName: cityName, latitude: latitude, longitude: longitude)
        }
        #else
        return generatePhysicalFallbackWeather(cityName: cityName, latitude: latitude, longitude: longitude)
        #endif
    }
    
    #if canImport(WeatherKit)
    private func parseAppleWeather(_ weather: WeatherKit.Weather, cityName: String) -> WeatherData {
        let current = weather.currentWeather
        let currentTemp = Int(round(current.temperature.converted(to: .celsius).value))
        let condition = mapAppleCondition(current.condition)
        
        // High and Low from today's daily forecast
        let today = weather.dailyForecast.first
        let highTemp = today.map { Int(round($0.highTemperature.converted(to: .celsius).value)) } ?? (currentTemp + 4)
        let lowTemp = today.map { Int(round($0.lowTemperature.converted(to: .celsius).value)) } ?? (currentTemp - 6)
        
        // Hourly forecast (next 6 hours)
        var hourlyItems: [HourlyForecast] = []
        let now = Date()
        let upcomingHours = weather.hourlyForecast.filter { $0.date >= now }.prefix(6)
        
        for (index, hourEntry) in upcomingHours.enumerated() {
            let temp = Int(round(hourEntry.temperature.converted(to: .celsius).value))
            let hourCond = mapAppleCondition(hourEntry.condition)
            
            let timeString: String
            if index == 0 {
                timeString = "Now"
            } else {
                let hourNum = Calendar.current.component(.hour, from: hourEntry.date)
                let ampm = hourNum >= 12 ? "PM" : "AM"
                let dispHour = hourNum % 12 == 0 ? 12 : hourNum % 12
                timeString = "\(dispHour) \(ampm)"
            }
            hourlyItems.append(HourlyForecast(timeString: timeString, temperature: temp, condition: hourCond))
        }
        
        // UV Index
        let uv = Double(current.uvIndex.value)
        
        // Wind
        let speedKmh = Int(round(current.wind.speed.converted(to: .kilometersPerHour).value))
        let gustKmh = current.wind.gust.map { Int(round($0.converted(to: .kilometersPerHour).value)) } ?? (speedKmh + 6)
        let directionDeg = current.wind.direction.converted(to: .degrees).value
        let cardinal = current.wind.compassDirection.abbreviation
        let wind = WindData(speedKmh: speedKmh, gustKmh: gustKmh, directionDegrees: directionDeg, cardinalDirection: cardinal)
        
        // Solar
        let sunrise = today?.sun.sunrise ?? Calendar.current.date(bySettingHour: 6, minute: 15, second: 0, of: now)!
        let sunset = today?.sun.sunset ?? Calendar.current.date(bySettingHour: 18, minute: 45, second: 0, of: now)!
        let isDay = current.isDaylight
        let solar = SolarEvents(sunrise: sunrise, sunset: sunset, isDaylight: isDay)
        
        // Pressure
        let pressureHpa = Int(round(current.pressure.converted(to: .hectopascals).value))
        
        return WeatherData(
            cityName: cityName,
            currentTemperature: currentTemp,
            highTemperature: highTemp,
            lowTemperature: lowTemp,
            condition: condition,
            hourlyForecast: hourlyItems,
            uvIndex: uv,
            wind: wind,
            solar: solar,
            pressureHpa: pressureHpa,
            lastUpdated: Date()
        )
    }
    
    private func mapAppleCondition(_ condition: WeatherKit.WeatherCondition) -> WeatherCondition {
        switch condition {
        case .clear, .mostlyClear:
            return .sunny
        case .partlyCloudy:
            return .partlyCloudy
        case .cloudy, .mostlyCloudy:
            return .cloudy
        case .rain, .drizzle, .heavyRain:
            return .rainy
        case .thunderstorms, .isolatedThunderstorms:
            return .stormy
        case .snow, .heavySnow, .flurries, .sleet:
            return .snowy
        case .windy, .breezy:
            return .windy
        case .foggy, .haze, .smoky:
            return .foggy
        default:
            return .partlyCloudy
        }
    }
    #endif
    
    /// Deterministic fallback adhering to diurnal curves when offline or without entitlements
    private func generatePhysicalFallbackWeather(cityName: String, latitude: Double, longitude: Double) -> WeatherData {
        let now = Date()
        let cal = Calendar.current
        let hour = Double(cal.component(.hour, from: now)) + (Double(cal.component(.minute, from: now)) / 60.0)
        
        // Diurnal Temperature: Low 24° at 05:00, High 34° at 14:30
        let rad = ((hour - 8.5) / 24.0) * 2.0 * .pi
        let temp = Int(round(29.0 + 5.0 * sin(rad)))
        
        // Condition
        let isDay = hour >= 6.0 && hour <= 19.0
        let cond: WeatherCondition = isDay ? (hour > 11.0 && hour < 16.0 ? .sunny : .partlyCloudy) : .clearNight
        
        // Next 6 hours
        var items: [HourlyForecast] = []
        let baseHour = cal.component(.hour, from: now)
        for i in 0..<6 {
            let fHour = (baseHour + i) % 24
            let fRad = ((Double(fHour) - 8.5) / 24.0) * 2.0 * .pi
            let fTemp = Int(round(29.0 + 5.0 * sin(fRad)))
            let fIsDay = fHour >= 6 && fHour <= 19
            let fCond: WeatherCondition = fIsDay ? .sunny : .clearNight
            
            let label: String
            if i == 0 {
                label = "Now"
            } else {
                let ampm = fHour >= 12 ? "PM" : "AM"
                let disp = fHour % 12 == 0 ? 12 : fHour % 12
                label = "\(disp) \(ampm)"
            }
            items.append(HourlyForecast(timeString: label, temperature: fTemp, condition: fCond))
        }
        
        // UV Index: Bell curve peaking at 13:00
        let uv: Double
        if hour >= 6.5 && hour <= 18.5 {
            let uvRad = ((hour - 6.5) / 12.0) * .pi
            uv = round(8.5 * sin(uvRad) * 10) / 10
        } else {
            uv = 0.0
        }
        
        // Wind
        let windRad = ((hour - 6.0) / 24.0) * 2.0 * .pi
        let speed = Int(round(15.0 + 7.0 * sin(windRad)))
        let deg = (Double(hour) / 24.0) * 360.0 + 45.0
        let wind = WindData(speedKmh: speed, gustKmh: speed + 8, directionDegrees: deg, cardinalDirection: "NE")
        
        // Solar
        let sunrise = cal.date(bySettingHour: 6, minute: 12, second: 0, of: now) ?? now
        let sunset = cal.date(bySettingHour: 19, minute: 2, second: 0, of: now) ?? now
        let solar = SolarEvents(sunrise: sunrise, sunset: sunset, isDaylight: isDay)
        
        // Pressure: Atmospheric tidal wave (1015 ± 3 hPa)
        let baroRad = (hour / 12.0) * 2.0 * .pi
        let baro = Int(round(1015.0 + 3.0 * cos(baroRad)))
        
        return WeatherData(
            cityName: cityName,
            currentTemperature: temp,
            highTemperature: 34,
            lowTemperature: 24,
            condition: cond,
            hourlyForecast: items,
            uvIndex: uv,
            wind: wind,
            solar: solar,
            pressureHpa: baro,
            lastUpdated: now
        )
    }
}
