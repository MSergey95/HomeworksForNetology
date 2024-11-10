import Foundation
import SwiftUI

struct InfoView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var query = ""
    @State private var showLocalData = true
    var titleOn: Bool // Управление отображением заголовка

    // Фильтрация локальных данных на основе запроса
    private var filteredCompounds: [Compound] {
        if query.isEmpty {
            return sampleCompounds
        } else {
            return sampleCompounds.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Поиск (на английском)", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Поиск") {
                        networkManager.fetchCompound(byName: query)
                        showLocalData = false
                    }
                    .padding(.trailing)
                }

                if networkManager.isLoading {
                    ProgressView("Загрузка...")
                } else if let errorMessage = networkManager.errorMessage {
                    VStack {
                        Text("Ошибка: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()

                        Button("Повторить попытку") {
                            networkManager.fetchCompound(byName: query)
                        }
                        .padding()
                    }
                } else if showLocalData || networkManager.compounds.isEmpty {
                    // Отображение локальной базы данных с возможностью поиска
                    List(filteredCompounds) { compound in
                        NavigationLink(destination: CompoundDetails(compound: compound)) {
                            CompoundRow(compound: compound)
                        }
                    }
                    .searchable(text: $query) // Добавляем строку поиска
                } else {
                    // Отображение данных из PubChem
                    List(networkManager.compounds) { compound in
                        NavigationLink(destination: CompoundDetails(compound: compound)) {
                            CompoundRow(compound: compound)
                        }
                    }
                }

                // Кнопка для возврата к базе знаний
                if !showLocalData {
                    Button("Назад к базе знаний") {
                        showLocalData = true
                        query = ""
                        networkManager.errorMessage = nil
                        networkManager.compounds = [] // очищаем результаты поиска
                    }
                    .padding()
                }
            }
            .navigationTitle(titleOn ? "Орг. соединения" : "") // Управляем отображением заголовка
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(titleOn: true)
    }
}
