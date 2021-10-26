//
//  String.swift
//  CryptoTracker
//
//  Created by Leo Kim on 21/10/2021.
//

import Foundation

extension String {
    var removingHTMLOccurrences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
