import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func playTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: GameViewController.self)

        guard let gameViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? GameViewController else { return }
                        
        gameViewController.modalPresentationStyle = .custom
        gameViewController.transitioningDelegate = self
        
        gameViewController.completion = configure
        
        present(gameViewController, animated: true)
    }
    
    @IBAction func shopTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: ShopViewController.self)

        guard let shopViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? ShopViewController else { return }
        
                        
        shopViewController.modalPresentationStyle = .custom
        shopViewController.transitioningDelegate = self
        
        present(shopViewController, animated: true)
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: SettingsViewController.self)

        guard let settingsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? SettingsViewController else { return }
        
                        
        settingsViewController.modalPresentationStyle = .custom
        settingsViewController.transitioningDelegate = self
        
        present(settingsViewController, animated: true)
    }
    
    @IBAction func infoTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: InfoViewController.self)

        guard let infoViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? InfoViewController else { return }
        
                        
        infoViewController.modalPresentationStyle = .custom
        infoViewController.transitioningDelegate = self
        
        present(infoViewController, animated: true)
        
        soundEffect(named: "collect")
    }
    
    func configure() {
        guard !UserDefaults.standard.bool(forKey: "menuMusic") else { return }
        sound(.menuMusic)
        
        let balance = UserDefaults.standard.integer(forKey: "balance")
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        
        coinsLabel.text = String(describing: balance)
        bestScoreLabel.text = "Your best score: " + String(describing: bestScore)
    }
    
    
}

extension  MenuViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension MenuViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from),
              let to = transitionContext.viewController(forKey: .to) else { return }
        
        guard let fromView = from.view,
              let toView = to.view else { return }
        
        let isPresenting = (fromView == view)
        
        let presentingView = isPresenting ? toView : fromView
        
        if isPresenting {
            transitionContext.containerView.addSubview(presentingView)
        }
        
        
        let size = CGSize(width: UIScreen.main.bounds.size.width,
                          height: UIScreen.main.bounds.size.height)
        
        var offScreenFrame = CGRect(origin: CGPoint(x: size.width, y: 0), size: size)
        let onScreenFrame = CGRect(origin: .zero, size: size)
        var viewFrame = CGRect(origin: CGPoint(x: -size.width, y: 0), size: size)

        if to as? SettingsViewController != nil || from as? SettingsViewController != nil {
            offScreenFrame = CGRect(origin: CGPoint(x: -size.width, y: 0), size: size)
            viewFrame = CGRect(origin: CGPoint(x: size.width, y: 0), size: size)
        }
        
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

