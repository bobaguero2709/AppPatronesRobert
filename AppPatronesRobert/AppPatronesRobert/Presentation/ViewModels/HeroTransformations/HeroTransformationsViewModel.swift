//
//  HeroTransformationsViewModel.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

final class HeroTransformationsViewModel{
    
    var transformationsStatusLoad: ((TransformationsStatusLoad) -> Void)?
    
    let transformationsUseCase : TransformationsUseCaseProtocol
    
    var dataTransformations: [HeroTransformation] = []
    
    init(transformationsUseCase: TransformationsUseCaseProtocol = TransformationsUseCase()) {
        self.transformationsUseCase = transformationsUseCase
    }
    
    func loadTransformations(id:String) {
        transformationsStatusLoad?(.loading)
        
        transformationsUseCase.getTransformations(id: id, onSuccess: { [weak self] transformations in
            DispatchQueue.main.async {
                self?.dataTransformations = transformations
                self?.transformationsStatusLoad?(.loaded)
            }
        }, onError: { [weak self] networkError in
            DispatchQueue.main.async {
                self?.transformationsStatusLoad?(.error)
            }
        })
    }
}
