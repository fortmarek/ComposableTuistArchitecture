import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: "TuistComposableArchitectureKit", platform: .iOS, dependencies: [
    .project(target: "TuistComposableArchitectureSupport", path: .relativeToManifest("../TuistComposableArchitectureSupport"))
])
