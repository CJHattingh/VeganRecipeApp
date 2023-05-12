#  Vegan Recipe App

The goal of this app is to display random vegan recipes to the user. The can then
choose to save it in their favourites list or generate a new recipe.

Upon launching the app the user will be on the "Search" tab and can tap on the 
"Find new recipe" button to generate a new recipe. they will then be navigated to 
a detail view of the recipe.

For the recipe detail view an image of the dish, the name, the amount of servings,
the preperation time and a link to the recipe websire will be displayed. When the
user taps on the link it will be opened in a web breakout. There is also a heart 
button that the user can use to save the recipe to their faourites. This button 
will be red for any recipe that is saved and will have a white outline when the 
recipe is not added to their favourites.

When the user taps on the star in the tab bar, they will be taken to a screen with 
a list view that will show them all their favourite recipes. This list is persisted 
in CoreData. From here they can delete a recipe by swiping left, or they can view 
the recipe detail by tapping on a cell.

The project was written in Xcode 13.4.1
The app can be run on any of the iOS simulators up to iOS 16, no prior set up is required.

The API that was used is: https://spoonacular.com
