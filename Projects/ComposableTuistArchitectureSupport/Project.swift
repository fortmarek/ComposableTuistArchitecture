import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "ComposableTuistArchitectureSupport",
    resources: [
        "Resources/**",
    ],
    actions: [
        .pre(
            path: "BuildPhases/swiftgen.sh",
            name: "Swiftgen"
        ),
    ],
    dependencies: [
        .package(product: "ComposableArchitecture"),
        .package(product: "CasePaths"),
    ]
)
