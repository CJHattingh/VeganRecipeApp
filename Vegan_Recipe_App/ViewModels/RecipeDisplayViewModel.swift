//
//  RecipeDisplayViewModel.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/23.
//

import Foundation
import UIKit
import Combine
import CoreData

protocol RecipeDisplayViewModel{
    var image: UIImage? {get}
    var title: String? {get}
    var recipeUrl: String? {get}
    func addFavouriteRecipe() throws -> CoreDataRecipe?
}

enum RecipesError: Error {
    case couldNotSet
    case couldNotDelete
}

final class ConcreteRecipeDisplayViewModel: RecipeDisplayViewModel {

    var response: Recipes?
    var error: Error?
    
    var image: UIImage?
    var title: String?
    var recipeUrl: String?
    var readyInMinutes: Int?
    var servings: Int?
    var id: Int?
    
    let can = Client()
    
    func generateRandomRecipe () {
        can.getRandomRecipe()
    }
    
    private var cancellableResponse: AnyCancellable?
    private var cancellableError: AnyCancellable?
    private var cancellableImage: AnyCancellable?
    func observeReload(completion: @escaping () -> Void) {
        cancellableResponse = can.updatedResponce.sink(receiveValue: { response in
            self.title = response?.recipes[0].title
            self.recipeUrl = response?.recipes[0].sourceUrl
            self.getImage(url: response?.recipes[0].image)
            self.id = response?.recipes[0].id
            self.servings = response?.recipes[0].servings
            self.readyInMinutes = response?.recipes[0].readyInMinutes
            
            completion()
        })
        cancellableError = can.updatedError.sink(receiveValue: {error in
            self.error = error
            completion()
        })
        cancellableImage = can.updatedImage.sink(receiveValue: {image in
            self.image = image
            completion()
        })
    }
    
    func getImage(url: String?) {
        if let url = url {
            if let imageUrl = URL(string: url) {
                can.getImage(url: imageUrl)
            } else {
                return
            }
        } else {
            return
        }
    }
    
    func addFavouriteRecipe() throws -> CoreDataRecipe?{
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "CoreDataRecipe", in: context)
        
        let managed = NSManagedObject(entity: entity!, insertInto: context)
        
        managed.setValue(self.title, forKey: "title")
        managed.setValue(Int64(self.id!), forKey: "id")
        managed.setValue(Int64(self.readyInMinutes!), forKey: "readyInMinutes")
        managed.setValue(self.recipeUrl, forKey: "sourceUrl")
        managed.setValue(self.image!.jpegData(compressionQuality: 1.0), forKey: "image")
        managed.setValue(Int32(self.servings!), forKey: "servings")

        do {
            try context.save()
            return managed as? CoreDataRecipe
        } catch {
            //error
            throw RecipesError.couldNotSet
        }
    }
    
    func setRecipe(recipe: CoreDataRecipe) {
        self.servings = Int(recipe.servings)
        self.id = Int(recipe.id)
        self.recipeUrl = recipe.sourceUrl
        self.readyInMinutes = Int(recipe.readyInMinutes)
        self.image = UIImage(data: recipe.image!)
        self.title = recipe.title
    }
    
    func deleteRecipe(recipe: CoreDataRecipe) throws{
        context.delete(recipe)
        do {
            try context.save()
        } catch {
            //error
            throw RecipesError.couldNotDelete
        }
    }
}
