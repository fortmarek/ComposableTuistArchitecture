import Foundation
import XCTest
import ComposableArchitecture
import ComposableTuistArchitectureSupport
@testable import AddRecipe

final class AddRecipeTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler
    
    func testHappyFlow() {
        let store = TestStore(
            initialState: AddRecipeState(),
            reducer: addRecipeReducer,
            environment: AddRecipeEnvironment(
                cookbookClient: .mock(),
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )
        
        store.assert(
            .send(.nameChanged("Name")) {
                $0.name = "Name"
            },
            .send(.currentIngredientChanged("Ingredient")) {
                $0.currentIngredient = "Ingredient"
            },
            .send(.addedIngredient) {
                $0.ingredients = ["Ingredient"]
                $0.currentIngredient = ""
            },
            .send(.addRecipe),
            .do { self.scheduler.advance() },
            .receive(.addedRecipe(.success(.mock(name: "Name", description: "Desc", ingredients: ["Ingredient"], duration: 10, info: "Info"))))
        )
    }
}
