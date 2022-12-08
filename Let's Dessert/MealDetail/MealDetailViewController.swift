//
//  MealDetailViewController.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/6/22.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    // Cell One
    @IBOutlet var mealImageView: UIImageView!
    // Cell Two
    @IBOutlet var mealAreaLabel: UILabel!
    // Cell Three
    @IBOutlet var mealIngredientsTableView: UITableView!
    @IBOutlet var tableheight: NSLayoutConstraint!
    // Cell Four
    @IBOutlet var mealInstructionsLabel: UILabel!
    // Cell Five
    @IBOutlet var mealTagsLabel: UILabel!
    // Cell Six
    @IBOutlet var mealSourceLabel: UILabel!
    
    var mealDetailManager = MealDetailDataManager()
    var imageStore: ImageStore!
    var selectedMeal: MealItem?
    var mealDetail: MealDetailModel? {
        didSet {
            setupLabels()
            mealIngredientsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // Resizing table view of ingredients
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableheight?.constant = self.mealIngredientsTableView.contentSize.height
    }

}

private extension MealDetailViewController {
    
    func initialize() {
        mealDetailManager.delegate = self
        fetchMealDetail()
    }
    
    func fetchMealDetail() {
        guard let meal = selectedMeal else { return }
        
        mealDetailManager.fetchMealDetail(meal: meal)
    }
    
    func setupLabels() {
        guard let meal = mealDetail, let selectedMeal = selectedMeal else { return }
        
        title = meal.strMeal ?? "Meal name not available"
        imageStore.fetchImage(for: selectedMeal) { (result) -> Void in
            
            guard case let .success(image) = result else { return }
            
            self.mealImageView.image = image
        }
        mealAreaLabel.text = "Cuisine: \(meal.strArea ?? "Meal area not available")"
        mealInstructionsLabel.text = "Instructions: \(meal.strInstructions ?? "Meal instructions not available")"
        mealTagsLabel.text = "Tags: \(meal.strTags ?? "Meal tags not available")"
        mealSourceLabel.text = "Source: \(meal.strSource ?? "Meal source not available")"
    }
}

extension MealDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let numberOfIngredients = mealDetail?.ingredients.count else {
            return 1
        }

        return numberOfIngredients
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealIngredient", for: indexPath) as! MealIngredientCell
        
        if let ingredients = mealDetail?.ingredients {
            let ingredientObject = ingredients[indexPath.row]
            
            cell.makeCell(ingredients: ingredientObject)
        } else {
            cell.measurementLabel.text = "Missing ingredients"
            cell.ingredientLabel.text = nil
        }
        
        return cell
    }
}

extension MealDetailViewController: MealDetailDataManagerDelegate {
    
    func didUpdateMeals(_ mealDetailManager: MealDetailDataManager, mealDetail: MealDetailModel) {
        DispatchQueue.main.async {
            self.mealDetail = mealDetail
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
