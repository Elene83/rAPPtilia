import UIKit

class HomeCardsViewController: UIViewController {
    //MARK: Properties
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private var reptiliaCardView: ReptiliaCardView!
    private var orderCardsView: OrderCardsView!
    private var reptileGridView: ReptileGridView?
    
    private var vm: HomeViewModel
    private weak var coordinator: MainCoordinator?
    private var customNavigationController: UINavigationController?
    
    var currentPage: Int = 0 {
        didSet {
            if currentPage > oldValue {
                reptiliaCardView.hasUserSwiped = true
            }
        }
    }
    
    private var selectedOrder: String? = nil {
        didSet {
            handleOrderSelection()
        }
    }
    
    private let pageCount = 2
    
    //MARK: Inits
    init(vm: HomeViewModel,
         coordinator: MainCoordinator?,
         navigationController: UINavigationController?) {
        self.vm = vm
        self.coordinator = coordinator
        self.customNavigationController = navigationController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
    }
    
    //MARK: Methods
    private func setupView() {
        view.backgroundColor = UIColor(named: "AppBG") ?? .systemBackground
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentStackView.axis = .horizontal
        contentStackView.spacing = 0
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        reptiliaCardView = ReptiliaCardView(hasUserSwiped: false)
        reptiliaCardView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(reptiliaCardView)
        
        orderCardsView = OrderCardsView { [weak self] order in
            self?.animateOrderSelection(order)
        }
        orderCardsView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(orderCardsView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            reptiliaCardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            orderCardsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func updateScrollViewContentSize() {
        let width = view.bounds.width * CGFloat(pageCount)
        scrollView.contentSize = CGSize(width: width, height: scrollView.bounds.height)
    }
    
    private func animateOrderSelection(_ order: String) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.selectedOrder = order
        }
    }
    
    private func handleOrderSelection() {
        if let order = selectedOrder {
            let filteredReptiles = vm.reptiles.filter {
                $0.order.uppercased() == order.uppercased()
            }
            
            reptileGridView?.removeFromSuperview()
            
            let gridView = ReptileGridView(
                reptiles: filteredReptiles,
                order: order,
                coordinator: coordinator,
                navigationController: customNavigationController,
                onBack: { [weak self] in
                    self?.animateBackToCards()
                }
            )
            
            gridView.translatesAutoresizingMaskIntoConstraints = false
            gridView.alpha = 0
            view.addSubview(gridView)
            
            NSLayoutConstraint.activate([
                gridView.topAnchor.constraint(equalTo: view.topAnchor),
                gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            self.reptileGridView = gridView
            
            UIView.animate(withDuration: 0.3) {
                gridView.alpha = 1
                self.scrollView.alpha = 0
            }
        } else {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.reptileGridView?.alpha = 0
                    self.scrollView.alpha = 1
                },
                completion: { _ in
                    self.reptileGridView?.removeFromSuperview()
                    self.reptileGridView = nil
                }
            )
        }
    }
    
    private func animateBackToCards() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.selectedOrder = nil
        }
    }
}
