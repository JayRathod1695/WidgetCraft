import SwiftUI

public struct BarometerWaveCapsule: View {
    public let pressureHpa: Int
    
    public init(pressureHpa: Int) {
        self.pressureHpa = pressureHpa
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("BAROMETER")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.tertiary)
                .tracking(0.8)
            
            Spacer()
            
            Text("\(pressureHpa) hPa")
                .font(.system(size: 20, weight: .light, design: .rounded))
                .foregroundStyle(.primary)
            
            Text("Normal Atmospheric")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            Spacer()
            
            // Barometer Wave Path
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                
                ZStack {
                    BarometerWaveShape()
                        .stroke(Color.white.opacity(0.15), style: StrokeStyle(lineWidth: 1.5, dash: [2, 2]))
                    
                    BarometerWaveShape()
                        .trim(from: 0, to: 0.75)
                        .stroke(
                            LinearGradient(
                                colors: [.pink.opacity(0.3), .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 2.2, lineCap: .round)
                        )
                        .shadow(color: .pink.opacity(0.7), radius: 4)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                        .shadow(color: .white, radius: 4)
                        .shadow(color: .pink, radius: 8)
                        .position(x: w * 0.75, y: h * 0.4)
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

public struct BarometerWaveShape: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 2, y: rect.height * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.3),
            control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.9)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.width - 2, y: rect.height * 0.2),
            control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.1)
        )
        return path
    }
}
