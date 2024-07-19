//
//  SwiftUISamplerView.swift
//
//  Created by Yonat Sharon on 19/07/2024.
//

import SwiftUI

struct SwiftUISamplerView: View {
    private let choices = ["Two", "roads", "diverged", "in a", "yellow", "wood"]
    @State private var choiceIndex = 0
    @State private var text = ""
    @State private var date = Date()
    @State private var isToggleOn = false
    @State private var gaugeLevel = 0.123

    private var buttonFont: Font {
        .systemOverride(size: UIFont.buttonFontSize)
    }

    var body: some View {
        Form {
            Section(header: Text("Text Entry")) {
                TextField("TextField", text: $text)
                SecureField("SecureField", text: $text)
                TextEditor(text: .constant("TextEditor"))
            }

            Section(header: Text("Buttons")) {
                Button("Default") {}
                Button("Plain") {}
                    .buttonStyle(.plain)
                Button("Borderless - with .font()") {}
                    .buttonStyle(.borderless)
                    .font(buttonFont)
                if #available(iOS 15.0, *) {
                    Button("Bordered - with .font()") {}
                        .buttonStyle(.bordered)
                        .font(buttonFont)
                    Button("BorderedProminent - with .font()") {}
                        .buttonStyle(.borderedProminent)
                        .font(buttonFont)
                }
            }

            Section(header: Text("Toggles")) {
                Toggle(isOn: $isToggleOn) { Text("Switch Toggle - with .font()") }
                    .font(buttonFont)
                if #available(iOS 15.0, *) {
                    Toggle(isOn: $isToggleOn) { Text("Button Toggle - with .font()") }
                        .toggleStyle(.button)
                        .font(buttonFont)
                }
            }

            Section(header: Text("Misc Controls")) {
                ColorPicker("ColorPicker - with .font()", selection: .constant(.blue))
                    .font(buttonFont)
                ProgressView("ProgressView", value: 0.5)
                Link("Link", destination: URL(string: "https://ootips.org")!)
                if #available(iOS 14.5, *) {
                    Label("Label - with .font()", systemImage: "bolt.fill")
                        .font(buttonFont)
                }
                if #available(iOS 16.0, *) {
                    Gauge(value: gaugeLevel) { Text("Gauge") }
                }
            }

            Section(header: Text("Menu")) {
                Menu("Title - with .font()") {
                    ForEach(0 ..< choices.count, id: \.self) { index in
                        Button(choices[index]) {
                            choiceIndex = index
                        }
                    }
                }
                .font(buttonFont) // .font() works only for title
            }

            pickerSection(title: "Menu")
                .pickerStyle(.menu)
            if #available(iOS 16.0, *) {
                pickerSection(title: "Navigation Link")
                    .pickerStyle(.navigationLink)
            }
            pickerSection(title: "Segmented")
                .pickerStyle(.segmented) // .font() doesn't work, neither does swizzling
            pickerSection(title: "Inline")
                .pickerStyle(.inline)
            pickerSection(title: "Wheel")
                .pickerStyle(.wheel)

            Section(header: Text("Date Picker - compact")) {
                DatePicker("Title - with .font()", selection: $date)
                    .font(buttonFont) // .font() works only for title
            }

            Section(header: Text("Date Picker - wheel")) {
                DatePicker("Wheel", selection: $date)
                    .datePickerStyle(.wheel)
            }

            Section(header: Text("Date Picker - graphical")) {
                DatePicker("Graphical", selection: $date)
                    .datePickerStyle(.graphical)
            }
        }
    }

    private func pickerSection(title: String) -> some View {
        Section(header: Text("Picker - \(title)")) {
            Picker("Title - with .font()", selection: $choiceIndex) {
                ForEach(0 ..< choices.count, id: \.self) { index in
                    Text(choices[index])
                        .tag(index)
                }
            }
            .font(buttonFont) // for title
        }
    }
}

#Preview {
    UIFont.systemFontFamilyOverride = "Marker Felt"
    return SwiftUISamplerView()
}
