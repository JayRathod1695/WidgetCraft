import SwiftUI

public struct WindCompassCapsule: View {
    public let wind: WindData
    
    public init(wind: WindData) {
        self.wind = wind
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("WIND")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.tertiary)
                .tracking(0.8)
            
            Spacer()
            
            Text("\(wind.speedKmh) km/h")
                .font(.system(size: 20, weight: .light, design: .rounded))
                .foregroundStyle(.primary)
            
            Text("Gusts \(wind.gustKmh) km/h · \(wind.cardinalDirection)")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            Spacer()
            
            // Mini 360° Compass Dial & Cyan Vector Needle
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                        .background(Circle().fill(Color.white.opacity(0.04)))
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.cyan)
                        .shadow(color: .cyan, radius: 4)
                        .rotationEffect(.degrees(wind.directionDegrees))
                }
                
                // Velocity Streamlines
                VStack(spacing: 3) {
                    Capsule().fill(Color.cyan.opacity(0.7)).frame(height: 2)
                    Capsule().fill(Color.cyan.opacity(0.4)).frame(height: 2).padding(.trailing, 8)
                }
            }
            .frame(height: 24)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
