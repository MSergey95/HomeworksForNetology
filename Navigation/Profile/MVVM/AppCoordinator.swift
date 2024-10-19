import Foundation
import UIKit

// Протокол для всех координаторов, чтобы у них был метод `start`
protocol Coordinator {
    func start()
}

// Главный координатор, который будет управлять всей навигацией
final class AppCoordinator: Coordinator {
    var window: UIWindow
    var tabBarController: UITabBarController
    var profileCoordinator: ProfileCoordinator?
    var feedCoordinator: FeedCoordinator?
    var favoritesCoordinator: FavoritesCoordinator?  // Добавляем координатор для избранного

    init(window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
    }

    func start() {
        // Инициализация UINavigationController для каждого модуля
        let profileNC = UINavigationController()
        let feedNC = UINavigationController()
        let favoritesNC = UINavigationController()  // Навигейшн контроллер для избранного

        // Инициализация дочерних координаторов
        profileCoordinator = ProfileCoordinator(navigationController: profileNC)
        feedCoordinator = FeedCoordinator(navigationController: feedNC)
        favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNC)  // Инициализация координатора для избранного

        // Запуск дочерних координаторов
        profileCoordinator?.start()
        feedCoordinator?.start()
        favoritesCoordinator?.start()  // Запуск FavoritesCoordinator

        // Настройка вкладок
        profileNC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        feedNC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "text.bubble"), selectedImage: UIImage(systemName: "text.bubble.fill"))
        favoritesNC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))  // Настраиваем вкладку избранного

        // Добавление контроллеров во вкладки
        tabBarController.viewControllers = [profileNC, feedNC, favoritesNC]

        // Настройка окна
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
