import UIKit
import XCDYouTubeKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    private func parseIdentifier(from url: URL) -> String? {
        let urlString = url.absoluteString
        
        guard let watchIndex = urlString.range(of: "?v=")?.upperBound else { return nil }
        
        let rangeAfter = Range<String.Index>(uncheckedBounds: (lower: watchIndex, upper: urlString.endIndex))
        if let andIndex = urlString.range(of: "&", options: [], range: rangeAfter, locale: nil)?.lowerBound {
            return String(urlString[watchIndex..<andIndex])
        } else {
            return String(urlString[rangeAfter])
        }
    }

    func open(url: URL) {
        self.presentedViewController?.dismiss(animated: false , completion: nil)
        guard let identifier = self.parseIdentifier(from: url) else { return }
        
        let viewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: identifier)
        viewController.moviePlayer.isBackgroundPlaybackEnabled = true
        viewController.moviePlayer.allowsAirPlay = true
        self.present(viewController, animated: false, completion: nil)
    }
}

