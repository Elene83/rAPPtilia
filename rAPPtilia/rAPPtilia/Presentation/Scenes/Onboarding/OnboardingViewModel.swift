class OnboardingViewModel {
    private let pages = [
        OnboardingPage(title: "Greetingsss!", description: "Welcome to rAPPtilia, your friendly guide to your friendly neighbors of class reptilia.", imageName: "snek", fontColorName: "AppOrange", dotColorName: "AppLightOrange"),
        OnboardingPage(title: "", description: "Learn, pin, keep track and read up on one of the most important class in the ecosystem.", imageName: "liz", fontColorName: "AppDarkGreen", dotColorName: "AppLightGreen"),
        OnboardingPage(title: "Ready to roll?", description: "Share your finds with like-minded people and keep our scaly friends alive and thriving.", imageName: "tort", fontColorName: "AppKhaki", dotColorName: "AppLightKhaki")
    ]
    
    private var currentPage: Int = 0
    
    var numberOfPages: Int {
        return pages.count
    }
    
    func getPage(at index: Int) -> OnboardingPage {
        return pages[index]
    }
    
    func updateCurrentPage(_ page: Int) {
        currentPage = page
    }
    
    func isLastPage() -> Bool {
        return currentPage == numberOfPages - 1
    }
    
    func getButtonLabel() -> String {
        isLastPage() ? "Let's go!" : "Ssskip"
    }
}
