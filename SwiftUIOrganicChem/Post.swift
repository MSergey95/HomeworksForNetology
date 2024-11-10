//
//  Post.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/8/24.
//

import Foundation
import SwiftUI

struct Compound: Identifiable {
    var id = UUID()
    var name: String // Название соединения
    var image: String // Название изображения из ассетов
    var classification: String // Класс вещества (например, "Алкан", "Спирт")
    var properties: String // Краткие свойства соединения
}
