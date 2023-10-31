import Foundation
import SpriteKit

extension Composition {
    func createBackgroundFromImage() {
        let gridPatternTexture = SKTexture(imageNamed: "gridPattern")
        let xRepeats = Int(size.width / gridPatternTexture.size().width)
        let yRepeats = Int(size.height / gridPatternTexture.size().height)
        for i in -xRepeats/2..<xRepeats/2 {
            for j in -yRepeats/2..<yRepeats/2 {
                let backgroundPattern = SKSpriteNode(texture: gridPatternTexture)
                backgroundPattern.position = CGPoint(
                    x: CGFloat(i) * gridPatternTexture.size().width,
                    y: CGFloat(j) * gridPatternTexture.size().height
                )
                backgroundPattern.anchorPoint = CGPoint(x: 0, y: 0)
                addChild(backgroundPattern)
            }
        }
    }
}
