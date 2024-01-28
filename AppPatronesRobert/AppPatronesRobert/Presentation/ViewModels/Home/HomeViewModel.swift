//
//  HomeViewModel.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

final class HomeViewModel{
    
    var homeStatusLoad: ((HomeStatusLoad) -> Void)?
    
    let homeUseCase : HomeUseCaseProtocol
    
    var dataHeroes: [HeroModel] = []
    
    init(homeUseCase: HomeUseCaseProtocol = HomeUseCase()) {
        self.homeUseCase = homeUseCase
    }
    
    func loadHeroes() {
        homeStatusLoad?(.loading)
        
        homeUseCase.getHeroes { [weak self] heroes in
            DispatchQueue.main.async {
                self?.dataHeroes = heroes
                self?.homeStatusLoad?(.loaded)
            }
        } onError: { [weak self] networkError in
            DispatchQueue.main.async {
                
                self?.homeStatusLoad?(.error)
            }
        }
    }
}
