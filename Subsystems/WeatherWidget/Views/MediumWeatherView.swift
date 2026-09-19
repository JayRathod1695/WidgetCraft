import SwiftUI

public struct MediumWeatherView: View {
    public let weather: WeatherData
    
    public init(weather: WeatherData) {
        self.weather = weather
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top Section
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(weather.cityName.uppercased())
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .tracking(1.0)
                        .lineLimit(1)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("\(weather.currentTemperature)°")
                            .font(.system(size: 38, weight: .light, design: .rounded))
                            .foregroundStyle(.primary)
                            .contentTransition(.numericText())
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(weather.condition.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            
                            Text("H: \(weather.highTemperature)°  L: \(weather.lowTemperature)°")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: weather.condition.sfSymbolName)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 38))
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
            Divider()
                .background(Color.white.opacity(0.15))
            
            // Hourly Shelf
            HStack(spacing: 0) {
                ForEach(weather.hourlyForecast) { item in
                    VStack(spacing: 2) {
                        Text(item.timeString)
                            .font(.system(size: 9, weight: .regular))
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: item.condition.sfSymbolName)
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 14))
                            .frame(height: 18)
                        
                        Text("\(item.temperature)°")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
