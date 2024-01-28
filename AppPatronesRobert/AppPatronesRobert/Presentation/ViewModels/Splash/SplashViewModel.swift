//
//  SplashViewModel.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/23/24.
//

import Foundation

final class SplashViewModel{
    
    // Bindings con UI
    var modelStatusLoad: ((SplashStatusLoad) -> Void)?
    
    //Funcion simular data
    func simulationLoadData(){
        modelStatusLoad?(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){ [weak self] in
            self?.modelStatusLoad?(.loaded)
        }
    }
    
}
