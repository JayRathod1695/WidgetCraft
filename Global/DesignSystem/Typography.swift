import SwiftUI

/// Defines the top 30 font styles available in iOS for WidgetCraft.
public enum WidgetFont: String, CaseIterable {
    // Apple System Fonts
    case system = "System"
    case systemRounded = "System Rounded"
    case systemSerif = "New York"
    case systemMono = "System Mono"
    
    // Modern & Clean
    case avenirNext = "AvenirNext-Regular"
    case helveticaNeue = "HelveticaNeue"
    case futura = "Futura-Medium"
    case gillSans = "GillSans"
    case optima = "Optima-Regular"
    case trebuchetMS = "TrebuchetMS"
    
    // Serif & Elegant
    case baskerville = "Baskerville"
    case bodoni = "BodoniSvtyTwoITCTT-Book"
    case didot = "Didot"
    case georgia = "Georgia"
    case hoeflerText = "HoeflerText-Regular"
    case palatino = "Palatino-Roman"
    
    // Bold & Display
    case arialRounded = "ArialRoundedMTBold"
    case copperplate = "Copperplate"
    case rockwell = "Rockwell-Regular"
    case markerFelt = "MarkerFelt-Thin"
    case noteworthy = "Noteworthy-Light"
    
    // Monospaced & Technical
    case courierNew = "CourierNewPSMT"
    case menlo = "Menlo-Regular"
    
    // Unique & Decorative
    case bradleyHand = "BradleyHandITCTT-Bold"
    case chalkboard = "ChalkboardSE-Regular"
    case euphemia = "EuphemiaUCAS"
    case geezaPro = "GeezaPro"
    case papyrus = "Papyrus"
    case partyLet = "PartyLetPlain"
    case snellRoundhand = "SnellRoundhand"
    
    /// Returns the SwiftUI Font for the selected style and size
    public func font(size: CGFloat) -> Font {
        switch self {
        case .system:
            return .system(size: size)
        case .systemRounded:
            return .system(size: size, design: .rounded)
        case .systemSerif:
            return .system(size: size, design: .serif)
        case .systemMono:
            return .system(size: size, design: .monospaced)
        default:
            return .custom(self.rawValue, size: size)
        }
    }
}
