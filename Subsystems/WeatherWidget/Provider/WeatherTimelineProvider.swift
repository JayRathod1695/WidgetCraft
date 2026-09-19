import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
public struct WeatherEntry: TimelineEntry {
    public let date: Date
    public let weather: WeatherData
    
    public init(date: Date, weather: WeatherData) {
        self.date = date
        self.weather = weather
    }
}

// Helper wrapper to safely send WidgetKit completion closure across Swift 6 tasks
private struct SendableCompletion<T>: @unchecked Sendable {
    let handler: (T) -> Void
    init(_ handler: @escaping (T) -> Void) {
        self.handler = handler
    }
}

// MARK: - Timeline Provider
public struct WeatherTimelineProvider: TimelineProvider {
    public typealias Entry = WeatherEntry
    
    public init() {}
    
    public func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), weather: .previewData)
    }
    
    public func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
        #if DEBUG
        print("[WeatherWidget][DEBUG] Generating snapshot for context family: \(context.family)")
        #endif
        let entry = WeatherEntry(date: Date(), weather: .previewData)
        completion(entry)
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let currentDate = Date()
        #if DEBUG
        print("[WeatherWidget][DEBUG] getTimeline requested at \(currentDate). Calculating refresh schedule.")
        #endif
        
        let sendableCallback = SendableCompletion(completion)
        Task {
            let liveData = await WeatherService.shared.fetchLiveWeather()
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
            let entry = WeatherEntry(date: currentDate, weather: liveData)
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            sendableCallback.handler(timeline)
        }
    }
}
