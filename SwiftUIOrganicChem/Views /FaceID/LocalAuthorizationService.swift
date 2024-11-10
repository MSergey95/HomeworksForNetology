//
//  File.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/10/24.
//

import Foundation
import LocalAuthentication

class LocalAuthorizationService {
    
    // Метод для выполнения биометрической авторизации
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("Биометрия доступна, выполняется авторизация...")
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Для входа в приложение") { success, authError in
                DispatchQueue.main.async {
                    if success {
                        print("Авторизация по биометрии прошла успешно")
                    } else {
                        print("Ошибка авторизации: \(authError?.localizedDescription ?? "Неизвестная ошибка")")
                    }
                    authorizationFinished(success)
                }
            }
        } else {
            print("Биометрия недоступна: \(error?.localizedDescription ?? "Неизвестная ошибка")")
            authorizationFinished(false)
        }
    }
}
