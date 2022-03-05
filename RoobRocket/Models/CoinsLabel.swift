import SpriteKit


class CoinsLabel: SKLabelNode {
    
    init(_ scene: SKScene) {
        super.init()
        
        let position = CGPoint(x: scene.size.width / 3, y: scene.size.height / 2.45)
        self.position = position
        self.zPosition = 10
        
        self.fontSize = 24
        self.fontName = "Copperplate Bold"
        
        self.horizontalAlignmentMode = .left
        self.verticalAlignmentMode = .center
        
        scene.addChild(self)
        
        let coin = SKSpriteNode(imageNamed: "coin")
        
        coin.position = CGPoint(x: position.x - 16, y: position.y)
        coin.zPosition = 10
        coin.size = CGSize(width: 16, height: 16)
        
        scene.addChild(coin)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
