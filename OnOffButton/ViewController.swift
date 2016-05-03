import UIKit

class ViewController: UIViewController {
    
    let onOffButton = OnOffButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onOffButton.frame = CGRect(origin: .zero, size:CGSize(width: 100,height: 100))
        onOffButton.lineWidth = 5
        onOffButton.strokeColor = .whiteColor()
        onOffButton.ringAlpha = 0.3
        onOffButton.addTarget(self, action: #selector(ViewController.didTapOnOffButton), forControlEvents: .TouchUpInside)
        
        view.addSubview(onOffButton)
    }
    
    func didTapOnOffButton() {
        onOffButton.checked = !onOffButton.checked
    }
    
    @IBAction func changeButtonState(sender: OnOffButton) {
        sender.checked = !sender.checked
    }
}