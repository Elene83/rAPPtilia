import UIKit

extension HomeCardsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let newPage = Int(round(scrollView.contentOffset.x / pageWidth))
        
        if newPage != currentPage {
            currentPage = newPage
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let pageWidth = scrollView.bounds.width
            let newPage = Int(round(scrollView.contentOffset.x / pageWidth))
            
            if newPage != currentPage {
                currentPage = newPage
            }
        }
    }
}
