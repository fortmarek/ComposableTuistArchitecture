import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI
import TuistComposableArchitectureSupport

public struct RecipeListState {
    var recipes: [Recipe] = []
    var isLoadingRecipes: Bool = false
}

public enum RecipeListAction: Equatable {
    case recipes
    case recipesResponse(Result<[Recipe], CookbookClient.Failure>)
}

public struct RecipeListEnvironment {
    let cookbookClient: CookbookClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let recipeListReducer = Reducer<RecipeListState, RecipeListAction, RecipeListEnvironment> { state, action, environment in
    switch action {
    case .recipes:
        state.isLoadingRecipes = true
        
        return environment.cookbookClient
            .recipes()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(RecipeListAction.recipesResponse)
    case let .recipesResponse(.success(recipes)):
        state.recipes = recipes
        state.isLoadingRecipes = false
        
        return .none
    case let .recipesResponse(.failure(error)):
        // TODO: Handle error
        state.isLoadingRecipes = false
        
        return .none
    }
}

public struct RecipeListView: View {
    struct State: Equatable {
        var recipes: [Recipe]
        var isActivityIndicatorHidden: Bool
    }
    
    enum Action {
        case recipes
    }
    
    let store: Store<RecipeListState, RecipeListAction>
    
    public var body: some View {
        WithViewStore(
            self.store.scope(state: State.init, action: RecipeListAction.init)
        ) { viewStore in
            List {
                ForEach(viewStore.recipes) { recipe in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.name)
                        Text("Duration: " + String(recipe.duration))
                    }
                }
            }.onAppear(perform: { viewStore.send(.recipes) })
            
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
                    isLoadingRecipes: true
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
