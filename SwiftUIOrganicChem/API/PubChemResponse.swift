//
//  PubChemResponse.swift
//  SwiftUIOrganicChem
//
//  Created by Сергей Минеев on 11/8/24.
//

import Foundation

struct PubChemResponse: Codable {
    let pcCompounds: [PCCompound]

    enum CodingKeys: String, CodingKey {
        case pcCompounds = "PC_Compounds"
    }
}

struct PCCompound: Codable {
    let id: CompoundID
    let props: [CompoundProperty]?

    struct CompoundID: Codable {
        let id: CID

        struct CID: Codable {
            let cid: Int
        }
    }
}

struct CompoundProperty: Codable {
    let urn: Urn
    let value: PropertyValue

    struct Urn: Codable {
        let label: String
        let name: String?
    }

    struct PropertyValue: Codable {
        let sval: String?
        let fval: Float?
    }
}
