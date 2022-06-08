//
//  Container.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/11.
//

import Foundation

class Container {
    static var shared = Container()
    
    private init() { }
    
    lazy var travalRepository: TravalRepository = TravalRepositoryImpl()
    
    lazy var imageManager = ImageManager()
    
    lazy var tokenStore = TokenStore()
    
    lazy var mapRepository: MapRepository = MapRepositoryImpl()
}
