// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WidgetCraft",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "WidgetCraftApp", targets: ["WidgetCraftApp"]),
        .library(name: "Global", targets: ["Global"]),
        .library(name: "WeatherWidgetSubsystem", targets: ["WeatherWidgetSubsystem"]),
    ],
    targets: [
        .target(
            name: "Global",
            path: "Global",
            exclude: ["README.md"]
        ),
        .target(
            name: "WeatherWidgetSubsystem",
            dependencies: ["Global"],
            path: "Subsystems/WeatherWidget",
            exclude: ["preview.jpg"]
        ),
        .executableTarget(
            name: "WidgetCraftApp",
            dependencies: ["Global", "WeatherWidgetSubsystem"],
            path: "App",
            exclude: ["README.md"]
        ),
    ]
)
