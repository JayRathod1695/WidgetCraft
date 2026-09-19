import SwiftUI

public struct LargeWeatherView: View {
    public let weather: WeatherData
    
    public init(weather: WeatherData) {
        self.weather = weather
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // 1. Clean Header (Pure Typography, No Clock, No Icon)
            HStack {
                Text(weather.cityName.uppercased())
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .tracking(1.2)
                    .lineLimit(1)
                Spacer()
            }
            
            // 2. Hero Row: Large Temp, Condition, Hi/Lo, and Visual Scene
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(weather.currentTemperature)°")
                        .font(.system(size: 64, weight: .thin, design: .rounded))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())
                    
                    Text(weather.condition.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text("H: \(weather.highTemperature)° · L: \(weather.lowTemperature)°")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Vector Weather Scene
                ZStack {
                    if weather.solar.isDaylight {
                        Image(systemName: weather.condition.sfSymbolName)
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 58))
                            .shadow(color: .orange.opacity(0.35), radius: 12, x: 0, y: 0)
                    } else {
                        Image(systemName: "moon.stars.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.cyan.opacity(0.9), Color.white)
                            .font(.system(size: 54))
                            .shadow(color: .cyan.opacity(0.4), radius: 12, x: 0, y: 0)
                    }
                }
                .frame(width: 80, height: 80)
            }
            
            // 3. Hourly Forecast Shelf (Glass Capsule)
            HourlyShelfView(hourlyForecast: weather.hourlyForecast)
            
            // 4. The 4 Integrated Capsules Grid
            HStack(spacing: 12) {
                UVIndexCapsule(uvIndex: weather.uvIndex)
                SolarArcCapsule(solar: weather.solar)
                WindCompassCapsule(wind: weather.wind)
                BarometerWaveCapsule(pressureHpa: weather.pressureHpa)
            }
            .frame(height: 116)
        }
    }
}
