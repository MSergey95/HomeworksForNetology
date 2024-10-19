import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let photoIdent = "photoCell"
    var processedImages: [UIImage] = []

    // MARK: Visual objects

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()

    lazy var photosCollectionView: UICollectionView = {
        let photos = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photos.translatesAutoresizingMaskIntoConstraints = false
        photos.backgroundColor = .white
        photos.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: photoIdent)
        return photos
    }()

    // MARK: - Setup section

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Photo Gallery"
        self.view.addSubview(photosCollectionView)
        self.photosCollectionView.dataSource = self
        self.photosCollectionView.delegate = self
        setupConstraints()

        // Вызов функции для обработки изображений
        processImages()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    // MARK: - Image Processing

    func processImages() {
        let processor = ImageProcessor()
        let qosLevels: [QualityOfService] = [.background, .utility, .userInitiated, .userInteractive]
        let filters: [ColorFilter] = [.noir, .chrome, .fade] // Примеры фильтров, которые можно использовать

        for qos in qosLevels {
            for filter in filters {
                // Замер времени выполнения
                let startTime = CFAbsoluteTimeGetCurrent()

                processor.processImagesOnThread(sourceImages: Photos.shared.examples, filter: filter, qos: qos) { [weak self] cgImages in
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                    print("QoS: \(qos), Filter: \(filter), Время обработки: \(timeElapsed) секунд")

                    // Преобразуем [CGImage?] в [UIImage]
                    let uiImages = cgImages.compactMap { cgImage in
                        cgImage.flatMap { UIImage(cgImage: $0) }
                    }

                    DispatchQueue.main.async {
                        self?.processedImages = uiImages
                        self?.photosCollectionView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Extensions

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return processedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoIdent, for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }
        cell.configCellCollection(photo: processedImages[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 2
        let accessibleWidth = collectionView.frame.width - 32
        let widthItem = (accessibleWidth / countItem)
        return CGSize(width: widthItem, height: widthItem * 0.56)
    }
}
