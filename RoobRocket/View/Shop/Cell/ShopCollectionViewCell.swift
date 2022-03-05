import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = UIScreen.main.bounds.width / 9.5
        
        let size = CGSize(width: width , height: width * 2)
        let frame = CGRect(origin: .zero, size: size)
        imageView = UIImageView(frame: frame)
        imageView.center.x = UIScreen.main.bounds.width / 6
        
        self.addSubview(imageView)
    }
    
    func configure(with number: Int) {
        let image = UIImage(named: String(describing: number))
        imageView.image = image
    }
     
    func scale() {
        UIView.animate(withDuration: 0.3) {
            let width = UIScreen.main.bounds.width / 6
            self.imageView.frame.size = CGSize(width: width, height: width * 2)
            
            self.imageView.center.y = UIScreen.main.bounds.width / 2.5
            self.imageView.center.x = UIScreen.main.bounds.width / 6
        }
    }
    
    func scaleBack() {
        UIView.animate(withDuration: 0.3) {
            let width = UIScreen.main.bounds.width / 10
            let size = CGSize(width: width , height: width * 2)
            self.imageView.frame.size = size
            
            self.imageView.frame.origin.y = 0
            self.imageView.center.x = UIScreen.main.bounds.width / 6
        }
    }

}
