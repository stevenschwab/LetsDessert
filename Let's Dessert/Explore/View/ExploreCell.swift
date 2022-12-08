//
//  ExploreCellCollectionViewCell.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/6/22.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    @IBOutlet var exploreNameLabel: UILabel!
    @IBOutlet var exploreImageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func makeCell(meal: MealItem) {
        exploreNameLabel.text = meal.strMeal
    }
    
    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            exploreImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            exploreImageView.image = nil
        }
    }
    
}
