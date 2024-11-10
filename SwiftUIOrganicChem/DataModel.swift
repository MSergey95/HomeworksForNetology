//
//  DataModel.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/8/24.
//

import Foundation
import SwiftUI

let sampleCompounds = [
    Compound(name: "Метан", image: "Methane", classification: "Алкан", properties: "Газ, нерастворим в воде, используется как топливо."),
    Compound(name: "Этанол", image: "Ethanol", classification: "Спирт", properties: "Жидкость, растворима в воде, используется в качестве растворителя."),
    Compound(name: "Этановая кислота", image: "AceticAcid", classification: "Карбоновая кислота", properties: "Жидкость с резким запахом, растворима в воде, применяется как пищевая добавка."),
    Compound(name: "Бензол", image: "Benzene", classification: "Ароматический углеводород", properties: "Жидкость, нерастворима в воде, используется в химической промышленности."),
    Compound(name: "Пропан", image: "Propane", classification: "Алкан", properties: "Газ, нерастворим в воде, используется как топливо."),
    Compound(name: "Формальдегид", image: "Formaldehyde", classification: "Альдегид", properties: "Газ с резким запахом, растворим в воде, применяется в производстве пластмасс."),
    Compound(name: "Ацетон", image: "Acetone", classification: "Кетон", properties: "Жидкость, хорошо растворима в воде, используется как растворитель."),
    Compound(name: "Глюкоза", image: "Glucose", classification: "Моносахарид", properties: "Твердое вещество, растворимо в воде, основной источник энергии для организма."),
    Compound(name: "Анилин", image: "Aniline", classification: "Ароматический амин", properties: "Жидкость, малорастворима в воде, используется в производстве красителей."),
    Compound(name: "Фенол", image: "Phenol", classification: "Ароматический спирт", properties: "Твердое вещество, растворимо в воде, используется в производстве пластмасс.")
]
let compoundClasses = [
    "Алкан", "Алкен", "Алкин", "Спирт", "Карбоновая кислота",
    "Ароматический углеводород", "Альдегид", "Кетон", "Моносахарид", "Амин"
]
