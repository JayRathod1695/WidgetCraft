import SwiftUI

public struct HourlyShelfView: View {
    public let hourlyForecast: [HourlyForecast]
    
    public init(hourlyForecast: [HourlyForecast]) {
        self.hourlyForecast = hourlyForecast
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(hourlyForecast) { item in
                VStack(spacing: 4) {
                    Text(item.timeString)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.tertiary)
                    
                    Image(systemName: item.condition.sfSymbolName)
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 18))
                        .frame(height: 22)
                    
                    Text("\(item.temperature)°")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
