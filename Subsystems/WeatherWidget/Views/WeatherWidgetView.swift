import SwiftUI
import WidgetKit

public struct WeatherWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: WeatherEntry
    
    public init(entry: WeatherEntry) {
        self.entry = entry
    }
    
    public var body: some View {
        ZStack {
            // Native macOS Glassmorphism Backing
            ContainerRelativeShape()
                .fill(.ultraThinMaterial)
                .overlay(
                    ContainerRelativeShape()
                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                )
            
            switch family {
            case .systemSmall:
                SmallWeatherLayout(weather: entry.weather)
            default:
                MediumWeatherLayout(weather: entry.weather)
            }
        }
        .padding(12)
    }
}

// MARK: - Medium Layout (Standard macOS Desktop Widget)
private struct MediumWeatherLayout: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Top Row: Location, Temp, and Large Visual Icon
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(weather.cityName.uppercased())
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        .tracking(1.0)
                    
                    Text("\(weather.currentTemperature)°")
                        .font(.system(size: 44, weight: .medium, design: .rounded))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())
                    
                    Text(weather.condition.rawValue)
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundStyle(.primary)
                    
                    Text("H: \(weather.highTemperature)°  L: \(weather.lowTemperature)°")
                        .font(.system(size: 11, weight: .medium, design: .default))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Focal Condition Icon
                Image(systemName: weather.condition.sfSymbolName)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 48))
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            // Bottom Row: Hourly Forecast
            HStack(spacing: 0) {
                ForEach(weather.hourlyForecast) { item in
                    VStack(spacing: 4) {
                        Text("\(item.temperature)°")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        
                        Image(systemName: item.condition.sfSymbolName)
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 16))
                        
                        Text(item.timeString)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Small Layout
private struct SmallWeatherLayout: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(weather.cityName)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: weather.condition.sfSymbolName)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 20))
            }
            
            Spacer()
            
            Text("\(weather.currentTemperature)°")
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .foregroundStyle(.primary)
            
            Text(weather.condition.rawValue)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
            
            Text("H:\(weather.highTemperature)° L:\(weather.lowTemperature)°")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}
