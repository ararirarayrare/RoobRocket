import UIKit

class GameOverViewController: UIViewController {
    
    var completion: (() -> ())!
    var loadGame: (() -> ())!
    var currentScore: Int!
    var coinsCollected: Int!
    
    var bestScore: Int = UserDefaults.standard.integer(forKey: "bestScore") {
        didSet {
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
    }

    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var coinsCollectedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var balance = UserDefaults.standard.integer(forKey: "balance")
        balance += coinsCollected
        UserDefaults.standard.set(balance, forKey: "balance")
                
        if currentScore > bestScore {
            bestScore = currentScore
            bestLabel.text = "New best score! : "
        }
        
        guard let currentScore = currentScore else { return }
        guard let coinsCollected = coinsCollected else { return }
        
        bestScoreLabel.text = String(describing: bestScore)
        currentScoreLabel.text = String(describing: currentScore)
        coinsCollectedLabel.text = String(describing: coinsCollected)
    }
    
    @IBAction func menuTapped(_ sender: UIButton) {
        self.dismiss(animated: false)
        self.completion()
    }
    
    @IBAction func replayTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.loadGame()
        }
    }
    
}
