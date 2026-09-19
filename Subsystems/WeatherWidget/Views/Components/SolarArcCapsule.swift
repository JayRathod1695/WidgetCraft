import SwiftUI

public struct SolarArcCapsule: View {
    public let solar: SolarEvents
    
    public init(solar: SolarEvents) {
        self.solar = solar
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(solar.isDaylight ? "SOLAR PATH" : "LUNAR PATH")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.tertiary)
                .tracking(0.8)
            
            Spacer()
            
            Text(solar.isDaylight ? "Sunset 5h 2m" : "Dawn 7h 10m")
                .font(.system(size: 15, weight: .light, design: .rounded))
                .foregroundStyle(.primary)
            
            Text("Dawn: 06:12 · Dusk: 19:02")
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            Spacer()
            
            // Parabolic Arc Geometry
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                let progress = solar.daylightProgress
                
                ZStack {
                    // Dotted Reference Arc
                    ParabolicArcShape()
                        .stroke(Color.white.opacity(0.15), style: StrokeStyle(lineWidth: 1.5, dash: [2, 2]))
                    
                    // Active Glowing Arc
                    ParabolicArcShape()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [.purple.opacity(0.4), .orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2.2, lineCap: .round)
                        )
                        .shadow(color: .orange.opacity(0.6), radius: 4)
                    
                    // Pearl Bead on curve
                    let pt = ParabolicArcShape.point(at: progress, width: w, height: h)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                        .shadow(color: .white, radius: 4)
                        .shadow(color: .orange, radius: 8)
                        .position(pt)
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

public struct ParabolicArcShape: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 2, y: rect.height - 2))
        path.addQuadCurve(
            to: CGPoint(x: rect.width - 2, y: rect.height - 2),
            control: CGPoint(x: rect.width / 2, y: 2)
        )
        return path
    }
    
    public static func point(at t: Double, width: CGFloat, height: CGFloat) -> CGPoint {
        let p0 = CGPoint(x: 2, y: height - 2)
        let p1 = CGPoint(x: width / 2, y: 2)
        let p2 = CGPoint(x: width - 2, y: height - 2)
        
        let invT = 1.0 - t
        let x = invT * invT * p0.x + 2 * invT * t * p1.x + t * t * p2.x
        let y = invT * invT * p0.y + 2 * invT * t * p1.y + t * t * p2.y
        return CGPoint(x: x, y: y)
    }
}
