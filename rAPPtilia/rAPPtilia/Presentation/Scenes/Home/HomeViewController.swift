import UIKit

class HomeViewController: UIViewController {
    private let vm = HomeViewModel()
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        
        vm.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            print("reptiles count: \(self.vm.reptiles.count)")
            print(self.vm.reptiles)
        }
        
        vm.onError = { errorMessage in
            print("Error: \(errorMessage)")
        }
        
        vm.loadReptiles()
    }
}
