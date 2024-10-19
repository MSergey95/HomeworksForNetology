//
//  FeedViewController.swift
//  Navigation
import UIKit

class FeedViewController: UIViewController {

    weak var coordinator: FeedCoordinator?

    private var feedModel: FeedModel!

    // MARK: - UI Elements

    private let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your guess"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Check Guess", titleColor: .white, backgroundColor: .systemBlue) {
            self.checkGuessButtonPressed()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var showInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Info", for: .normal)
        button.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        feedModel = FeedModel(secretWord: "password") // Задаем секретное слово

        setupUI()
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.addSubview(guessTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
        view.addSubview(showInfoButton)

        NSLayoutConstraint.activate([
            guessTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            guessTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            guessTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            guessTextField.heightAnchor.constraint(equalToConstant: 40),

            checkGuessButton.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 20),
            checkGuessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 50),

            resultLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            resultLabel.heightAnchor.constraint(equalToConstant: 40),

            showInfoButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            showInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Button Actions

    private func checkGuessButtonPressed() {
        guard let guess = guessTextField.text, !guess.isEmpty else {
            resultLabel.text = "Please enter a guess"
            resultLabel.textColor = .red
            return
        }

        let isCorrect = feedModel.check(word: guess)

        if isCorrect {
            resultLabel.text = "Correct!"
            resultLabel.textColor = .green
        } else {
            resultLabel.text = "Wrong!"
            resultLabel.textColor = .red
        }
    }

    @objc private func showInfo() {
        let infoVC = InfoViewController()
        navigationController?.pushViewController(infoVC, animated: true)
    }
}
