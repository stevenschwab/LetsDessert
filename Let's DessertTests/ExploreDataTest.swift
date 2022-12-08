//
//  ExploreTests.swift
//  Let's DessertTests
//
//  Created by Steven Schwab on 12/7/22.
//

import XCTest
@testable import Let_s_Dessert

final class ExploreDataTest: XCTestCase {

    func testCanParseDessertList() throws {
        let json = """
        {
            "meals": [
                {
                    "strMeal": "Apam balik",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                    "idMeal": "53049"
                },
                {
                    "strMeal": "Apple & Blackberry Crumble",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg",
                    "idMeal": "52893"
                }
            ]
        }
        """
        
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        let decodedData = try! decoder.decode(MealData.self, from: jsonData)
        
        XCTAssertEqual("Apam balik", decodedData.meals[0].strMeal)
        XCTAssertEqual("https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", decodedData.meals[0].strMealThumb)
        XCTAssertEqual("53049", decodedData.meals[0].idMeal)
    }
    
    func testCanParseDessertListWithEmptyId() throws {
        let json = """
        {
            "meals": [
                {
                    "strMeal": "Apam balik",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                    "idMeal": ""
                }
            ]
        }
        """
        
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        let decodedData = try! decoder.decode(MealData.self, from: jsonData)
        
        XCTAssertEqual("", decodedData.meals[0].idMeal)
    }
    
    func testCanParseDessertListViaJSONFile() throws {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "dessertList", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }
        
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        let decodedData = try! decoder.decode(MealData.self, from: jsonData)
        
        XCTAssertEqual("", decodedData.meals[2].idMeal)
    }
    
    func testCanParseDessertListAndSortAlphabetically() throws {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "dessertList", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }
        
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        let decodedData = try! decoder.decode(MealData.self, from: jsonData)
        let sortedMealsAlphabetically = decodedData.meals.sorted {
            
            let meal1Name = $0.strMeal ?? ""
            let meal2Name = $1.strMeal ?? ""
            return meal1Name < meal2Name
        }
        
        XCTAssertEqual("Bakewell tart", sortedMealsAlphabetically[3].strMeal)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
