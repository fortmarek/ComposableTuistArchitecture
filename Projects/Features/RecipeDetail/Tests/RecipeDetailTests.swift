import Foundation
import XCTest
import ComposableArchitecture
import ComposableTuistArchitectureSupport
@testable import RecipeDetail

final class RecipeDetailTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler
    
    func testHappyFlow() {
        let recipe: Recipe = .mock()
        let store = setupStore(recipe: recipe)
        store.assert(
            .send(.changedRating(2)) {
                $0.currentRating = 2
            },
            .send(.loadDetail) {
                $0.hasLoadedDetail = true
            },
            .do { self.scheduler.advance() },
            .receive(.recipeDetail(.success(recipe))),
            .send(.changedRating(5)) {
                $0.currentRating = 5
            }
        )
    }
    
    // MARK: - Helpers
    
    private func setupStore(
        recipe: Recipe = .mock()
    ) -> TestStore<RecipeDetailState, RecipeDetailState, RecipeDetailAction, RecipeDetailAction, RecipeDetailEnvironment> {
        TestStore(
            initialState: RecipeDetailState(
                recipe: recipe
            ),
            reducer: recipeDetailReducer,
            environment: RecipeDetailEnvironment(
                cookbookClient: .mock(),
                mainQueue: AnyScheduler(self.scheduler)
            )
        )
    }
}
