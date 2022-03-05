import SpriteKit

class Coin: SKSpriteNode {
    
    init(_ scene: SKScene) {
        let texture = SKTexture(imageNamed: "coin")
        let size = CGSize(width: scene.size.width / 20,
                          height: scene.size.width / 20)
        
        super.init(texture: texture, color: .clear, size: size)
        
        self.zPosition = 4
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.categoryBitMask = BitMaskCatrgories.coin
        self.physicsBody?.collisionBitMask = BitMaskCatrgories.ship | BitMaskCatrgories.plasma
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
