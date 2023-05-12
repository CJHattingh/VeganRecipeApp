//
//  FavouritesViewModel.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/23.
//


import Foundation
import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

protocol FavouritesViewModel {
    func getAllRecipes() throws -> [CoreDataRecipe]?
}

final class concreteFavouritesViewModel: FavouritesViewModel {
    
    enum FavouritesError: Error {
        case couldNotLoad
        case couldNotDelete
    }
    
    func getAllRecipes() throws -> [CoreDataRecipe]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CoreDataRecipe")

        do {
            let recipes = try context.fetch(fetchRequest)
            return recipes as! [CoreDataRecipe]?
        } catch {
            //error
            print("Could not load recipes from CoreData")
            throw FavouritesError.couldNotLoad
        }
    }

    func deleteRecipe(recipe: CoreDataRecipe) throws{
        context.delete(recipe)
        
        do {
            try context.save()
        } catch {
            //error
            print("Could not delete recipe from CoreData")
            throw FavouritesError.couldNotDelete
        }
    }
}

