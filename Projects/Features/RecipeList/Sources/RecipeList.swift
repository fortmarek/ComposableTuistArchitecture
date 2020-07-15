import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI
import ComposableTuistArchitectureSupport

public func makeRecipeListView(store: Store<RecipeListState, RecipeListAction>) -> some View {
    RecipeListView(store: store)
}

struct RecipeListView: View {
    struct State: Equatable {
        var recipes: [Recipe]
        var isActivityIndicatorHidden: Bool
    }
    
    enum Action {
        case recipes
    }
    
    let store: Store<RecipeListState, RecipeListAction>
    
    var body: some View {
        WithViewStore(
            self.store.scope(state: State.init, action: RecipeListAction.init)
        ) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.recipes) { recipe in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.name)
                            Text("Duration: " + String(recipe.duration))
                        }
                    }
                }
                .onAppear(perform: { viewStore.send(.recipes) })
                .navigationBarTitle("Recipes")
                .navigationBarItems(
                    trailing: NavigationLink(
                        destination: Text("olla")
                    ) {
                        Image(uiImage: Asset.icAdd.image)
                    }
                )
            }
            if viewStore.isActivityIndicatorHidden {
                ActivityIndicator()
            }
        }
    }
}

extension RecipeListView.State {
    init(recipelistState: RecipeListState) {
        recipes = recipelistState.recipes
        isActivityIndicatorHidden = recipelistState.isLoadingRecipes
    }
}

extension RecipeListAction {
    init(action: RecipeListView.Action) {
        switch action {
        case .recipes:
            self = .recipes
        }
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(
            store: Store(
                initialState: RecipeListState(
                    recipes: [
                        Recipe(id: "a", name: "Spaghetti", duration: 20, score: 2)
                    ],
                    isLoadingRecipes: false
                ),
                reducer: recipeListReducer,
                environment: RecipeListEnvironment(
                    cookbookClient: .mock(
                        recipes: {
                            Effect(
                                value: [
                                    Recipe(id: "a", name: "Spaghetti", duration: 20, score: 2)
                                ]
                            )
                    }
                    ),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
