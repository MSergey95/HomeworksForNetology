//
//  InfoViewController.swift
//  Navigation
//
import UIKit

final class InfoViewController: UIViewController, UITableViewDataSource {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var residents: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        tableView.dataSource = self

        // Регистрация ячейки
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            orbitalPeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Использование асинхронной функции для загрузки данных о планете
        Task {
            await loadPlanetData()
        }
    }

    private func loadPlanetData() async {
        let planetURL = URL(string: "https://swapi.dev/api/planets/1/")!

        do {
            // Использование новой функции для асинхронной загрузки данных о планете
            let planet: Planet = try await NetworkService.fetchDataAsync(from: planetURL, as: Planet.self)
            DispatchQueue.main.async {
                self.titleLabel.text = planet.name
                self.orbitalPeriodLabel.text = "Orbital Period: \(planet.orbitalPeriod) days"
            }

            // Загрузка списка жителей
            await loadResidents(residentURLs: planet.residents)
        } catch {
            print("Failed to load planet: \(error)")
        }
    }

    private func loadResidents(residentURLs: [String]) async {
        for urlString in residentURLs {
            guard let url = URL(string: urlString) else { continue }

            do {
                let resident: Resident = try await NetworkService.fetchDataAsync(from: url, as: Resident.self)
                DispatchQueue.main.async {
                    self.residents.append(resident.name)
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to load resident: \(error)")
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = residents[indexPath.row]
        return cell
    }
}
