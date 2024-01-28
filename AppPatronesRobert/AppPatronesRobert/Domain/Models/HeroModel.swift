//
//  HeroModel.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

struct HeroModel: Decodable{
    let id: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
}
