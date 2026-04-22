// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "native_file_preview",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(name: "native-file-preview", targets: ["native_file_preview"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "native_file_preview",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ],
      resources: [
        // If you want to bundle the privacy manifest, uncomment the line below
        // and the matching `s.resource_bundles` entry in the podspec.
        // .process("PrivacyInfo.xcprivacy"),
      ]
    )
  ]
)
