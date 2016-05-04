import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeButtonState(sender: OnOffButton) {
        sender.checked = !sender.checked
    }
}