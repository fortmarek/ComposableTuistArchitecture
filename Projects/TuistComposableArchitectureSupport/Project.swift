import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "TuistComposableArchitectureSupport",
    dependencies: [
        .package(product: "ComposableArchitecture"),
        .package(product: "CasePaths"),
    ]
)
