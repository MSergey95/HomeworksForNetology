//
//  SwiftUIOrganicChemApp.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/8/24.
//

import SwiftUI

@main
struct SwiftUIOrganicChemApp: App {
    @State private var isAuthorized = false // Управление состоянием авторизации

    var body: some Scene {
        WindowGroup {
            if isAuthorized {
                ContentView() // Переход на ContentView после авторизации
            } else {
                AuthorizationView(isAuthorized: $isAuthorized) // Передаем состояние в AuthorizationView
            }
        }
    }
}
