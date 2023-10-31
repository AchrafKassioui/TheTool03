import Foundation
import SpriteKit

class MessageLogger: ObservableObject {
    @Published var message: String = ""
    
    func log(_ item: String) {
        message = item
    }
    
    func log(_ point: CGPoint) {
        message = "x: \(Int(point.x)) \n y: \(Int(point.y))"
    }
    
    func log(_ size: CGSize) {
        message = "width: \(size.width) \n height: \(size.height)"
    }
    
    func log(_ timeinterval: TimeInterval) {
        message = "interval: \(timeinterval) s"
    }
    
    func log(_ node: SKNode) {
        message = "Node name: \(node.name ?? "Unnamed") \n position: x: \(node.position.x) \n y: \(node.position.y)"
    }
    
    func log(_ action: SKAction) {
        message = "Action duration: \(action.duration)"
    }
    
    func log(_ texture: SKTexture) {
        message = "Texture size: width: \(texture.size().width) \n height: \(texture.size().height)"
    }
    
}
