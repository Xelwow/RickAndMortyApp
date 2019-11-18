//
//  CharacterInfo.swift
//  RickAndMortyApp
//
//  Created by Admin on 17.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation

class CharacterInfo : Codable{
    let id : Int
    let name : String
    let status : String
    let species : String
    let type : String
    let gender : String
    let url : String
    let image : String
    let origin : PlanetInfo
    let location : PlanetInfo
    var imageData : Data?
    let episode : [String]
}

struct PlanetInfo : Codable {
    let name : String
    let url : String
}
