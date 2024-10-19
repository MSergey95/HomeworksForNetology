import UIKit

final class FavoritesViewController: UIViewController {

    private let tableView = UITableView()
    private var favoritePosts: [FavoritePost] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Избранные посты"
        view.backgroundColor = .systemBackground

        setupTableView()
        loadFavoritePosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoritePosts()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func loadFavoritePosts() {
        favoritePosts = CoreDataManager.shared.fetchFavoritePosts()
        print("Fetched \(favoritePosts.count) favorite posts")
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        let favoritePost = favoritePosts[indexPath.row]

        // Конфигурируем ячейку с данными из избранных постов
        cell.postAuthor.text = favoritePost.title ?? "No Title"

        // Декодируем изображение из CoreData
        if let imageData = favoritePost.image, let image = UIImage(data: imageData) {
            cell.postImage.image = image
        } else {
            cell.postImage.image = UIImage(named: "defaultImage") // Устанавливаем изображение по умолчанию
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Логика для выбора поста в будущем при необходимости
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postToDelete = favoritePosts[indexPath.row]
            CoreDataManager.shared.deleteFavoritePost(postToDelete)
            favoritePosts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
