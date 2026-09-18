import SwiftUI
import WidgetKit
import WeatherWidgetSubsystem
import Global

@main
struct WidgetCraftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LiveWidgetDashboardView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 580, height: 500)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

struct CityCoordinate: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let lat: Double
    let lon: Double
}

struct LiveWidgetDashboardView: View {
    @State private var weatherData: WeatherData = .previewData
    @State private var isLoading: Bool = false
    @State private var selectedCity: CityCoordinate = CityCoordinate(name: "Surat", lat: 21.1981, lon: 72.8298)
    @State private var previewFamily: PreviewFamily = .medium
    @State private var statusMessage: String = "Live Data Connected"
    
    enum PreviewFamily: String, CaseIterable {
        case medium = "Desktop Medium"
        case small = "Desktop Small"
    }
    
    let cities = [
        CityCoordinate(name: "Surat", lat: 21.1981, lon: 72.8298),
        CityCoordinate(name: "Mumbai", lat: 19.0760, lon: 72.8777),
        CityCoordinate(name: "Delhi", lat: 28.6139, lon: 77.2090),
        CityCoordinate(name: "San Francisco", lat: 37.7749, lon: -122.4194),
        CityCoordinate(name: "London", lat: 51.5074, lon: -0.1278),
        CityCoordinate(name: "Tokyo", lat: 35.6762, lon: 139.6503)
    ]
    
    var body: some View {
        ZStack {
            // macOS Visual Effect blurred background
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor).opacity(0.85),
                    Color(nsColor: .underPageBackgroundColor).opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Bar
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text("WidgetCraft")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(isLoading ? Color.orange : Color.green)
                                    .frame(width: 8, height: 8)
                                Text(isLoading ? "Updating..." : "LIVE")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(isLoading ? .orange : .green)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.ultraThinMaterial, in: Capsule())
                        }
                        
                        Text("Interactive macOS Widget Preview & Live Engine")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    // City Picker
                    Picker("", selection: $selectedCity) {
                        ForEach(cities) { city in
                            Text(city.name).tag(city)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 140)
                    .onChange(of: selectedCity) { _, newCity in
                        Task { await loadLiveWeather(for: newCity) }
                    }
                    
                    // Refresh Button
                    Button {
                        Task { await loadLiveWeather(for: selectedCity) }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(isLoading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Widget Family Segmented Control
                Picker("Size", selection: $previewFamily) {
                    ForEach(PreviewFamily.allCases, id: \.self) { fam in
                        Text(fam.rawValue).tag(fam)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 240)
                
                Spacer(minLength: 10)
                
                // Live Widget Display Area
                VStack {
                    if previewFamily == .medium {
                        WeatherWidgetView(entry: WeatherEntry(date: Date(), weather: weatherData), family: .systemMedium)
                            .frame(width: 340, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    } else {
                        WeatherWidgetView(entry: WeatherEntry(date: Date(), weather: weatherData), family: .systemSmall)
                            .frame(width: 160, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                    }
                }
                .frame(height: 200)
                
                Spacer(minLength: 10)
                
                // Footer Status
                HStack {
                    Text("📍 \(weatherData.cityName): \(weatherData.currentTemperature)°C | \(weatherData.condition.rawValue) | H:\(weatherData.highTemperature)° L:\(weatherData.lowTemperature)°")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("Updated: \(weatherData.lastUpdated.formatted(date: .omitted, time: .standard))")
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .task {
            await loadLiveWeather(for: selectedCity)
        }
    }
    
    private func loadLiveWeather(for city: CityCoordinate) async {
        isLoading = true
        statusMessage = "Fetching live weather for \(city.name)..."
        do {
            let data = try await WeatherService.shared.fetchLiveWeather(
                cityName: city.name,
                latitude: city.lat,
                longitude: city.lon
            )
            await MainActor.run {
                self.weatherData = data
                self.isLoading = false
                self.statusMessage = "Connected to Live Data"
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.statusMessage = "Failed: \(error.localizedDescription)"
            }
        }
    }
}
