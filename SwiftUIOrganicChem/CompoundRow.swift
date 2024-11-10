//
//  CompoundRow.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/8/24.
//

import Foundation
import SwiftUI

struct CompoundRow: View {
    var compound: Compound

    var body: some View {
        HStack {
            Image(compound.image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading) {
                Text(compound.name)
                    .font(.headline)
                Text(compound.classification)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

struct CompoundRow_Previews: PreviewProvider {
    static var previews: some View {
        CompoundRow(compound: sampleCompounds[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
