//
//  PageInfo.swift
//  RickAndMortyApp
//
//  Created by Admin on 17.11.2019.
//  Copyright © 2019 Xelwow. All rights reserved.
//

import Foundation

struct PageInfo : Codable{
    let count : Int
    let pages : Int
    let next : String
    let prev : String
}

struct GetPageResponse : Codable {
    let info : PageInfo
    let results : [CharacterInfo]
}
