//
//  MealData.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/6/22.
//

import Foundation

struct MealData: Decodable {
    let meals: [MealItem]
}

struct MealItem: Decodable {
    let strMeal: String?
    let strMealThumb: String?
    let idMeal: String?
}

extension MealItem: Equatable {
    static func == (lhs: MealItem, rhs: MealItem) -> Bool {
        return lhs.idMeal == rhs.idMeal
    }
}
