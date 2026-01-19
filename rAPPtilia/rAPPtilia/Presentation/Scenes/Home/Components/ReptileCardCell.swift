import UIKit

class ReptileCardCell: UICollectionViewCell {
    private var cardView: ReptileSpeciesCardView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with reptile: Reptile) {
        cardView?.removeFromSuperview()
        
        let newCardView = ReptileSpeciesCardView(reptile: reptile)
        newCardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newCardView)
        
        NSLayoutConstraint.activate([
            newCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        self.cardView = newCardView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardView?.removeFromSuperview()
        cardView = nil
    }
}
