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
        
        let entry = WeatherEntry(date: currentDate, weather: .previewData)
        
        // Refresh every 1 hour to respect WidgetKit reload policy & preserve battery
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(3600)
        
        #if DEBUG
        print("[WeatherWidget][DEBUG] Scheduled next timeline update for \(nextUpdate)")
        #endif
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}
