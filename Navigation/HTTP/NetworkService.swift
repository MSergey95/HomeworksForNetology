//
//  NetworkService.swift
//  Navigation
//
//  Created by Сергей Минеев on 8/27/24.
//
import Foundation

struct NetworkService {

    // Обобщённый метод для запросов с Decodable
    static func fetchData<T: Decodable>(from url: URL, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // Асинхронный метод с использованием async/await
    static func fetchDataAsync<T: Decodable>(from url: URL, as type: T.Type) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    // Пример использования JSONSerialization
    static func requestTodoJSONSerialization(from url: URL, completion: @escaping (Todo?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                // Инициализация объекта с помощью JSONSerialization
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let userId = json["userId"] as? Int,
                   let id = json["id"] as? Int,
                   let title = json["title"] as? String,
                   let completed = json["completed"] as? Bool {
                    let todo = Todo(userId: userId, id: id, title: title, completed: completed)
                    completion(todo)
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }

    // Старый метод для запроса Todo с использованием JSONDecoder
    static func requestTodo(from url: URL, completion: @escaping (Todo?) -> Void) {
        fetchData(from: url, as: Todo.self) { result in
            switch result {
            case .success(let todo):
                completion(todo)
            case .failure(let error):
                print("Failed to fetch todo: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // Метод для загрузки планет
    static func requestPlanet(from url: URL, completion: @escaping (Planet?) -> Void) {
        fetchData(from: url, as: Planet.self) { result in
            switch result {
            case .success(let planet):
                completion(planet)
            case .failure(let error):
                print("Failed to fetch planet: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // Метод для загрузки жителей планеты
    static func requestResident(from url: URL, completion: @escaping (Resident?) -> Void) {
        fetchData(from: url, as: Resident.self) { result in
            switch result {
            case .success(let resident):
                completion(resident)
            case .failure(let error):
                print("Failed to fetch resident: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people"
    case starships = "https://swapi.dev/api/starships"
    case planets = "https://swapi.dev/api/planets"

    var url: URL {
        URL(string: self.rawValue)!
    }
}
