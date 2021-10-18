//
//  Color-extension .swift
//  CryptoTracker
//
//  Created by Leo Kim on 18/10/2021.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("redColor")
    let secondaryText = Color("SecondaryTextColor")
}
