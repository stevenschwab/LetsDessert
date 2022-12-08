//
//  ExploreViewController.swift
//  Let's Dessert
//
//  Created by Steven Schwab on 12/6/22.
//

import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet var dessertMealListCollectionView: UICollectionView!
    
    var exploreManager = ExploreDataManager()
    var imageStore: ImageStore!
    var headerView: ExploreHeaderView!
    var meals = [MealItem]() {
        didSet {
            dessertMealListCollectionView.reloadData()
        }
    }
    var selectedMeal: MealItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.showDetail.rawValue:
            showMealDetail(segue: segue)
        default:
            print("Segue not added")
        }
    }

}

//MARK: - Private Extension

private extension ExploreViewController {
    
    func initialize() {
        exploreManager.delegate = self
        exploreManager.fetchListOfMeals()
    }
    
    func showMealDetail(segue: UIStoryboardSegue) {
        if let viewController = segue.destination as? MealDetailViewController, let meal = selectedMeal {
            viewController.selectedMeal = meal
            viewController.imageStore = imageStore
        }
    }
    
}

//MARK: - Collection View DataSource

extension ExploreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        headerView = header as? ExploreHeaderView
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dessertMealListCollectionView.dequeueReusableCell(withReuseIdentifier: "mealCell", for: indexPath) as! ExploreCell
        
        let exploreItem = meals[indexPath.row]
        
        cell.update(displaying: nil)
        
        cell.makeCell(meal: exploreItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let meal = meals[indexPath.row]
        
        imageStore.fetchImage(for: meal) { (result) -> Void in
            
            guard let mealIndex = self.meals.firstIndex(of: meal), case let .success(image) = result else { return }
            
            let mealIndexPath = IndexPath(item: mealIndex, section: 0)
            
            if let cell = collectionView.cellForItem(at: mealIndexPath) as? ExploreCell {
                cell.update(displaying: image)
            }
        }
    }
    
}

//MARK: - Collection View Delegate

extension ExploreViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMeal = meals[indexPath.row]
        
        performSegue(withIdentifier: Segue.showDetail.rawValue, sender: self)
    }
}

extension ExploreViewController: ExploreDataManagerDelegate {
    
    func didUpdateMeals(_ exploreManager: ExploreDataManager, meals: [MealItem]) {
        DispatchQueue.main.async {
            self.meals = meals
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
