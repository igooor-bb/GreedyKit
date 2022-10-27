# GreedyKit

GreedyKit is a set of ready-to-use components written in Swift for preventing sensitive media data to be exposed by screen capture tools in iOS.

## Contents

- [GreedyKit](#greedykit)
  - [Contents](#contents)
  - [Motivation](#motivation)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
  - [Usage](#usage)
    - [UIKit](#uikit)
      - [GreedyImageView](#greedyimageview)
      - [GreedyPlayerView](#greedyplayerview)
    - [SwiftUI](#swiftui)
      - [GreedyImage](#greedyimage)
      - [GreedyPlayer](#greedyplayer)
  - [Contribution](#contribution)
  - [License](#license)

## Motivation

I once had the task of preventing the capture of locally recorded video, however DRM did not work for me for this purpose because [FairPlay](https://developer.apple.com/streaming/fps/) only works with streaming remote content. Luckily for me, I found a [suitable tool in AVFoundation](https://developer.apple.com/documentation/avfoundation/avsamplebufferdisplaylayer), which I had to adapt to my needs and finally put into this little package.

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

Alternatively, you can use Swift Package Manager to install GreedyKit using Xcode:

1. Open your project in Xcode
2. Open "File" -> "Add Packages..."
3. Paste the repository URL: <https://github.com/igooor-bb/GreedyKit>
4. Click "Next" a couple of times and finish adding

## Usage

After you have installed the package, import it into the project in the usual way:

```swift
import GreedyKit
```

The package includes two separate but similar components for displaying **images** and **videos** that can change the capture prevention mode on demand.

### UIKit

#### GreedyImageView

To add an image in UIKit that can be hidden, you have to use the `GreedyImageView` wrapper around your image:

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

#### GreedyPlayerView

To add a video in UIKit that can be hidden, you can use the `GreedyPlayerView` wrapper around your `AVPlayer`:

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

### SwiftUI

GreedyKit also contains several wrappers around UIKit classes that you can use in SwiftUI.

#### GreedyImage

The image is very simple. You just need to create a `GreedyImage` element with any kind of image (UIImage, CIImage or CGImage) within your view hierarchy:

```swift
VStack {
  GreedyImage(uiImage, preventsCapture: true)
}
```

#### GreedyPlayer

Creating a video player is also easy. You just need to create a `GreedyPlayer` element within your view hierarchy and pass an `AVPlayer` to it, whose content it will draw:

```swift
VStack {
  GreedyPlayer(player: avPlayer, preventsCapture: true)
}
```

You can find an example of how to use it in the [Examples/SwiftUIGreedyKit](Examples/SwiftUIGreedyKit/) project.

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
