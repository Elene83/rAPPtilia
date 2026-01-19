import UIKit

class ReptileGridView: UIView {
    //MARK: Properties
    private let collectionView: UICollectionView
    private let reptiles: [Reptile]
    private let order: String
    private weak var coordinator: MainCoordinator?
    private var navigationController: UINavigationController?
    private var onBack: (() -> Void)?
    
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    //MARK: Inits
    init(reptiles: [Reptile],
         order: String,
         coordinator: MainCoordinator?,
         navigationController: UINavigationController?,
         onBack: @escaping () -> Void) {
        
        self.reptiles = reptiles
        self.order = order
        self.coordinator = coordinator
        self.navigationController = navigationController
        self.onBack = onBack
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setupView() {
        backgroundColor = UIColor(named: "AppBG") ?? .systemBackground
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ReptileCardCell.self, forCellWithReuseIdentifier: "ReptileCardCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .ended {
            if translation.x > 100 {
                onBack?()
            }
        }
    }
}

//MARK: Extensions
extension ReptileGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reptiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReptileCardCell", for: indexPath) as? ReptileCardCell else {
            return UICollectionViewCell()
        }
        
        let reptile = reptiles[indexPath.item]
        cell.configure(with: reptile)
        
        return cell
    }
}

extension ReptileGridView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reptile = reptiles[indexPath.item]
        
        if let nav = navigationController, let coord = coordinator {
            coord.showDetails(for: reptile, from: nav)
        }
    }
}

extension ReptileGridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 16 + 40
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / 2
        
        let itemHeight = Card.CardType.species.size.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
