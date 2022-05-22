//
//  Double+Extensions.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import Foundation

// MARK: Double Extensions
extension Double {
    /// Fixes double values to a provided number of decimal places
    /// - Parameter places: Number of decimal places
    /// - Returns: Double fixed to a certain number of decimal places
    func fixedTo(_ places: Int) -> Double {
        let divisor: Double = pow(10, Double(places))
        return (divisor * self).rounded() / divisor
    }
}
