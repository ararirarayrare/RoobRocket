import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var soundsSwitch: UISwitch!
    @IBOutlet weak var gameMusicSwitch: UISwitch!
    @IBOutlet weak var menuMusicSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundsSwitch.isOn = !UserDefaults.standard.bool(forKey: "sounds")
        gameMusicSwitch.isOn = !UserDefaults.standard.bool(forKey: "gameMusic")
        menuMusicSwitch.isOn = !UserDefaults.standard.bool(forKey: "menuMusic")
    }

    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func soundsSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(!sender.isOn, forKey: "sounds")
    }
    
    @IBAction func gameMusicSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(!sender.isOn, forKey: "gameMusic")
    }
    
    @IBAction func menuMusicSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            sound(.menuMusic)
        } else {
            player?.stop()
        }
        
        UserDefaults.standard.set(!sender.isOn, forKey: "menuMusic")
    }
    
    
}
