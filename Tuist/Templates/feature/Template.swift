import ProjectDescription
let nameAttribute: Template.Attribute = .required("name")

let testContents = """
import Foundation
import XCTest
import ComposableArchitecture
import ComposableTuistArchitectureSupport
@testable import \(nameAttribute)

final class \(nameAttribute)Tests: XCTestCase {
    func testExample() {
        // Add your test here
    }
}
"""

let template = Template(
    description: "Feature template",
    attributes: [
        nameAttribute,
        .optional("platform", default: "iOS")
    ],
    files: [
        .file(path: "\(nameAttribute)/Sources/\(nameAttribute).swift", templatePath: "view.stencil"),
        .file(path: "\(nameAttribute)/Sources/\(nameAttribute)Store.swift", templatePath: "store.stencil"),
//        .file(path: "\(nameAttribute)/Sources/\(nameAttribute)FeatureStore.swift", templatePath: "featureStore.stencil"),
        .string(path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift", contents: testContents),
        .file(path: "\(nameAttribute)/Project.swift", templatePath: "project.stencil"),
    ]
)
