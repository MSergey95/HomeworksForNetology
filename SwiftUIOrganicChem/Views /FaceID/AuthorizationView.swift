//
//  AuthorizationView.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/10/24.
//

import SwiftUI

struct AuthorizationView: View {
    private let authService = LocalAuthorizationService()
    @Binding var isAuthorized: Bool // Связь с состоянием авторизации
    @State private var showAlert = false

    init(isAuthorized: Binding<Bool>) { // Инициализатор с параметром для привязки
        self._isAuthorized = isAuthorized
    }

    var body: some View {
        VStack {
            Button("Войти с помощью биометрии") {
                authService.authorizeIfPossible { success in
                    if success {
                        isAuthorized = true // Успешная авторизация, переключаем состояние
                    } else {
                        showAlert = true // Показ предупреждения при неудачной авторизации
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if showAlert {
                Text("Не удалось выполнить авторизацию")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(isAuthorized: .constant(false)) // Используем .constant для предпросмотра
    }
}
