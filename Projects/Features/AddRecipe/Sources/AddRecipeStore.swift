import ComposableArchitecture
import ComposableTuistArchitectureSupport

typealias AddRecipeState = (
    name: String,
    currentIngredient: String,
    ingredients: [String],
    recipes: [Recipe],
    isShowingAddRecipe: Bool
)

public enum AddRecipeAction: Equatable {
    case nameChanged(String)
    case currentIngredientChanged(String)
    case addIngredient
    case addRecipe
    case addedRecipe(Result<Recipe, CookbookClient.Failure>)
}

struct AddRecipeEnvironment {
    let cookbookClient: CookbookClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let addRecipeReducer = Reducer<AddRecipeState, AddRecipeAction, AddRecipeEnvironment> { state, action, environment in
    switch action {
    case let .nameChanged(name):
        state.name = name
        return .none
    case let .currentIngredientChanged(currentIngredient):
        state.currentIngredient = currentIngredient
        return .none
    case .addIngredient:
        state.ingredients.append(state.currentIngredient)
        state.currentIngredient = ""
        return .none
    case .addRecipe:
        let recipe = Recipe(id: "", name: state.name, description: "Desc", ingredients: state.ingredients, duration: 10, score: 0, info: "Ola")
        return environment.cookbookClient
            .addRecipe(recipe)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AddRecipeAction.addedRecipe)
    case .addedRecipe(.failure):
        // TODO: Handle error
        return .none
    case let .addedRecipe(.success(recipe)):
        state.recipes.append(recipe)
        state.isShowingAddRecipe = false
        return .none
    }
}

extension AddRecipeFeatureAction {
    init(_ addRecipeAction: AddRecipeAction) {
        switch addRecipeAction {
        case .addIngredient:
            self = .addRecipe(.addIngredient)
        case .addRecipe:
            self = .addRecipe(.addRecipe)
        case let .nameChanged(name):
            self = .addRecipe(.nameChanged(name))
        case let .currentIngredientChanged(ingredient):
            self = .addRecipe(.currentIngredientChanged(ingredient))
        case let .addedRecipe(recipe):
            self = .addRecipe(.addedRecipe(recipe))
        }
    }
}
