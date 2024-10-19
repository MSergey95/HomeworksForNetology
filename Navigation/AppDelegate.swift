import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // Добавляем переменную для хранения конфигурации
    var appConfiguration: AppConfiguration?

    // Метод, который вызывается при запуске приложения
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Инициализация Firebase
        FirebaseApp.configure()

        // Инициализация окна
        window = UIWindow(frame: UIScreen.main.bounds)

        // Инициализация и запуск AppCoordinator
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()

        // Рандомная инициализация appConfiguration
        appConfiguration = AppConfiguration.allCases.randomElement()

        // Печать выбранной конфигурации и отправка запроса
        if let config = appConfiguration {
            print("Selected configuration: \(config)")
            NetworkService.requestPlanet(from: config.url) { planet in
                // Обработка ответа
            }
        }

        // Возвращаем true, чтобы указать, что приложение успешно запустилось
        return true
    }
}
