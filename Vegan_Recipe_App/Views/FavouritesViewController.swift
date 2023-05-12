//
//  FavouritesViewController.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/23.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let favouritesViewModel: concreteFavouritesViewModel = concreteFavouritesViewModel()
    var allRecipes: [CoreDataRecipe]? = nil
    var favouriteRecipe: CoreDataRecipe? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        do {
            allRecipes = try favouritesViewModel.getAllRecipes()
        } catch let localError {
            showFailure(title: "Could not load recipes", message: localError.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecipes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        let recipe = allRecipes![(indexPath as NSIndexPath).row]
        cell.setFavouriteCell(recipe: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = allRecipes![indexPath.row]
            tableView.beginUpdates()
            do {
                try favouritesViewModel.deleteRecipe(recipe: recipe)
            } catch let localError {
                showFailure(title: "Could not delete recipes", message: localError.localizedDescription)
            }
            allRecipes?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favouriteRecipe = (allRecipes?[indexPath.row])
        performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            allRecipes = try favouritesViewModel.getAllRecipes()
        } catch let localError {
            showFailure(title: "Could not load recipes", message: localError.localizedDescription)
        }
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailView") {
            let destinationVC = segue.destination as? RecipeDetailViewController
            destinationVC?.segueFromFarvourites = true
            destinationVC?.favouriteRecipe = favouriteRecipe
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
