# GreedyKit

GreedyKit is a set of ready-to-use UIKit and SwiftUI components to prevent sensitive media data, such as images or videos, from being exposed by screen capture tools on iOS.

## Contents

- [Contents](#contents)
- [Motivation](#motivation)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
    - [Xcode](#xcode)
    - [Package manifest](#package-manifest)
- [Usage](#usage)
  - [Image](#image)
  - [Video](#video)
- [Contribution](#contribution)
- [License](#license)

## Motivation

While building a video player for one of the enterprise projects, I needed a way to prevent users from taking screenshots or recording what was on the screen. [Apple’s FairPlay DRM](https://developer.apple.com/streaming/fps/) secures streamed media only, so I turned to [AVSampleBufferDisplayLayer](https://developer.apple.com/documentation/avfoundation/avsamplebufferdisplaylayer), which natively supports what I needed.

GreedyKit packages this technique, allowing you to protect media with a single property toggle without DRM servers or certificates.

## Requirements

- iOS/iPadOS 13.0 and later
- Xcode 16.0 and later

## Installation

### Swift Package Manager

#### Xcode

You can use Swift Package Manager to install GreedyKit using Xcode:

1. Open your project in Xcode
2. Open "File" -> "Add Packages..."
3. Paste the repository URL: <https://github.com/igooor-bb/GreedyKit>
4. Click "Next" a couple of times and finish the process

#### Package manifest

Alternatively, add the dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/igooor-bb/GreedyKit", from: "<version>")
```

## Usage

After you have installed the package, import it into the project in the usual way:

```swift
import GreedyKit
```

The package includes components for displaying images and videos that can change the capture mode on demand.

You can find an example of how to use them in [Examples/GreedyKitExample](Examples/GreedyKitExample/).

### Image

In UIKit, you can use the `GreedyImageView` wrapper around your `UIImage` similar to regular `UIImageView`:

```swift
let imageView = GreedyImageView()
imageView.image = UIImage(named: "SecretImage")

// Block capture at any time:
imageView.preventsCapture = true
```

In SwiftUI, you can simply use `GreedyImage` compononent with your `UIImage` inside:

```swift
VStack {
    GreedyImage(uiImage, preventsCapture: true)
}
```

### Video

In UIKit, you can use the `GreedyPlayerView` wrapper around your `AVPlayer`:

```swift
let player = AVPlayer(url: videoURL)
let playerView = GreedyPlayerView()
playerView.player = player

// Start playback:
player.play()

// Block capture at any time:
playerView.preventsCapture = true
```

In SwiftUI, you just need to create a `GreedyPlayer` within your view hierarchy and pass an `AVPlayer`, whose content it will draw:

```swift
VStack {
    GreedyPlayer(player: avPlayer, preventsCapture: true)
}
```

## Contribution

To contribute, use the follow "fork-and-pull" git workflow:

1. Fork the repository on github
2. Clone the project to your own machine
3. Commit changes to your own branch
4. Push your work back up to your fork
5. Submit a pull request so that I can review your changes

*NOTE: Be sure to merge the latest from "upstream" before making a pull request!*

## License

**GreedyKit** is available under the MIT license. See the LICENSE file for more info.
