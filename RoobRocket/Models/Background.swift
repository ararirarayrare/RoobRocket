import Foundation
import SpriteKit

class Background: SKSpriteNode {
    
    init(_ scene: SKScene) {
        let texture = SKTexture(imageNamed: "background")
        
        super.init(texture: texture, color: .brown, size: scene.size)
        self.position = .zero
        
        let circle = SKSpriteNode(imageNamed: "circle")
        circle.position = .zero
        circle.size = CGSize(width: scene.size.width * 0.9,
                             height: scene.size.width * 0.9)
        circle.zPosition = 1
        
        scene.addChild(circle)
        scene.addChild(self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
