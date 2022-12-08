//
//  MealDetailDataManager.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/6/22.
//

import Foundation

protocol MealDetailDataManagerDelegate {
    func didUpdateMeals(_ mealDetailManager: MealDetailDataManager, mealDetail: MealDetailModel)
    func didFailWithError(error: Error)
}

struct MealDetailDataManager {
    
    let url = "https://www.themealdb.com/api/json/v1/1/lookup.php"
    
    var delegate: MealDetailDataManagerDelegate?
    
    func fetchMealDetail(meal: MealItem) {
        if let mealId = meal.idMeal {
            let urlString = "\(url)?i=\(String(describing: mealId))"
            performRequest(with: urlString)
        }
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let meals = self.parseJSON(safeData) {
                        if let mealDetailItem = convertToMealDetailModel(meals: meals) {
                            self.delegate?.didUpdateMeals(self, mealDetail: mealDetailItem)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ mealData: Data) -> [MealDetailItem]? {
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(MealDetailData.self, from: mealData)

            return decodedData.meals
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func convertToMealDetailModel(meals: [MealDetailItem]) -> MealDetailModel? {
        let meal = meals[0]
        let mirror = Mirror(reflecting: meal)
        var ingredients: [IngredientObject] = []
        
        for child in mirror.children {
            let ingredientIdentifier = "strIngredient"
            let measurementIdentifier = "strMeasure"
            
            if let key = child.label, let value = child.value as? String {
                if value != "" && value != " " {
                    if key.prefix(13) == ingredientIdentifier {
                        var foundIngredient = false
                        
                        for ingredient in ingredients {
                            if ingredient.number == key.suffix((key.count - 13)) {
                                ingredient.ingredient = value
                                foundIngredient = true
                            }
                        }
                        
                        if !foundIngredient {
                            let ingredientObject = IngredientObject(number: key.suffix((key.count - 13)), ingredient: value)
                            ingredients.append(ingredientObject)
                        }
                    }
                    if key.prefix(10) == measurementIdentifier {
                        var foundMeasurement = false
                        
                        for ingredient in ingredients {
                            if ingredient.number == key.suffix((key.count - 10)) {
                                ingredient.measurement = value
                                foundMeasurement = true
                            }
                        }
                        
                        if !foundMeasurement {
                            let ingredientObject = IngredientObject(number: key.suffix((key.count - 10)), measurement: value)
                            ingredients.append(ingredientObject)
                        }
                    }
                }
            }
        }        
        
        return MealDetailModel(idMeal: meal.idMeal, strMeal: meal.strMeal, strCategory: meal.strCategory, strArea: meal.strArea, strInstructions: meal.strInstructions, strTags: meal.strTags, ingredients: ingredients, strSource: meal.strSource)
    }
}
