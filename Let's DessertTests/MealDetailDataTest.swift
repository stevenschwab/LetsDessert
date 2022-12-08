//
//  MealDetailTests.swift
//  Let's DessertTests
//
//  Created by Steven Schwab on 12/7/22.
//

import XCTest
@testable import Let_s_Dessert

final class MealDetailDataTest: XCTestCase {
    
    func testCanParseMealDetailViaJSONFile() throws {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "mealDetails", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }
        
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        let decodedData = try! decoder.decode(MealDetailData.self, from: jsonData)
        
        XCTAssertEqual("Apple Frangipan Tart", decodedData.meals[0].strMeal)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
