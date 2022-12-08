//
//  MealDetailModel.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/7/22.
//

import Foundation

class MealDetailModel {
    let idMeal: String?
    let strMeal: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strTags: String?
    let ingredients: [IngredientObject]
    let strSource: String?
    
    init(idMeal: String?, strMeal: String?, strCategory: String?, strArea: String?, strInstructions: String?, strTags: String?, ingredients: [IngredientObject], strSource: String?) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strCategory = strCategory
        self.strArea = strArea
        self.strInstructions = strInstructions
        self.strTags = strTags
        self.ingredients = ingredients
        self.strSource = strSource
    }
}

class IngredientObject {
    var number: Substring?
    var ingredient: String?
    var measurement: String?
    
    init(number: Substring? = nil, ingredient: String? = nil, measurement: String? = nil) {
        self.number = number
        self.ingredient = ingredient
        self.measurement = measurement
    }
}
