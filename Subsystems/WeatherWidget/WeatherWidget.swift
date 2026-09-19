import WidgetKit
import SwiftUI

public struct WeatherWidget: Widget {
    public let kind: String = "WeatherWidget"
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherTimelineProvider()) { entry in
            WeatherWidgetView(entry: entry)
        }
        .configurationDisplayName("Glance Weather")
        .description("Clean, glanceable weather overview with hourly forecast and environmental telemetry.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}
