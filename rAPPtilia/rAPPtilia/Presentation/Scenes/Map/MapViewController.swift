import UIKit

class MapViewController: UIViewController {
    weak var coordinator: AuthCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
    }
}
