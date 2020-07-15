import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI
import ComposableTuistArchitectureSupport
import AddRecipe

public func makeRecipeListView(store: Store<RecipeListFeatureState, RecipeListFeatureAction>) -> some View {
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

    let store: Store<RecipeListFeatureState, RecipeListFeatureAction>
    
    var body: some View {
        WithViewStore(
            self.store
                .scope(state: RecipeListState.init, action: RecipeListFeatureAction.recipeList)
                .scope(state: State.init, action: RecipeListAction.init)
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
                        destination: makeAddRecipeView(store: self.store.scope(state: { $0.addRecipe }, action: RecipeListFeatureAction.addRecipe))
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
    init(recipeListState: RecipeListState) {
        recipes = recipeListState.recipes
        isActivityIndicatorHidden = recipeListState.isLoadingRecipes
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
            store: Store<RecipeListFeatureState, RecipeListFeatureAction>(
                initialState: RecipeListFeatureState(
                    recipeList: RecipeListState(
                        recipes: [
                            Recipe(id: "a", name: "Spaghetti", duration: 20, score: 2)
                        ],
                        isLoadingRecipes: false
                    ),
                    addRecipe: AddRecipeState(
                        name: ""
                    )
                ),
                reducer: recipeListFeatureReducer,
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
