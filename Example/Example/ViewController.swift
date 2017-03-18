import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeButtonState(_ sender: OnOffButton) {
        sender.checked = !sender.checked
    }
}
