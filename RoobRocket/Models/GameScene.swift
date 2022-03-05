import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameOverDelegate: GameOverDelegate?
    
    var boat: Boat!
    var planet: Planet!
    var coinsLabel: CoinsLabel!
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
            
    var radius: CGFloat!
    var circle: CGFloat!
    
    var startAngle: CGFloat!
    var endAngle: CGFloat!
    
    var gameStarted: Bool = true
        
    var timer: Timer!
    
    var playSounds: Bool = !UserDefaults.standard.bool(forKey: "sounds")
    
    var coins: Int! {
        didSet {
            guard let coins = coins else { return }
            coinsLabel.text = String(describing: coins)
        }
    }
    
    var score: Int! {
        didSet {
            updateScoreLabel()
        }
    }
    
    var level: Int! {
        didSet {
            guard let level = level else { return }
            self.levelLabel.text = "Level: " + String(describing: level)
        }
    }
    
    var clockwise: Bool = false
    
    var coinsAvailable: Int! {
        didSet {
            guard coinsAvailable == 0 else { return }
            createCoins(with: self.getCoinPositions())
            
            level += 1
            updatePlanet()
            
            score += (level * 5)
            showLevelUpdate()
        }
    }
           
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        physicsWorld.contactDelegate = self
        
        let _ = Background(self)
        planet = Planet(self)
        boat = Boat(self)
        coinsLabel = CoinsLabel(self)
        
        radius = self.size.width * 0.45
        circle = -(4 * CGFloat.pi)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameStarted else { return }
        changeDirection()
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.enumerateChildNodes(withName: "plasma") { node, _ in
            let x = self.size.width / 1.5
            let y = self.size.height / 1.5
            
            let outOfBounds = (node.position.x < -x || node.position.x > x) && (node.position.y < -y || node.position.y > y)
            
            if outOfBounds {
                node.removeFromParent()
            }
        }
    }
    
    @objc func timerAction() {
        score += 1
    }
    
    func startGame() {
        createScore()
        createLevel()
        changeDirection()
        createPlasma(name: "0pz")
        createCoins()
    }
    
    func createCoins() {
        coins = 0
        
        var startingPositions: [CGPoint] {
            let x = [-radius / 1.5, radius / 1.5]
            
            var positions: [CGPoint] = []
            
            for x in x {
                let y = sqrt(square(radius) - square(x))
                
                positions.append(CGPoint(x: x, y: y))
                positions.append(CGPoint(x: x, y: -y))
            }
            return positions
        }
        
        createCoins(with: startingPositions)
    }
    
    func updatePlanet() {
        guard let current = planet.name else { return }
        
        var range = [0,1,2,3,4,5,6,7]
        range.removeAll(where: { $0 == Int(current)})
        
        guard let number = range.randomElement() else { return }
        
        let name = String(describing: number)
        
        let texture = SKTexture(imageNamed: name + "p")
        let textureAction = SKAction.setTexture(texture)
        
        var boomSound = SKAction.playSoundFileNamed("levelup", waitForCompletion: true)
        if !playSounds {
            boomSound = SKAction()
        }
        
        let scale = SKAction.scale(by: 1.3, duration: 0.15)
        let scaleBack = SKAction.scale(by: 1 / 1.3, duration: 0.15)
        
        let sequence = SKAction.sequence([scale, scaleBack])
        
        let group = SKAction.group([sequence, textureAction, boomSound])
        
        planet.run(group) {
            self.planet.name = name
            self.createPlasma(name: name + "pz")
        }
    }
    
    func updateScoreLabel() {
        DispatchQueue.global(qos: .userInteractive).async {
            let block = SKAction.run {
                guard let score = self.score else { return }
                self.scoreLabel.text = String(describing: score)
            }
            
            let scale = SKAction.scale(by: 1.2, duration: 0.1)
            let scaleBack = SKAction.scale(by: 1 / 1.2, duration: 0.1)
            
            let sequence = SKAction.sequence([scale, scaleBack])
            let group = SKAction.group([block, sequence])
            
            self.scoreLabel.run(group)
        }
    }
    
    func showLevelUpdate() {
        DispatchQueue.global(qos: .userInteractive).async {
            let update = SKLabelNode()
            update.position = CGPoint(x: 0, y: self.size.height / 3.2)
            update.zPosition = 9
            update.fontSize = 16
            update.fontName = "Copperplate"
            
            update.text = "New level, score + \(self.level * 5)"
            
            self.addChild(update)
            
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let move = SKAction.move(to: self.levelLabel.position, duration: 1)
            let group = SKAction.group([fadeOut, move])
            
            update.run(group) {
                update.removeFromParent()
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard gameStarted else { return }
        
        let maskA = contact.bodyA.categoryBitMask
        let maskB = contact.bodyB.categoryBitMask
        
        let remove = SKAction.fadeOut(withDuration: 0.1)
        
        let crashed = ((maskA == BitMaskCatrgories.plasma && maskB == BitMaskCatrgories.ship) || (maskA == BitMaskCatrgories.ship && maskB == BitMaskCatrgories.plasma))
        
        let coinCollected = ((maskA == BitMaskCatrgories.coin && maskB == BitMaskCatrgories.ship) || (maskA == BitMaskCatrgories.ship && maskB == BitMaskCatrgories.coin))
        
        let plasmaContactedCoin = ((maskA == BitMaskCatrgories.coin && maskB == BitMaskCatrgories.plasma) || (maskA == BitMaskCatrgories.plasma && maskB == BitMaskCatrgories.coin))
        
        if crashed {
            self.gameStarted = false
            self.timer.invalidate()
            
            self.boat.removeAction(forKey: "followPath")
            self.removeAction(forKey: "plasma")
            
            var sound = SKAction.playSoundFileNamed("boom", waitForCompletion: true)
            
            if !playSounds {
                sound = SKAction()
            }
            
            self.run(sound) {
                self.gameOverDelegate?.pushGameOverViewController(coins: self.coins,
                                                                  score: self.score)
            }
            
        }
        
        if coinCollected {
            if maskA == BitMaskCatrgories.coin {
                guard let node = contact.bodyA.node else { return }
                collectCoin(node)
            } else {
                guard let node = contact.bodyB.node else { return }
                collectCoin(node)
            }
        }
        
        if plasmaContactedCoin {
            if maskA == BitMaskCatrgories.plasma {
                contact.bodyA.node?.run(remove) {
                    contact.bodyA.node?.removeFromParent()
                }
            } else {
                contact.bodyB.node?.run(remove) {
                    contact.bodyB.node?.removeFromParent()
                }
            }
        }
    }
    
    func createScore() {
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: 0, y: self.size.height / 2.6)
        scoreLabel.zPosition = 10
        scoreLabel.fontSize = 40
        scoreLabel.fontName = "Arial Rounded MT Bold"
        self.addChild(scoreLabel)
        
        score = 0
        timer = Timer.scheduledTimer(timeInterval: 0.6,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    func createLevel() {
        levelLabel = SKLabelNode()
        levelLabel.position = CGPoint(x: 0, y: self.size.height / 2.8)
        levelLabel.zPosition = 10
        levelLabel.fontSize = 20
        levelLabel.fontName = "Copperplate Bold"
        self.addChild(levelLabel)
        
        level = 1
    }
    
    func getCoinPositions() -> [CGPoint] {
        let firstX = [-radius / 1.5, radius / 1.5]
        
        var firstPositions: [CGPoint] = []
        
        for x in firstX {
            let y = sqrt(square(radius) - square(x))
            
            firstPositions.append(CGPoint(x: x, y: y))
            firstPositions.append(CGPoint(x: x, y: -y))
        }
        
        var secondPositions: [CGPoint] = []
        
        secondPositions.append(CGPoint(x: 0, y: radius))
        secondPositions.append(CGPoint(x: 0, y: -radius))
        
        secondPositions.append(CGPoint(x: radius, y: 0))
        secondPositions.append(CGPoint(x: -radius, y: 0))
        
        let thirdPositions: [CGPoint] = firstPositions + secondPositions
        
        let secondX = [radius / 1.15, radius / 2.1]
        var fourthPositions: [CGPoint] = secondPositions
        
        for x in secondX {
            let y = sqrt(square(radius) - square(x))
            
            fourthPositions.append(CGPoint(x: x, y: y))
            fourthPositions.append(CGPoint(x: x, y: -y))
            fourthPositions.append(CGPoint(x: -x, y: y))
            fourthPositions.append(CGPoint(x: -x, y: -y))
        }
        
            
        return [firstPositions, secondPositions, thirdPositions, fourthPositions].randomElement()!
    }
    
    func createCoins(with positions: [CGPoint]) {
        coinsAvailable = positions.count
        
        for position in positions {
            let coin = Coin(self)
            
            coin.position = position
            self.addChild(coin)
        }
    }
    
    func createPlasma(name: String) {
        self.removeAction(forKey: "plasma")
        
        let block = SKAction.run {
            let plasma = Plasma(self, name: name)
            
            var dx = CGFloat.random(in: 0...self.radius)
            if self.boat.position.x < 0 {
                dx = CGFloat.random(in: -self.radius...0)
            }

            var dy = sqrt(square(self.radius) - square(dx))
            if self.boat.position.y < 0 {
                dy *= -1
            }
            
            
            let vector =  CGVector(dx: dx / 185, dy: dy / 185)
            
            plasma.physicsBody?.applyImpulse(vector)
        }
        
        let wait = SKAction.wait(forDuration: 0.35)
        let sequence = SKAction.sequence([block, wait])
                
        self.run(.repeatForever(sequence), withKey: "plasma")
    }
    
    func collectCoin(_ node: SKNode) {
        node.physicsBody = nil
        
        if playSounds {
            let sound = SKAction.playSoundFileNamed("collect", waitForCompletion: false)
            self.run(sound)
        }
        
        let move = SKAction.move(to: self.coinsLabel.position, duration: 0.3)
        let scale = SKAction.scale(by: 0.5, duration: 0.3)
        let group = SKAction.group([move, scale])
        
        node.run(group) {
            node.removeFromParent()
            
            self.coinsAvailable -= 1
            self.coins += 1
        }
    }
    
    func changeDirection() {
        self.boat.removeAllActions()
        
        self.circle *= -1
        self.clockwise = !self.clockwise

        var cos = (self.boat.position.x / self.radius)
        
        if cos > 1 {
            cos = 1
        } else if cos < -1 {
            cos = -1
        }
        
        if self.boat.position.y < 0 {
            self.startAngle = -acos(cos)
        }
        
        if self.boat.position.y > 0 {
            self.startAngle = acos(cos)
        }
        
        self.endAngle = startAngle + circle
        
        let path = UIBezierPath(arcCenter: .zero,
                                radius: self.radius,
                                startAngle: self.startAngle,
                                endAngle: self.endAngle,
                                clockwise: self.clockwise)
        
        let move = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 180)
        
        self.boat.run(.repeatForever(move), withKey: "followPath")
    }

}
