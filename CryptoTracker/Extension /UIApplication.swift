//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Leo Kim on 19/10/2021.
//

import Foundation

import SwiftUI
extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil)
    }
}
