import UIKit

final class PostViewController: UIViewController {

    var post: Post?
    var postImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostViewController loaded with post: \(post?.author ?? "unknown")")

        title = post?.author ?? "-"
        view.backgroundColor = .systemYellow

        // Инициализация изображения поста
        postImageView = UIImageView(image: UIImage(named: post?.image ?? "defaultImage"))
        postImageView?.translatesAutoresizingMaskIntoConstraints = false
        postImageView?.contentMode = .scaleAspectFit
        view.addSubview(postImageView!)

        // Устанавливаем constraints для изображения
        NSLayoutConstraint.activate([
            postImageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            postImageView!.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            postImageView!.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            postImageView!.heightAnchor.constraint(equalToConstant: 300)
        ])

        // Временно добавляем кнопку для тестирования добавления в избранное
        let addButton = UIButton(type: .system)
        addButton.setTitle("Добавить в избранное", for: .normal)
        addButton.addTarget(self, action: #selector(handleAddToFavorites), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        // Устанавливаем constraints для кнопки
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: postImageView!.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        print("PostViewController загружен")
    }

    @objc func handleAddToFavorites() {
        print("Кнопка 'Добавить в избранное' нажата")

        guard let post = post else {
            print("Пост не найден")
            return
        }

        // Сохраняем пост в избранное с именем изображения
        CoreDataManager.shared.addFavoritePost(id: UUID().uuidString, title: post.author, date: Date(), image: post.image)

        print("Пост добавлен в избранное: \(post.author)")

        let alert = UIAlertController(title: "Успех", message: "Пост добавлен в избранное", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
