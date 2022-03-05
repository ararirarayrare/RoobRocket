import SpriteKit


class Planet: SKSpriteNode {
    
    init(_ scene: SKScene) {
        let texture = SKTexture(imageNamed: "0p")
        let width = scene.size.width * 0.18
        let size = CGSize(width: width, height: width)
        super.init(texture: texture, color: .clear, size: size)
        
        self.name = "0"
        
        self.position = .zero
        self.zPosition = 100
        
        scene.addChild(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
