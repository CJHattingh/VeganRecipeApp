//
//  RecipeModel.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/23.
//

import Foundation

struct RandomRecipe: Codable {
    let id: Int
    let title: String
    let image: String
    let servings: String
    let sourceUrl: String
}
