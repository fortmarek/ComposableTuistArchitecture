import ComposableArchitecture
import ComposableTuistArchitectureSupport

public struct AddRecipeState: Equatable {
    public init(
        name: String = "",
        ingredients: [String] = [],
        currentIngredient: String = ""
    ) {
        self.name = name
        self.ingredients = ingredients
        self.currentIngredient = ""
    }
    
    var name: String
    var ingredients: [String]
    var currentIngredient: String
}

public enum AddRecipeAction: Equatable {
    case currentIngredientChanged(String)
    case addedIngredient
    case nameChanged(String)
    case addRecipe
    case addedRecipe(Result<Recipe, CookbookClient.Failure>)
}

public struct AddRecipeEnvironment {
    public init(
        cookbookClient: CookbookClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.cookbookClient = cookbookClient
        self.mainQueue = mainQueue
    }
    
    let cookbookClient: CookbookClient
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

public let addRecipeReducer = Reducer<AddRecipeState, AddRecipeAction, AddRecipeEnvironment> { state, action, environment in
    switch action {
    case let .nameChanged(name):
        state.name = name
        return .none
    case let .currentIngredientChanged(ingredient):
        state.currentIngredient = ingredient
        return .none
    case .addedIngredient:
        state.ingredients.append(state.currentIngredient)
        state.currentIngredient = ""
        return .none
    case .addRecipe:
        let recipe = Recipe(id: "", name: state.name, description: "Desc", ingredients: state.ingredients, duration: 10, score: 0, info: "Info")
        return environment.cookbookClient
            .addRecipe(recipe)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AddRecipeAction.addedRecipe)
    case let .addedRecipe(.success(recipe)):
        return .none
    case .addedRecipe(.failure):
        // TODO: handle error
        return .none
    }
}
