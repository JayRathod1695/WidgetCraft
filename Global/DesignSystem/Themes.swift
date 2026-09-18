import SwiftUI

/// Represents a reusable theme for widgets
public struct WidgetTheme: Identifiable, Equatable {
    public let id = UUID()
    public let name: String
    public let background: Color
    public let primary: Color
    public let secondary: Color
    public let accent: Color
}

/// Defines the top aesthetic theme combinations for WidgetCraft
public struct ThemeLibrary {
    public static let themes: [WidgetTheme] = [
        WidgetTheme(name: "Midnight", background: Color.black, primary: Color.white, secondary: Color.gray, accent: Color.blue),
        WidgetTheme(name: "Ocean", background: Color(red: 0.05, green: 0.2, blue: 0.4), primary: Color.white, secondary: Color.cyan, accent: Color.mint),
        WidgetTheme(name: "Sunset", background: Color(red: 0.1, green: 0.05, blue: 0.15), primary: Color.orange, secondary: Color.pink, accent: Color.purple),
        WidgetTheme(name: "Forest", background: Color(red: 0.05, green: 0.25, blue: 0.15), primary: Color(red: 0.95, green: 0.95, blue: 0.9), secondary: Color.mint, accent: Color.green),
        WidgetTheme(name: "Minimal", background: Color.white, primary: Color.black, secondary: Color.gray, accent: Color.black),
        WidgetTheme(name: "Cyberpunk", background: Color(red: 0.1, green: 0.05, blue: 0.2), primary: Color.cyan, secondary: Color.pink, accent: Color.yellow),
        WidgetTheme(name: "Coffee", background: Color(red: 0.3, green: 0.2, blue: 0.15), primary: Color(red: 0.95, green: 0.9, blue: 0.8), secondary: Color.brown, accent: Color.orange),
        WidgetTheme(name: "Sakura", background: Color(red: 0.98, green: 0.9, blue: 0.92), primary: Color(red: 0.3, green: 0.1, blue: 0.2), secondary: Color(red: 0.8, green: 0.4, blue: 0.5), accent: Color.pink),
        WidgetTheme(name: "Slate", background: Color(red: 0.15, green: 0.18, blue: 0.22), primary: Color.white, secondary: Color.gray, accent: Color.blue),
        WidgetTheme(name: "Solar", background: Color(red: 0.1, green: 0.15, blue: 0.3), primary: Color.yellow, secondary: Color.orange, accent: Color.red),
        WidgetTheme(name: "Lavender", background: Color(red: 0.9, green: 0.9, blue: 0.98), primary: Color(red: 0.2, green: 0.1, blue: 0.4), secondary: Color(red: 0.5, green: 0.4, blue: 0.7), accent: Color.purple),
        WidgetTheme(name: "Ruby", background: Color(red: 0.2, green: 0.05, blue: 0.05), primary: Color.white, secondary: Color(red: 0.9, green: 0.7, blue: 0.2), accent: Color.red),
        WidgetTheme(name: "Emerald", background: Color(red: 0.05, green: 0.2, blue: 0.1), primary: Color.white, secondary: Color(red: 0.5, green: 0.8, blue: 0.5), accent: Color(red: 0.9, green: 0.8, blue: 0.2)),
        WidgetTheme(name: "Aqua", background: Color(red: 0.9, green: 0.98, blue: 0.98), primary: Color(red: 0.1, green: 0.3, blue: 0.4), secondary: Color.teal, accent: Color.blue),
        WidgetTheme(name: "Monochrome", background: Color.black, primary: Color.white, secondary: Color(white: 0.5), accent: Color.white)
    ]
}
