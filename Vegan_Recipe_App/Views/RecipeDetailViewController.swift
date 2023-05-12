//
//  RecipeDetailViewController.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/23.
//

import UIKit
import Combine

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTileLabel: UILabel!
    @IBOutlet weak var recipeUrlLablel: UILabel!
    @IBOutlet weak var recipeMinutes: UILabel!
    @IBOutlet weak var recipeServings: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var addedToFavourites: Bool = false
    var segueFromFarvourites: Bool = false
    var favouriteRecipe: CoreDataRecipe? = nil
    var viewModel: ConcreteRecipeDisplayViewModel = ConcreteRecipeDisplayViewModel()
    
    let buttonImageNotFavourite = UIImage(named: "heart_empty")?.withRenderingMode(.alwaysTemplate)
    let buttonImageFavourite = UIImage(named: "heart_full")
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        if segueFromFarvourites {
            if !addedToFavourites {
                do {
                    try viewModel.deleteRecipe(recipe: favouriteRecipe!)
                } catch let localError {
                    showFailure(title: "Could not delete recipes", message: localError.localizedDescription)
                }
                favouriteButton.setImage(buttonImageNotFavourite, for: .normal)
                favouriteButton.tintColor = .white
                segueFromFarvourites = false
                addedToFavourites = false
            } else {
                do {
                    try viewModel.deleteRecipe(recipe: favouriteRecipe!)
                } catch let localError {
                    showFailure(title: "Could not delete recipes", message: localError.localizedDescription)
                }
                favouriteButton.setImage(buttonImageNotFavourite, for: .normal)
                favouriteButton.tintColor = .white
                segueFromFarvourites = false
                addedToFavourites = false
            }
        } else {
            do {
                favouriteRecipe = try viewModel.addFavouriteRecipe()
            } catch let localError {
                showFailure(title: "Could not add recipe", message: localError.localizedDescription)
            }
            favouriteButton.setImage(buttonImageFavourite, for: .normal)
            segueFromFarvourites = true
            addedToFavourites = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        recipeImageView.layer.cornerRadius = 8.0
        favouriteButton.imageView?.contentMode = .scaleAspectFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        recipeUrlLablel.isUserInteractionEnabled = false
        recipeUrlLablel.addGestureRecognizer(tap)
        
        if segueFromFarvourites {
            self.recipeImageView.image = UIImage(data: (favouriteRecipe?.image!)!)
            self.recipeTileLabel.text = favouriteRecipe?.title
            self.recipeMinutes.text = String((favouriteRecipe?.readyInMinutes)!) + " mins"
            self.recipeServings.text = "Servings: " + String((favouriteRecipe?.servings)!)
            viewModel.setRecipe(recipe: favouriteRecipe!)
            favouriteButton.setImage(buttonImageFavourite, for: .normal)
            activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else {
            viewModel.observeReload() {
                self.updateUI()
            }
            viewModel.generateRandomRecipe()
            recipeImageView.image = UIImage(named: "restaurant3")
            favouriteButton.setImage(buttonImageNotFavourite, for: .normal)
            favouriteButton.tintColor = .white
        }
    }
    
    func updateUI() {
        if viewModel.error  != nil {
            activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            showFailure(title: "Could not load a recipe", message: "An error occured while loading a recipe, please try again")
            
        } else {
            if (viewModel.image != nil) {
                self.recipeImageView.image = viewModel.image
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            } else {
                self.recipeImageView.image = UIImage(named: "restaurant3")
            }
            self.recipeTileLabel.text = viewModel.title
            self.recipeMinutes.text = String(viewModel.readyInMinutes ?? 0) + " mins"
            self.recipeServings.text = "Servings: " + String((viewModel.servings ?? 0))
            if viewModel.recipeUrl != nil {
                recipeUrlLablel.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if segueFromFarvourites {
            if let url = URL(string: (favouriteRecipe?.sourceUrl)!) {
                UIApplication.shared.open(url)
            }
        } else {
            if let url = URL(string: (viewModel.recipeUrl)!) {
                UIApplication.shared.open(url)
            }
        }
    }
}
