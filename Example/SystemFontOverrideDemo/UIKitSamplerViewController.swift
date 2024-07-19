//
//  UIKitSamplerViewController.swift
//
//  Created by Yonat Sharon on 19/07/2024.
//

import UIKit

class UIKitSamplerViewController: UIViewController {
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIDatePicker styling
        let datePickerTitle = UILabel().with { $0.text = "UIDatePicker " }
        let datePickerStyleChooser = UISegmentedControl(items: ["compact", "inline", "wheels"]).with {
            $0.selectedSegmentIndex = 0
            $0.addTarget(self, action: #selector(changeDatePickerStyle), for: .valueChanged)
        }

        // Controls in a stack
        let stackView = UIStackView(arrangedSubviews: [
            UILabel().with { $0.text = "UILabel" },
            UIButton(type: .system).with { $0.setTitle("UIButton", for: .normal) },
            UISegmentedControl(items: ["UI", "Segmented", "Control"]),
            UITextField().with {
                $0.borderStyle = .roundedRect
                $0.placeholder = "UITextField"
            },
            UITextView().with {
                $0.text = " UITextView "
                $0.isScrollEnabled = false
                $0.layer.borderWidth = 0.5
                $0.layer.borderColor = UIColor.gray.cgColor
                $0.layer.cornerRadius = 8
            },
            UIView().with { // separator before date picker
                $0.backgroundColor = .gray
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 320).isActive = true
            },
            UIStackView(arrangedSubviews: [datePickerTitle, datePickerStyleChooser]),
            datePicker,
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }

    @objc func changeDatePickerStyle(_ sender: UISegmentedControl) {
        datePicker.preferredDatePickerStyle = switch sender.selectedSegmentIndex {
        case 0: .compact
        case 1: .inline
        case 2: .wheels
        default: .automatic
        }
    }
}

extension NSObjectProtocol {
    @inlinable
    func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

@available(iOS 17, *)
#Preview {
    UIFont.systemFontFamilyOverride = "Marker Felt"
    return UIKitSamplerViewController()
}
