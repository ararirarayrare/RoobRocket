import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var completion: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scene.startGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scene.timer.invalidate()
        scene.isPaused = true
    }

    @IBAction func backTapped(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    func loadGame() {
        if let view = self.view as! SKView? {
            scene = GameScene()
            
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.scaleMode = .resizeFill
            scene.gameOverDelegate = self
            
            view.showsNodeCount = true
            view.showsFPS = true
            
            view.presentScene(scene)
            player?.stop()
            
            guard !UserDefaults.standard.bool(forKey: "gameMusic") else { return }
            sound(.gameMusic)
        }
    }
    
    
}


extension GameViewController: GameOverDelegate {
    func pushGameOverViewController(coins: Int, score: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: GameOverViewController.self)
        
        guard let gameOverViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? GameOverViewController else { return }
        
        gameOverViewController.coinsCollected = coins
        gameOverViewController.currentScore = score
        
        gameOverViewController.completion = {
            self.dismiss(animated: true)
            self.completion()
        }
        
        gameOverViewController.loadGame = {
            self.loadGame()
            self.scene.startGame()
        }
        
        gameOverViewController.modalPresentationStyle = .custom
        gameOverViewController.transitioningDelegate = self
        
        self.present(gameOverViewController, animated: true)
    }
}


extension  GameViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension GameViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.viewController(forKey: .to)?.view else { return }

        let isPresenting = (fromView == view)
        
        let presentingView = isPresenting ? toView : fromView
        
        if isPresenting {
            transitionContext.containerView.addSubview(presentingView)
        }
        
        
        let size = CGSize(width: UIScreen.main.bounds.size.width,
                          height: UIScreen.main.bounds.size.height)
        
        let offScreenFrame = CGRect(origin: CGPoint(x: size.width, y: 0), size: size)
        let onScreenFrame = CGRect(origin: .zero, size: size)
        let viewFrame = CGRect(origin: CGPoint(x: -size.width, y: 0), size: size)

        
        presentingView.frame = isPresenting ? offScreenFrame : onScreenFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame = isPresenting ? viewFrame : onScreenFrame
            presentingView.frame = isPresenting ? onScreenFrame : offScreenFrame
            
        } completion: { isSuccess in
            if !isPresenting {
                presentingView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(isSuccess)
        }

    }
}
