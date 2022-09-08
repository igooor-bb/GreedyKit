# GreedyKit

GreedyKit is a set of ready-to-use components written in Swift for preventing sensitive media data to be exposed by screen capture tools in iOS.

- [GreedyKit](#greedykit)
  - [Motivation](#motivation)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
  - [Usage](#usage)
    - [UIKit](#uikit)
  - [Contribution](#contribution)
  - [License](#license)

## Motivation

I once had the task of preventing the capture of locally recorded video, however DRM did not work for me for this purpose because [FairPlay](https://developer.apple.com/streaming/fps/) only works with streaming remote content. Luckily for me, I found a suitable tool in AVFoundation, which I had to adapt to my needs and finally put into this little package.

## Requirements

- iOS/iPadOS 13.0 and later
- Xcode 11.0 and later

## Installation

### Swift Package Manager

One way to install GreedyKit is the Swift Package Manager (SPM). To do this, simply add a dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/igooor-bb/GreedyKit.git", from: "0.1.0")
]
```

## Usage

After you have installed the package, import it into the project in the usual way:

```swift
import GreedyKit
```

The package includes two separate but similar components for displaying images and videos that can change the capture prevention mode.

### UIKit

To add an **image** in UIKit that can be hidden, you have to use the `GreedyImageView` type:

```swift
// Create image view similar to the regular UIView.
let imageView = GreedyImageView()
parentView.addSubbiew(imageView)

// Add content to the created view.
// You can use either UIImage, CGImage or CIImage.
let image = UIImage(named: "SecretImage")
imageView.setImage(image)

// When necessary, turn on the flag to prevent the content from being captured.
imageView.preventsCapture = true
```

To add a **video** in UIKit that can be hidden, you have to use the `GreedyPlayerView` type. It is used as a wrapper around `AVPlayer`:

```swift
// Create a wrapper around AVPlayer
let player = AVPlayer()
let playerView = GreedyPlayerView()
playerView.player = player

// Add some content to the player and manipulate it as you wish:
let playerItem = AVPlayerItem(asset: localVideo)
player.replaceCurrentItem(with: playerItem)
player.play()

// When necessary, turn on the flag to prevent the content from being captured.
playerView.preventsCapture = true
```

You can find an example of how to use it in the [Examples/iOSGreedyKit](Examples/iOSGreedyKit/) project.

## Contribution

To contribute, use the follow "fork-and-pull" git workflow:

1. Fork the repository on github
2. Clone the project to your own machine
3. Commit changes to your own branch
4. Push your work back up to your fork
5. Submit a pull request so that I can review your changes

*NOTE: Be sure to merge the latest from "upstream" before making a pull request!*

## License

GreedyKit is available under the MIT license. See the LICENSE file for more info.
