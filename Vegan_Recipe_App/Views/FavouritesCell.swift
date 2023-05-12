//
//  FavouritesCell.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/30.
//

import UIKit

public class FavouriteCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    func setFavouriteCell(recipe :CoreDataRecipe) {
        recipeImageView.image = UIImage(data: (recipe.image)!)
        recipeTitleLabel.text = recipe.title
    }
    
}
