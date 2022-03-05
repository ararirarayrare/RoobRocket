import SpriteKit


class Plasma: SKSpriteNode {
    
    init(_ scene: SKScene, name: String) {
        let texture = SKTexture(imageNamed: name)
        let size = CGSize(width: scene.size.width / 36,
                          height: scene.size.width / 36)
        
        super.init(texture: texture, color: .clear, size: size)
        
        self.position = .zero
        self.zPosition = 5
        self.name = "plasma"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = BitMaskCatrgories.plasma
        self.physicsBody?.contactTestBitMask = BitMaskCatrgories.ship | BitMaskCatrgories.coin
        
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
