//
//  String+Extensions.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation

extension String {
    func toDouble() -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let number = numberFormatter.number(from: self)?.doubleValue else {
            return 0.0
        }
        return number
    }

    func toInt() -> Int {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let number = numberFormatter.number(from: self)?.intValue else {
            return 0
        }
        return number
    }

    func toFloat() -> Float {
        let originalString = self.replace(target: ",", withString: "")
        let price = originalString.split(separator: " ")
        if let data = Float(price.last ?? "0.000") {
            return data
        }
        return 0.0
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)

    }
}
