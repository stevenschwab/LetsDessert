//
//  MealIngredientCell.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/7/22.
//

import UIKit

class MealIngredientCell: UITableViewCell {
    
    @IBOutlet var ingredientLabel: UILabel!
    @IBOutlet var measurementLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func makeCell(ingredients: IngredientObject) {
        measurementLabel.text = ingredients.measurement
        ingredientLabel.text = ingredients.ingredient
    }

}
