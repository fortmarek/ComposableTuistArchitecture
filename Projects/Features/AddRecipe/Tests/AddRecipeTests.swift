import Foundation
import XCTest
import ComposableArchitecture
import ComposableTuistArchitectureSupport
@testable import AddRecipe

final class AddRecipeTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler
    
    func testAddRecipe() {
        let store: TestStore<AddRecipeState, AddRecipeState, AddRecipeAction, AddRecipeAction, AddRecipeEnvironment> = TestStore(
            initialState: AddRecipeState(
                isShowingAddRecipe: true
            ),
            reducer: addRecipeReducer,
            environment: AddRecipeEnvironment(
                cookbookClient: .mock(
                    
                ),
                mainQueue: AnyScheduler(scheduler)
            )
        )
        
        store.assert(
            .send(.nameChanged("Recipe")) {
                $0.name = "Recipe"
            },
            .send(.currentIngredientChanged("Ingredient")) {
                $0.currentIngredient = "Ingredient"
            },
            .send(.addIngredient) {
                $0.currentIngredient = ""
                $0.ingredients = ["Ingredient"]
            },
            .send(.addRecipe),
            .do { self.scheduler.advance() },
            .receive(
                .addedRecipe(
                    .success(
                        .mock(name: "Recipe", description: "Desc", ingredients: ["Ingredient"], duration: 10, info: "Info")
                    )
                )
            ) {
                $0.recipes.append(.mock(name: "Recipe", description: "Desc", ingredients: ["Ingredient"], duration: 10, info: "Info"))
                $0.isShowingAddRecipe = false
            }
        )
    }
}
