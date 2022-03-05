import AVFoundation

var player: AVAudioPlayer?

enum Sound {
    case menuMusic
    case gameMusic
}

func sound(_ sound: Sound) {
    guard let url = Bundle.main.url(forResource: String(describing: sound), withExtension: "mp3") else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }
        
        player.volume = 0.1
        player.numberOfLoops = -1
        
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
    
}


func soundEffect(named: String) {
    guard let url = Bundle.main.url(forResource: String(describing: sound), withExtension: "mp3") else { return }
        
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
        player.volume = 1
                
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}

