import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        tap.numberOfTapsRequired = 1
        bg.isUserInteractionEnabled = true
        bg.addGestureRecognizer(tap)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
}
