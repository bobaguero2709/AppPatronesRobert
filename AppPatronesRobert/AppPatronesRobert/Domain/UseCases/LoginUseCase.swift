//
//  LoginUseCase.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import Foundation

// MARK: Protocol Login Use Case
protocol LoginUseCaseProtocol {
    func login(user:String,
               password:String,
               onSuccess: @escaping (String?) -> Void,
               onError: @escaping (NetworkError) -> Void )
    
}

// MARK: Class Login Use Case
final class LoginUseCase: LoginUseCaseProtocol{
    func login(user:String,
               password:String,
               onSuccess: @escaping (String?) -> Void,
               onError: @escaping (NetworkError) -> Void ){
        
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.login.rawValue)") else {
            onError(.malformedURL)
            return
        }
        
        let loginString = String(format:"%@:%@",user,password)
        guard let loginData = loginString.data(using: .utf8) else {
            onError(.dataFormatting)
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = HTTPMethods.post
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest){data,response,error in
            guard error == nil else {
                onError(.other)
                return
            }
            
            guard let data = data else {
                onError(.noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse), 
                httpResponse.statusCode == HTTPResponseCodes.SUCCESS else {
                onError(.errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                onError(.tokenFormatError)
                return
            }
            
            UserDefaultsHelper.save(token: token)
            onSuccess(token)
            
        }
        task.resume()
        
    }
}

// MARK: LOGIN USE CASE FAKE SUCCESS

final class LoginUseCaseFakeSuccess: LoginUseCaseProtocol {
    func login(user: String, password: String, onSuccess: @escaping (String?) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let token = "123456"
            onSuccess(token)
        }
    }

}

// MARK: LOGIN USE CASE FAKE ERROR
final class LoginUseCaseFakeError: LoginUseCaseProtocol{
    func login(user: String, password: String, onSuccess: @escaping (String?) -> Void, onError: @escaping (NetworkError) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            onError(.tokenFormatError)
        }
    }
    
    
    
}
