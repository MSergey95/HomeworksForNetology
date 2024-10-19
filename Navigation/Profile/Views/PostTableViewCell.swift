import UIKit

class PostTableViewCell: UITableViewCell {

    private var viewCounter = 0
    var post: Post?

    // MARK: Visual objects

    var postAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    var postImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true // Включаем взаимодействие для изображения
        return image
    }()

    var postDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    var postLikes: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    var postViews: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    // MARK: - Init section

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(postAuthor, postImage, postDescription, postLikes, postViews)
        setupConstraints()
        self.selectionStyle = .default

        // Добавляем жест двойного нажатия на изображение
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        postImage.addGestureRecognizer(doubleTap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            postAuthor.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstants.indent),
            postAuthor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            postAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),

            postImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor, multiplier: 0.96),
            postImage.topAnchor.constraint(equalTo: postAuthor.bottomAnchor, constant: LayoutConstants.indent),

            postDescription.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: LayoutConstants.indent),
            postDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            postDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),

            postLikes.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: LayoutConstants.indent),
            postLikes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstants.leadingMargin),
            postLikes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.indent),

            postViews.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: LayoutConstants.indent),
            postViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LayoutConstants.trailingMargin),
            postViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstants.indent)
        ])
    }

    // MARK: - Run loop

    func configPostArray(post: Post) {
        self.post = post
        postAuthor.text = post.author
        postDescription.text = post.description

        // Загружаем изображение из ассетов
        if let image = UIImage(named: post.image) {
            postImage.image = image
        } else {
            postImage.image = UIImage(named: "defaultImage") // Обработка случая, если изображение не найдено
        }

        postLikes.text = "Likes: \(post.likes)"
        viewCounter = post.views
        postViews.text = "Views: \(viewCounter)"
    }

    func incrementPostViewsCounter() {
        viewCounter += 1
        postViews.text = "Views: \(viewCounter)"
    }

    // MARK: - Handle double tap

    @objc private func handleDoubleTap() {
        guard let post = post else { return }

        // Проверяем, есть ли пост уже в избранном
        let favoritePosts = CoreDataManager.shared.fetchFavoritePosts()
        if favoritePosts.contains(where: { $0.title == post.author }) {
            // Отображаем сообщение, если пост уже в избранном
            let alert = UIAlertController(title: "Ошибка", message: "Этот пост уже в избранных", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let parentVC = parentViewController {
                parentVC.present(alert, animated: true, completion: nil)
            }
            print("Этот пост уже добавлен в избранное")
        } else {
            // Сохраняем пост в избранное через CoreData, передавая строку имени изображения
            CoreDataManager.shared.addFavoritePost(id: UUID().uuidString, title: post.author, date: Date(), image: post.image) // Строка для изображения
            print("Post added to favorites: \(post.author)")

            // Отображаем уведомление об успехе
            let alert = UIAlertController(title: "Успех", message: "Пост добавлен в избранное", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let parentVC = parentViewController {
                parentVC.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Extension to get parent view controller
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
