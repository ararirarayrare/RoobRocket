import UIKit

class ShopViewController: UIViewController {
    
    var firstCell: Bool = true
    
    var bought: [Int] = UserDefaults.standard.array(forKey: "bought") as? [Int] ?? [0] {
        didSet {
            UserDefaults.standard.set(self.bought, forKey: "bought")
        }
    }
    
    var current: Int = UserDefaults.standard.integer(forKey: "current")
    
    var balance: Int! {
        didSet {
            guard let balance = balance else { return }
            balanceLabel.text = String(describing: balance)
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex == 0 {
                hide(previousButton)
            } else if selectedIndex == 7 {
                hide(nextButton)
            } else  {
                unhide(previousButton)
                unhide(nextButton)
            }
            
            checkStatus()
            animateCell(oldValue: oldValue)
        }
    }
    
    var buttonStatus: ButtonStatus = .current {
        didSet {
            animateLabel()
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousButton.isHidden = true

        balance = UserDefaults.standard.integer(forKey: "balance")
        
        let cellName = String(describing: ShopCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonTappped(_ sender: UIButton) {
        guard selectedIndex != 7 else { return }
        selectedIndex += 1
    }
    
    @IBAction func previusButtonTapped(_ sender: UIButton) {
        guard selectedIndex != 0 else { return }
        selectedIndex -= 1
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        switch buttonStatus {
        case .current:
            break
        case .select:
            self.select()
        case .buy:
            self.buy()
        }
    }
    
    func hide(_ button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            button.alpha = 0
        } completion: { _ in
            button.isHidden = true
        }
    }
    
    func unhide(_ button: UIButton) {
        button.isHidden = false
        UIView.animate(withDuration: 0.25) {
            button.alpha = 1
        }
    }
    
    func select() {
        UserDefaults.standard.set(selectedIndex, forKey: "current")
        current = selectedIndex
        buttonStatus = .current
        self.buttonLabel.text = "Current"
    }
    
    func buy() {
        guard balance >= 500 else { return }
        self.bought.append(selectedIndex)
        
        balance -= 500
        UserDefaults.standard.set(balance, forKey: "balance")
        
        buttonStatus = .select
        self.buttonLabel.text = "Select"
    }
    
    func checkStatus() {
        if bought.contains(where: { $0 == selectedIndex }) {
            if selectedIndex != current {
                buyButton.setImage(UIImage(named: "currentButton"), for: .normal)
                buttonLabel.textColor = .white
                buttonLabel.text = "Select"
                buttonStatus = .select
            } else {
                buyButton.setImage(UIImage(named: "currentButton"), for: .normal)
                buttonLabel.textColor = .white
                buttonLabel.text = "Current"
                buttonStatus = .current
            }
        } else {
            buyButton.setImage(UIImage(named: "buyButton"), for: .normal)
            buttonLabel.textColor = UIColor(red: 67/255,
                                            green: 149/255,
                                            blue: 247/255,
                                            alpha: 1.0)
            buttonLabel.text = "Buy: 500"
            buttonStatus = .buy
        }
    }
    
    func animateLabel() {
        UIView.animate(withDuration: 0.2) {
    
            let height = self.buttonLabel.layer.frame.size.height * 1.3
            self.buttonLabel.layer.frame.size.height = height
            
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                
                let scale = 1 / 1.3
                let height = self.buttonLabel.layer.frame.size.height * scale
                self.buttonLabel.layer.frame.size.height = height
                
            }
        }
    }
    
    func animateCell(oldValue: Int) {
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
                    
        guard let cell = collectionView.cellForItem(at: indexPath) as? ShopCollectionViewCell else { return }
        cell.scale()
        
        guard oldValue != selectedIndex else { return }
        let oldIndexPath = IndexPath(item: oldValue, section: 0)
        
        guard let oldCell = collectionView.cellForItem(at: oldIndexPath) as? ShopCollectionViewCell else { return }
        oldCell.scaleBack()
    }
    
}


extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: ShopCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ShopCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: indexPath.item)
        
        if firstCell {
            selectedIndex = 0
            cell.scale()
            self.firstCell = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 0, left: collectionView.frame.size.width / 3 + 20, bottom: 0, right: collectionView.frame.size.width / 3 + 20)
        return insets
    }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width / 3,
                          height: collectionView.frame.size.height)
        return size
    }
}
