//
//  NetworkManager.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/8/24.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var compounds: [Compound] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    func fetchCompound(byName name: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        
        guard let url = URL(string: "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/\(encodedName)/JSON") else {
            self.errorMessage = "Неверный URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Ошибка загрузки данных: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "Нет данных"
                    return
                }
                
                do {
                    // Выводим JSON для отладки
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON Response: \(jsonString)")
                    }
                    
                    let decodedData = try JSONDecoder().decode(PubChemResponse.self, from: data)
                    if let compound = self.parsePubChemData(decodedData) {
                        self.compounds = [compound]
                    } else {
                        self.errorMessage = "Не удалось найти данные о соединении"
                    }
                } catch {
                    self.errorMessage = "Ошибка декодирования данных: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func parsePubChemData(_ data: PubChemResponse) -> Compound? {
        guard let compoundData = data.pcCompounds.first else {
            return nil
        }
        
        var name = ""
        var formula = ""
        var molecularWeight = ""
        var imageUrl = ""
        
        // Извлечение CID
        let cid = compoundData.id.id.cid
        imageUrl = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/\(cid)/PNG"
        
        if let properties = compoundData.props {
            for property in properties {
                if property.urn.label == "IUPAC Name", property.urn.name == "Preferred" {
                    name = property.value.sval ?? "Unknown"
                } else if property.urn.label == "Molecular Formula" {
                    formula = property.value.sval ?? "Unknown"
                } else if property.urn.label == "Molecular Weight" {
                    molecularWeight = property.value.sval ?? "Unknown"
                }
            }
        }
        
        return Compound(name: name, image: imageUrl, classification: formula, properties: "Молекулярная масса: \(molecularWeight)")
    }
}
