import CasePaths
import Combine
import ComposableArchitecture
import ComposableTuistArchitectureSupport
import SwiftUI

public func makeRecipeDetailView(store: Store<RecipeDetailState, RecipeDetailAction>) -> some View {
    RecipeDetailView(store: store)
}

public struct RecipeDetailView: View {
    struct State: Equatable {
        let recipe: Recipe
        let selectedStars: Int
    }
    
    enum Action {
        case loadRecipe
        case starButtonTapped(Int)
    }
    
    let store: Store<RecipeDetailState, RecipeDetailAction>
    
    public init(store: Store<RecipeDetailState, RecipeDetailAction>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(
            self.store
                .scope(state: State.init, action: RecipeDetailAction.init)
        ) { viewStore in
            VStack(spacing: 10) {
                Text(viewStore.state.recipe.name)
                Text(viewStore.state.recipe.description)
                    .multilineTextAlignment(.center)
                HStack {
                    ForEach(1..<6) { tag in
                        Button(action: { viewStore.send(.starButtonTapped(tag)) }) {
                            Image(uiImage: tag <= viewStore.state.selectedStars ? Asset.icStar.image: Asset.icStarWhite.image)
                                .foregroundColor(.clear)
                        }
                    }
                }
                .padding()
                .background(Color.blue)
            }
            .onAppear { viewStore.send(.loadRecipe) }
        }
    }
}

extension RecipeDetailView.State {
    init(state: RecipeDetailState) {
        recipe = state.recipe
        selectedStars = state.currentRating
    }
}

extension RecipeDetailAction {
    init(action: RecipeDetailView.Action) {
        switch action {
        case .loadRecipe:
            self = .loadDetail
        case let .starButtonTapped(tag):
            self = .changedRating(tag)
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(
            store: Store(
                initialState: RecipeDetailState(
                    recipe: Recipe(id: "", name: "Recipe", description: "This is a very long description of recipe detail that spans multiple lines", ingredients: [], duration: 0, score: 0, info: ""),
                    currentRating: 3
                ),
                reducer: recipeDetailReducer,
                environment: RecipeDetailEnvironment(
                    cookbookClient: .mock(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
