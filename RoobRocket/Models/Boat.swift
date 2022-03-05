import SpriteKit

class Boat: SKSpriteNode {
    
    init(_ scene: SKScene) {
        let selected = UserDefaults.standard.integer(forKey: "current")
        let texture = SKTexture(imageNamed: String(describing: selected))
        let height = scene.size.width / 8
        let size = CGSize(width: height / 2, height: height)
        super.init(texture: texture, color: .clear, size: size)
        
        self.position = CGPoint(x: 0, y: scene.size.width * 0.45)
        self.zPosition = 2
        self.zRotation = CGFloat.pi / 2
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = BitMaskCatrgories.ship
        self.physicsBody?.contactTestBitMask = BitMaskCatrgories.plasma | BitMaskCatrgories.coin
        
        scene.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
