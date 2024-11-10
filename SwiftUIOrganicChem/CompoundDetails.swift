//
//  CompoundDetails.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/8/24.
//

import SwiftUI

struct CompoundDetails: View {
    let compound: Compound
    @Environment(\.colorScheme) var colorScheme // Переменная окружения для отслеживания цветовой схемы

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = URL(string: compound.image), compound.image.contains("http") {
                    // Асинхронная загрузка изображения по URL
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.clear) // Серый фон для темной темы
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    // Локальное изображение с серым фоном для темной темы
                    Image(compound.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                        .padding()
                        .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.clear) // Серый фон для темной темы
                }

                Text(compound.name)
                    .font(.largeTitle)
                    .bold()

                Text("Класс: \(compound.classification)")
                    .font(.title2)
                    .foregroundColor(.secondary)

                Text("Свойства")
                    .font(.headline)
                    .padding(.top)

                Text(compound.properties)
                    .font(.body)
                    .padding(.top, 5)
            }
            .padding()
        }
        .navigationTitle(compound.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CompoundDetails_Previews: PreviewProvider {
    static var previews: some View {
        CompoundDetails(compound: sampleCompounds[0])
            .environment(\.colorScheme, .dark) // Для предпросмотра в темной теме
    }
}
