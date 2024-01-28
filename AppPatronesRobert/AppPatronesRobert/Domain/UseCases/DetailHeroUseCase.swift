//
//  DetailHeroUseCase.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

// MARK: PROTOCOL DetailHeroUseCaseProtocol
protocol DetailHeroUseCaseProtocol {
    func getHero(heroName: String, 
                 onSuccess: @escaping ([HeroModel])-> Void,
                   onError: @escaping (NetworkError) -> Void)
}

// MARK: Class DetailHeroUseCase
final class DetailHeroUseCase: DetailHeroUseCaseProtocol {
    
    func getHero(heroName: String,onSuccess: @escaping ([HeroModel])-> Void,
                   onError: @escaping (NetworkError) -> Void){
        
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.allHeroes.rawValue)") else {
            onError(.malformedURL)
            return
        }
        
        guard let token = UserDefaultsHelper.getToken() else {
            onError(.tokenFormatError)
            return
        }
        
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPConfigurations.authorization)
        //urlRequest.setValue(HTTPMethods.contentType, forHTTPHeaderField: HTTPConfigurations.contentType)
    
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name:"name", value:heroName)]
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: urlRequest){data,response,error in
            
            guard error == nil else {
                onError(.other)
                return
            }
            
            guard let data = data else {
                onError(.noData)
                return
            }
            
            print(data)
            
            guard let httpResponse = (response as? HTTPURLResponse),
                httpResponse.statusCode == HTTPResponseCodes.SUCCESS else {
                onError(.errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            
            guard let heroResponse = try? JSONDecoder().decode([HeroModel].self, from: data) else {
                
                onError(.decoding)
                return
            }
            
            onSuccess(heroResponse)
        }
        task.resume()
        
    }
}

// MARK: - FAKE SUCCESS
final class DetailHeroUseCaseFakeSuccess: DetailHeroUseCaseProtocol{
    func getHero(heroName: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let heroes = [HeroModel(id: "66", name: "Devil", description: "Devil man", photo: "", favorite: true),
                HeroModel(id: "7", name: "God", description: "God man", photo: "", favorite: false)]
            onSuccess([heroes[0]])
        }
    }
}

// MARK: - FAKE ERROR
final class DetailHeroUseCaseFakeError: DetailHeroUseCaseProtocol{
    func getHero(heroName: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            onError(.noData)
        }
    }
}
