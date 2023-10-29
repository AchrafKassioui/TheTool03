# TheTool03

Experimental iOS app to explore and learn Swift, SwiftUI, SpriteKit, UIKit, and touch interactions.

## Screenshot

<img width="337" alt="Screenshot of an iPhone 13 with multiple red squares on a gray background" src="https://github.com/AchrafKassioui/TheTool03/assets/1216689/993f42d5-f7d4-4d0b-b0d0-49b3b36649e6">

## Installation

- Download, clone, or open the repository with Xcode.
- To run a preview, navigate to `ContentView.swift`. The live preview should automatically start on the Canvas.
- To run the app, update the project's "Signing & Capabilities", and build for your target.

## Features

- The app renders an empty 2D scene with a gray background, and a round "+" button in the bottom right corner.
- Drag the "+" button anywhere on the screen to spawn a rotating red square.
- Pinch to zoom the camera in and out. There is maximum and minimum zoom level.
- Double tap the scene to reset the camera zoom.

## Further exploration

- Spawn the square at the release position of the "+" button, regardless of zoom level.
- Move a red square by dragging it. Change the "+" button to a "-" button while the drag is active.
- Remove a red square if it is dragged on the "-" button.
