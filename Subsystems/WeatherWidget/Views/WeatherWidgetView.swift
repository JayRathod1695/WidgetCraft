import SwiftUI
import WidgetKit

public struct WeatherWidgetView: View {
    @Environment(\.widgetFamily) var systemFamily
    public let entry: WeatherEntry
    public let customFamily: WidgetFamily?
    
    public init(entry: WeatherEntry, family: WidgetFamily? = nil) {
        self.entry = entry
        self.customFamily = family
    }
    
    private var effectiveFamily: WidgetFamily {
        customFamily ?? systemFamily
    }
    
    public var body: some View {
        ZStack {
            // Native macOS Glassmorphism Backing
            ContainerRelativeShape()
                .fill(.ultraThinMaterial)
            
            // Subtle Hairline Glass Border
            ContainerRelativeShape()
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
            
            // Specular Glare Strip
            VStack {
                LinearGradient(
                    colors: [Color.white.opacity(0.08), Color.white.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
                Spacer()
            }
            .allowsHitTesting(false)
            
            // Family Router
            switch effectiveFamily {
            case .systemSmall:
                SmallWeatherView(weather: entry.weather)
                    .padding(14)
            case .systemMedium:
                MediumWeatherView(weather: entry.weather)
                    .padding(16)
            default:
                LargeWeatherView(weather: entry.weather)
                    .padding(24)
            }
        }
    }
}
