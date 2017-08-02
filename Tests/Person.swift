//
//  Person.swift
//  Ladybug Tests
//
//  Created by Jeff Hurray on 7/29/17.
//  Copyright © 2017 jhurray. All rights reserved.
//

import Foundation
@testable import Ladybug

struct Pet: JSONCodable {
    
    static let dogJSON: String = """
    {
    "pet_kind": "dog",
    "name": "agnes"
    }
    """
    
    static let catJSON: String = """
    {
    "pet_kind": "cat",
    "name": "winston"
    }
    """
    
    static let birdJSON: String = """
    {
    "pet_kind": "other",
    "name": "peachy bird"
    }
    """
    
    static let transformers: [JSONTransformer] = [
        JSONKeyPathTransformer(propertyName: "kind", keyPath: JSONKeyPath("pet_kind")),
        JSONDateTransformer(propertyName: "createdAt", customAdapter: { (_) -> Date in
            return Date()
        })
    ]

    enum Kind: String, Codable {
        case dog
        case cat
        case other
    }
    
    let kind: Kind
    let name: String
    let createdAt: Date
}

struct Person: JSONCodable {
    
    static let kidJSONString = """
    {
    "full_name": "Devon Redfern",
    "age": 6,
    "gender": "female",
    "date_of_birth": "3/24/1992",
    "personalWebsite": "https://mulesoft.com",
    "kids": []
    }
    """
    
    static let jsonString: String = """
    {
    "full_name": "Jeff Hurray",
    "age": 24,
    "gender": "male",
    "date_of_birth": "10/25/1992",
    "personalWebsite": "https://google.com",
    "pet_thing": \(Pet.dogJSON),
    "kids": [\(kidJSONString), \(kidJSONString)],
    "pets": [\(Pet.catJSON), \(Pet.birdJSON)]
    }
    """
    
    static let transformers: [JSONTransformer] = [
        JSONNestedObjectTransformer(propertyName: "pet", keyPath: JSONKeyPath("pet_thing"), type: Pet.self),
        JSONKeyPathTransformer(propertyName: "name", keyPath: JSONKeyPath("full_name")),
        JSONKeyPathTransformer(propertyName: "petName", keyPath: JSONKeyPath("pet_thing", "name")),
        JSONDateTransformer(propertyName: "birthday", keyPath: JSONKeyPath("date_of_birth"), dateFormat: .custom(format: "mm/dd/YYYY")),
        JSONNestedListTransformer(propertyName: "kids", type: Person.self),
        JSONNestedObjectTransformer(propertyName: "favoritePet", keyPath: JSONKeyPath("pets", 1) , type: Pet.self),
    ]
    
    enum Gender: String, Codable {
        case male
        case female
    }
    
    let name: String
    let age: Int
    let gender: Gender
    let pet: Pet?
    let petName: String?
    let personalWebsite: URL
    let birthday: Date
    let kids: [Person]
    let favoritePet: Pet?
}