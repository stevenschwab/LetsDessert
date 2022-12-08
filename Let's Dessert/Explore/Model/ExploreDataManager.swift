//
//  ExploreDataManager.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/6/22.
//

import Foundation

protocol ExploreDataManagerDelegate {
    func didUpdateMeals(_ exploreManager: ExploreDataManager, meals: [MealItem])
    func didFailWithError(error: Error)
}

struct ExploreDataManager {
    
    let url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    
    var delegate: ExploreDataManagerDelegate?
    
    func fetchListOfMeals() {
        performRequest(with: url)
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
                        self.delegate?.didUpdateMeals(self, meals: meals)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ mealData: Data) -> [MealItem]? {
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(MealData.self, from: mealData)
            let sortedMealsAlphabetically = decodedData.meals.sorted {
                
                let meal1Name = $0.strMeal ?? ""
                let meal2Name = $1.strMeal ?? ""
                return meal1Name < meal2Name
            }
            
            return sortedMealsAlphabetically
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
