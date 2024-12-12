//
//  Ingredient+Render.swift
//  Recipe Magic
//
//  Created by Matthew Cooper on 12/10/24.
//

import Foundation

extension Ingredient {
    var ingredientText: String {
        let ingredientText = name
        
        return ingredientText.capitalizingFirstLetter // Makes sure the first letter is capitalized so it is easier to read
    }
    
    var quantityText: String {
        formattedQuantity(qualifier, quantity, unit)
    }
    // To standardize the formats for units. Might change later
    private func convertedUnit(for unit: String) -> String {
        for substitution in Conversion.units {
            if substitution.0 == unit {
                return substitution.1
            }
        }
        
        return " \(unit)" // Need the space in front of the unit for readability
    }
    // The _ means that we don't need an external label when the function is called
    // Basically so that when we call we don't have to put unit: "cup" instead we can just say "cup"
    private func formattedQuantity(_ qualifier: String?, _ quantity: Decimal?, _ unit: String?) -> String {
        var formattedQuantity = ""
        
        if let qualifier {
            formattedQuantity = qualifier
        }
        
        let amount = text(for: quantity ?? 0, with: unit ?? "")
        
        if !amount.isEmpty {
            if !formattedQuantity.isEmpty {
                formattedQuantity += " "
            }
            
            formattedQuantity += amount
            
            if let unit, !unit.isEmpty {
                formattedQuantity += convertedUnit(for: unit)
            }
        }
        
        return formattedQuantity
    }
    
    private func text(for quantity: Decimal, with unit: String) -> String {
        if quantity.isEffectivelyZero {
            return ""
        }
        
        if unit != "g" && unit != "kg" {
            var quantityText = ""
            let (integerPart, fractionalPart) = modf(quantity.doubleValue)
            
            if !integerPart.isEffectivelyZero {
                quantityText = "\(Int(integerPart)) "
            }
            
            if let fraction = vulgarFraction(fractionalPart) {
                return quantityText + fraction
            }
        }
        
        return "\(quantity)"
    }
    
    private func vulgarFraction(_ fraction: Double) -> String? {
        for fractionCandidate in Conversion.vulgarFractions {
            if fraction.isApproximately(fractionCandidate.amount) {
                return fractionCandidate.text
            }
        }
        
        return nil
    }
    
    typealias VulgarConversion = (amount: Double, text: String) // Holding the fraction amount and its text representation
    
    private struct Conversion {
        static let units = [
            ("tsp", " tsp."),
            ("Tbsp", " Tbsp."),
            ("g", " g"),
            ("ml", " ml"),
            ("cup", " C.")
        ]
        
        static let vulgarFractions: [VulgarConversion] = [
            (1.0 / 8, "⅛"),
            (2.0 / 8, "¼"),
            (3.0 / 8, "⅜"),
            (1.0 / 3, "⅓"),
            (4.0 / 8, "½"),
            (5.0 / 8, "⅝"),
            (2.0 / 3, "⅔"),
            (6.0 / 8, "¾"),
            (7.0 / 8, "⅞")
        ]
    }
}
