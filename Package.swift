// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "SystemFontOverride",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "SystemFontOverride", targets: ["SystemFontOverride"]),
    ],
    targets: [
        .target(
            name: "SystemFontOverride",
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
