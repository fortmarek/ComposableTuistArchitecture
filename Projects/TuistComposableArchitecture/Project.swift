import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "TuistComposableArchitecture", platform: .iOS, dependencies: [
    .project(target: "TuistComposableArchitectureKit", path: .relativeToManifest("../TuistComposableArchitectureKit"))
])
