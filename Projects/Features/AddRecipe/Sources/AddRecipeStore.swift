import ComposableArchitecture
import ComposableTuistArchitectureSupport

public typealias AddRecipeScreenState = (
    name: String,
    currentIngredient: String,
    ingredients: [String]
)

public struct AddRecipeState: Equatable {
    public var name: String = ""
    public var currentIngredient: String = ""
    public var ingredients: [String] = []
    public var isShowingAddRecipe: Bool = false
    
    public init(
        isShowingAddRecipe: Bool = false,
        addRecipeScreenState: AddRecipeScreenState = ("", "", [])
    ) {
        name = addRecipeScreenState.name
        currentIngredient = addRecipeScreenState.currentIngredient
        ingredients = addRecipeScreenState.ingredients
        self.isShowingAddRecipe = isShowingAddRecipe
    }
}

public enum AddRecipeAction: Equatable {
    case nameChanged(String)
    case currentIngredientChanged(String)
    case addIngredient
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
    case let .currentIngredientChanged(currentIngredient):
        state.currentIngredient = currentIngredient
        return .none
    case .addIngredient:
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
    case .addedRecipe(.failure):
        // TODO: Handle error
        return .none
    case let .addedRecipe(.success(recipe)):
        state.isShowingAddRecipe = false
        return .none
    }
}

//extension AddRecipeFeatureAction {
//    init(_ addRecipeAction: AddRecipeAction) {
//        switch addRecipeAction {
//        case .addIngredient:
//            self = .addRecipe(.addIngredient)
//        case .addRecipe:
//            self = .addRecipe(.addRecipe)
//        case let .nameChanged(name):
//            self = .addRecipe(.nameChanged(name))
//        case let .currentIngredientChanged(ingredient):
//            self = .addRecipe(.currentIngredientChanged(ingredient))
//        case let .addedRecipe(recipe):
//            self = .addRecipe(.addedRecipe(recipe))
//        }
//    }
//}
