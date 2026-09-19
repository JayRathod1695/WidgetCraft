import SwiftUI

public struct SmallWeatherView: View {
    public let weather: WeatherData
    
    public init(weather: WeatherData) {
        self.weather = weather
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(weather.cityName.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
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
