//
//  DetailHeroViewModel.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

final class DetailHeroViewModel{
    
    var detailHeroStatusLoad: ((DetailHeroStatusLoad) -> Void)?
    
    let detailHeroUseCase : DetailHeroUseCaseProtocol
    
    var heroName: String
    
    var hero: HeroModel
    
    init(heroName: String,hero: HeroModel, detailHeroUseCase: DetailHeroUseCaseProtocol = DetailHeroUseCase()) {
        self.detailHeroUseCase = detailHeroUseCase
        self.hero = hero
        self.heroName = heroName
    }
    
    func loadHero(heroName:String) {
        detailHeroStatusLoad?(.loading)
        
        detailHeroUseCase.getHero(heroName: heroName, onSuccess: { [weak self] heroes in
            DispatchQueue.main.async {
                print(heroes)
                self?.hero = heroes[0]
                self?.detailHeroStatusLoad?(.loaded)
            }
        }, onError: { [weak self] networkError in
            DispatchQueue.main.async {
                print(networkError)
                self?.detailHeroStatusLoad?(.error)
            }
        })
    }
}
