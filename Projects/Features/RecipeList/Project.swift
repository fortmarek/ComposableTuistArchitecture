import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.feature(
    name: "RecipeList",
    dependencies: [
        .project(
            target: "AddRecipe",
            path: .relativeToRoot("Projects/Features/AddRecipe")
        ),
        .project(
            target: "RecipeDetail",
            path: .relativeToRoot("Projects/Features/RecipeDetail")
        ),
    ]
)
