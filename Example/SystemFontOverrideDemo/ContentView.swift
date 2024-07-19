//
//  ContentView.swift
//
//  Created by Yonat Sharon on 19/07/2024.
//

import SwiftUI
import SystemFontOverride

struct ContentView: View {
    @AppStorage("systemFontFamilyOverride") private var systemFontFamilyOverride = "Chalkboard SE" {
        didSet {
            UIFont.systemFontFamilyOverride = systemFontFamilyOverride.isEmpty ? nil : systemFontFamilyOverride
        }
    }

    private let navigationTitle = "System Font Override"
    private let fontFamilies = UIFont.familyNames
    @State private var fontFamilyIndex = 0

    init() {
        systemFontFamilyOverride = { systemFontFamilyOverride }()
        if let index = fontFamilies.firstIndex(of: systemFontFamilyOverride) {
            fontFamilyIndex = index
        }
    }

    var body: some View {
        TabView {
            NavigationView {
                Form {
                    Section(header: Text("Using this demo")) {
                        Text("""
                        Select a font below, and then force-quit and restart the app.

                        Most UI elements will just work with the override font, but some require explicit `.font()` modifier to update their title font:

                        - `Picker`
                        - `Menu`
                        - `Toggle`
                        - `bordered` and `borderedProminent` button styles
                        - `Label` in some contexts
                        """)
                    }

                    Section(header: Text("Override System Font")) {
                        NavigationLink {
                            Form {
                                Picker("Fonts", selection: $fontFamilyIndex) {
                                    ForEach(0 ..< fontFamilies.count, id: \.self) { index in
                                        Text(fontFamilies[index])
                                            .font(.custom(fontFamilies[index], size: 16))
                                            .tag(index)
                                    }
                                }
                                .font(.systemOverride(size: UIFont.buttonFontSize)) // for title
                                .pickerStyle(.inline)
                            }
                            .navigationTitle("Change Font")
                        } label: {
                            HStack {
                                Text("Change Font")
                                Spacer()
                                Text(systemFontFamilyOverride)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.ultraLight)
                            }
                        }
                    }
                }
                .onChange(of: fontFamilyIndex) { _ in
                    systemFontFamilyOverride = fontFamilyIndex >= 0 ? fontFamilies[fontFamilyIndex] : ""
                }
                .navigationTitle(navigationTitle)
            }
            .tabItem { Label("Font", systemImage: "f.cursive.circle.fill") }

            NavigationView {
                SwiftUISamplerView()
                    .navigationTitle(navigationTitle)
            }
            .tabItem { Label("SwiftUI", systemImage: "swift") }

            NavigationView {
                UIKitSamplerViewRepresentable()
                    .navigationTitle(navigationTitle)
            }
            .tabItem { Label("UIKit", systemImage: "apple.logo") }
        }
    }
}

struct UIKitSamplerViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIKitSamplerViewController {
        UIKitSamplerViewController()
    }

    func updateUIViewController(_ uiViewController: UIKitSamplerViewController, context: Context) {}
}

#Preview {
    ContentView()
}
