import UIKit

final class FavoritesCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let favoritesVC = FavoritesViewController()
        navigationController.setViewControllers([favoritesVC], animated: false)
    }
}
