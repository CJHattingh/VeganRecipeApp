//
//  RecipeResponse.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/16.
//

import Foundation

struct Recipes: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let servings: Int
    let readyInMinutes: Int
    let sourceUrl: String
}
