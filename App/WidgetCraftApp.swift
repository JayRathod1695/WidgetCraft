import SwiftUI
import WidgetKit
import WeatherWidgetSubsystem
import Global
import CoreLocation

@main
struct WidgetCraftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LiveWidgetDashboardView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 760, height: 700)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

struct LiveWidgetDashboardView: View {
    @StateObject private var locationService = LocationService.shared
    @State private var weatherData: WeatherData = .previewData
    @State private var isLoading: Bool = false
    @State private var previewFamily: PreviewFamily = .large
    
    enum PreviewFamily: String, CaseIterable {
        case large = "Master Widget (Large)"
        case medium = "Desktop Medium"
        case small = "Desktop Small"
    }
    
    var body: some View {
        ZStack {
            // Dark Radial Glassmorphism Background
            RadialGradient(
                colors: [Color(red: 0.07, green: 0.10, blue: 0.16), Color(red: 0.03, green: 0.04, blue: 0.06)],
                center: .top,
                startRadius: 50,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Control Bar: Focused purely on user's city
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text("WidgetCraft")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(isLoading ? Color.orange : Color.green)
                                    .frame(width: 8, height: 8)
                                Text(isLoading ? "Fetching Live..." : "LIVE")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(isLoading ? .orange : .green)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(Capsule().strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                        }
                        
                        Text(locationService.cityName)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(.cyan)
                    }
                    
                    Spacer()
                    
                    // Refresh Button
                    Button {
                        Task { await refreshWeather() }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 11, weight: .semibold))
                            Text("Refresh")
                                .font(.system(size: 11, weight: .semibold))
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isLoading)
                }
                .padding(.horizontal, 28)
                .padding(.top, 22)
                
                // Widget Family Selector
                Picker("Size", selection: $previewFamily) {
                    ForEach(PreviewFamily.allCases, id: \.self) { fam in
                        Text(fam.rawValue).tag(fam)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 380)
                
                Spacer(minLength: 10)
                
                // Widget Display Container
                Group {
                    switch previewFamily {
                    case .large:
                        WeatherWidgetView(entry: WeatherEntry(date: Date(), weather: weatherData), family: .systemLarge)
                            .frame(width: 660, height: 460)
                            .clipShape(RoundedRectangle(cornerRadius: 38, style: .continuous))
                            .shadow(color: .black.opacity(0.6), radius: 30, x: 0, y: 15)
                    case .medium:
                        WeatherWidgetView(entry: WeatherEntry(date: Date(), weather: weatherData), family: .systemMedium)
                            .frame(width: 340, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    case .small:
                        WeatherWidgetView(entry: WeatherEntry(date: Date(), weather: weatherData), family: .systemSmall)
                            .frame(width: 160, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: previewFamily)
                
                Spacer(minLength: 10)
                
                // Footer Status
                HStack {
                    Text("📍 \(weatherData.cityName): \(weatherData.currentTemperature)°C · \(weatherData.condition.rawValue) · UV \(String(format: "%.1f", weatherData.uvIndex)) · \(weatherData.wind.speedKmh) km/h \(weatherData.wind.cardinalDirection) · \(weatherData.pressureHpa) hPa")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("Updated: \(weatherData.lastUpdated.formatted(date: .omitted, time: .standard))")
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 16)
            }
        }
        .onReceive(locationService.$currentLocation) { newLoc in
            if let loc = newLoc {
                Task {
                    await loadWeather(
                        for: locationService.cityName,
                        lat: loc.coordinate.latitude,
                        lon: loc.coordinate.longitude
                    )
                }
            }
        }
        .task {
            locationService.requestCurrentLocation()
            await refreshWeather()
        }
    }
    
    private func refreshWeather() async {
        if let loc = locationService.currentLocation {
            await loadWeather(
                for: locationService.cityName,
                lat: loc.coordinate.latitude,
                lon: loc.coordinate.longitude
            )
        } else {
            // Default to user's city Surat, Gujarat
            await loadWeather(for: "SURAT, GUJARAT", lat: 21.1981, lon: 72.8298)
        }
    }
    
    private func loadWeather(for city: String, lat: Double, lon: Double) async {
        isLoading = true
        let data = await WeatherService.shared.fetchLiveWeather(cityName: city, latitude: lat, longitude: lon)
        await MainActor.run {
            self.weatherData = data
            self.isLoading = false
        }
    }
}
