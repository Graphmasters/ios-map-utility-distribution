# GMMapUtility

![Requires Xcode 14](https://img.shields.io/badge/Xcode-14-1575F9.svg?style=flat&logo=xcode&logoColor=1575F9)
[![Requires Swift 5.7](https://img.shields.io/badge/Swift-5.7-FA7343.svg?style=flat&logo=Swift)](https://swift.org/package-manager/)
[![SPM compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-FA7343.svg?style=flat&logo=Swift)](https://swiftpackageindex.com/maplibre/maplibre-gl-native-distribution)

> **Note**  
> This repository only exists for the purpose of distribution of GMMapUtility for iOS on the Swift Package Manager. It's main purpose is to be used in public SDKs of Graphmasters GmbH.
> Please contact Grapmasters GmbH directly if you have any issues.

[GMMapUtility](https://github.com/graphmasters/ios-map-utility-distribution) contains all utility classes for managing the life cycle of [MapLibre Native](https://github.com/maplibre/maplibre-native) map views and style layers.

---

## Getting Started

GMMapUtility for iOS is distributed using the [Swift Package Manager](https://www.swift.org/package-manager/). To add it to your project, follow the steps below.

### Package.swift

1. Add the following to your dependencies.

```
dependencies: [
    .package(url: "https://github.com/graphmasters/ios-map-utility-distribution", from: "<VERSION>")
]
```

2. Add the dependency to your target.

```
.target(
    name: "Mytarget",
    dependencies: [
        .product(name: "GMMapUtility", package: "ios-map-utility")
    ]
)
```

### Xcode

1. To add a package dependency to your Xcode project, select File > Swift Packages > Add Package Dependency and enter its repository URL. You can also navigate to your target’s General pane, and in the “Frameworks, Libraries, and Embedded Content” section, click the + button, select Add Other, and choose Add Package Dependency.

2. Either add GMMapUtility GitHub distribution URL `https://github.com/graphmasters/ios-map-utility-distribution` or search for `ios-map-utility` package.

3. Choose "Next". Xcode should clone the distribution repository and download the binaries.
