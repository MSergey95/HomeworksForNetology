import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataModel") // Название вашего .xcdatamodeld файла
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // Контекст для записи/чтения данных
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Сохранение контекста
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Методы для работы с FavoritePost

    // Добавление нового поста
    func addFavoritePost(id: String, title: String, date: Date, image: String) {
        let post = FavoritePost(context: context)
        post.id = id
        post.title = title
        post.date = date

        // Конвертируем имя изображения в UIImage, а затем в Data
        if let uiImage = UIImage(named: image),
           let imageData = uiImage.pngData() {
            post.image = imageData // Сохраняем изображение как Data
        } else {
            print("Не удалось найти изображение с именем: \(image)")
        }

        saveContext()
    
        do {
            try context.save()
            print("Context saved successfully")
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    // Получение всех избранных постов
    func fetchFavoritePosts() -> [FavoritePost] {
        let fetchRequest: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        do {
            let posts = try context.fetch(fetchRequest)
            print("Извлечено \(posts.count) избранных постов")
            return posts
        } catch {
            print("Ошибка извлечения данных: \(error)")
            return []
        }
    }

    // Удаление поста
    func deleteFavoritePost(_ post: FavoritePost) {
        context.delete(post)
        saveContext()
    }
}
