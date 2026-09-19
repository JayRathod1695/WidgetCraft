import Foundation
import CoreLocation

// MARK: - CoreLocation Service (User's City Only)
@MainActor
public final class LocationService: NSObject, ObservableObject {
    public static let shared = LocationService()
    
    private let manager = CLLocationManager()
    @Published public var currentLocation: CLLocation?
    @Published public var cityName: String = "SURAT, GUJARAT"
    @Published public var isAuthorized: Bool = false
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    public func requestCurrentLocation() {
        #if DEBUG
        print("[LocationService][DEBUG] Requesting user's current city location")
        #endif
        #if os(iOS)
        manager.requestWhenInUseAuthorization()
        #else
        manager.requestAlwaysAuthorization()
        #endif
        manager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        #if os(iOS)
        let authorized = (status == .authorizedAlways || status == .authorizedWhenInUse)
        #else
        let authorized = (status == .authorizedAlways)
        #endif
        
        Task { @MainActor in
            self.isAuthorized = authorized
            #if DEBUG
            print("[LocationService][DEBUG] Location status: \(status.rawValue), authorized: \(authorized)")
            #endif
            if authorized {
                self.manager.startUpdatingLocation()
            }
        }
    }
    
    nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        
        Task { @MainActor in
            self.manager.stopUpdatingLocation()
            self.currentLocation = loc
            
            let geocoder = CLGeocoder()
            if let placemarks = try? await geocoder.reverseGeocodeLocation(loc),
               let place = placemarks.first {
                let locality = place.locality ?? place.subAdministrativeArea ?? "SURAT"
                let adminArea = place.administrativeArea ?? "GUJARAT"
                let formatted = "\(locality.uppercased()), \(adminArea.uppercased())"
                self.cityName = formatted
                #if DEBUG
                print("[LocationService][DEBUG] Resolved user's city: \(formatted)")
                #endif
            }
        }
    }
    
    nonisolated public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if DEBUG
        print("[LocationService][ERROR] Failed to get live location: \(error.localizedDescription)")
        #endif
    }
}
