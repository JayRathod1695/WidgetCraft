import SwiftUI

public struct UVIndexCapsule: View {
    public let uvIndex: Double
    
    public init(uvIndex: Double) {
        self.uvIndex = uvIndex
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("UV INDEX")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.tertiary)
                .tracking(0.8)
            
            Spacer()
            
            Text("UVI \(String(format: "%.1f", uvIndex))")
                .font(.system(size: 20, weight: .light, design: .rounded))
                .foregroundStyle(.primary)
            
            Text("Peak 1:30 PM")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            // Dynamic Spectrum Bar with Glass Runner
            GeometryReader { geo in
                let progress = max(0.02, min(0.96, uvIndex / 11.0))
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.green, .yellow, .orange, .red, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 10)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 14, height: 14)
                        .shadow(color: .white, radius: 4)
                        .shadow(color: .orange, radius: 8)
                        .offset(x: (geo.size.width - 14) * progress)
                }
            }
            .frame(height: 14)
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
