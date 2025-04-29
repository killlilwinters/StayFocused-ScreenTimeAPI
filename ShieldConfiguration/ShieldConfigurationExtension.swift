//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Maks Winters on 29.04.2025.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            icon: UIImage(systemName: "hourglass")?.withTintColor(.white),
            title: .init(text: "Your timer hasn't finished yet.", color: .white),
            subtitle: .init(text: "You cannot use this app at the moment.", color: .white),
            primaryButtonLabel: .init(text: "Close", color: .black),
            primaryButtonBackgroundColor: .white,
            secondaryButtonLabel: .init(text: "Remove Shield", color: .secondaryLabel)
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            icon: UIImage(systemName: "hourglass")?.withTintColor(.white),
            title: .init(text: "Your timer hasn't finished yet.", color: .white),
            subtitle: .init(text: "You cannot use this app at the moment.", color: .white),
            primaryButtonLabel: .init(text: "Close", color: .black),
            primaryButtonBackgroundColor: .white,
            secondaryButtonLabel: .init(text: "Remove Shield", color: .secondaryLabel)
        )
    }
}
