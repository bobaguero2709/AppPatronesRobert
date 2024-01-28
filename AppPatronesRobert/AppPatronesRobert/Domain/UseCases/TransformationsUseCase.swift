//
//  TransformationsUseCase.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

// MARK: PROTOCOL TransformationUseCaseProtocol
protocol TransformationsUseCaseProtocol {
    func getTransformations(id:String, 
                   onSuccess: @escaping ([HeroTransformation])-> Void,
                   onError: @escaping (NetworkError) -> Void)
}

// MARK: Class TransformationUseCase
final class TransformationsUseCase: TransformationsUseCaseProtocol {
    
    func getTransformations(id:String, onSuccess: @escaping ([HeroTransformation])-> Void,
                   onError: @escaping (NetworkError) -> Void){
        
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.allTransformations.rawValue)") else {
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
    
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name:"id", value:id)]
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
            
            
            guard let heroResponse = try? JSONDecoder().decode([HeroTransformation].self, from: data) else {
                
                onError(.decoding)
                return
            }
            
            onSuccess(heroResponse)
        }
        task.resume()
        
    }
}

// MARK: - FAKE SUCCESS
final class TransformationsUseCaseFakeSuccess: TransformationsUseCaseProtocol{
    func getTransformations(id: String, onSuccess: @escaping ([HeroTransformation]) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let transformations = [HeroTransformation(name: "Devil 1", photo: "", id: "661", description: "Transformation Devi 1"),
                HeroTransformation(name: "Devil 2", photo: "", id: "662", description: "Transformation Devil 2")]
                                   onSuccess(transformations)
        }
    }
    
}

// MARK: - FAKE ERROR
final class TransformationsUseCaseError: TransformationsUseCaseProtocol{
    func getTransformations(id: String, onSuccess: @escaping ([HeroTransformation]) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            onError(.noData)
        }
    }
    
}
