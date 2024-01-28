//
//  LoginViewModel.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/24/24.
//

import Foundation

final class LoginViewModel{
    //Binding con UI
    
    var loginViewState: ((LoginStatusLoad) -> Void)?
    
    private let loginUseCase: LoginUseCaseProtocol
    
    // INIT
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()){
        self.loginUseCase = loginUseCase
    }
   
    func onLoginButton(email: String?, password: String?){
        loginViewState?(.loading(true))
        
        guard let email = email, isValid(email: email) else {
            loginViewState?(.loading(false))
            loginViewState?(.showErrorEmail("Error en el email"))
            return
        }
        guard let password = password, isValid(password: password) else {
            loginViewState?(.loading(false))
            loginViewState?(.showErrorPassword("Error en el password"))
            return
        }
        
        doLoginWith(email: email, password: password)
        
    }
    
    // Check email and password
    private func isValid(email:String) -> Bool{
        email.isEmpty == false && email.contains("@")
    }
    
    private func isValid(password:String) -> Bool {
        password.isEmpty == false && password.count >= 4
    }
    
    private func doLoginWith(email:String, password:String){
        loginUseCase.login(user: email, password: password) { [weak self] token in
            DispatchQueue.main.async {
                
                self?.loginViewState?(.loaded)
            }
        } onError: { [weak self] networkError in
            DispatchQueue.main.async {
                var errorMessage = "Error desconocido"
                switch networkError{
                case .malformedURL:
                    errorMessage = "malformed URL"
                case .dataFormatting:
                    errorMessage = "data Formatting"
                case .other:
                    errorMessage = "other"
                case .noData:
                    errorMessage = "no Data"
                case .errorCode(let error):
                    errorMessage = "Error Code: \(error?.description ?? "Unknown")"
                case .tokenFormatError:
                    errorMessage = "token Format Error"
                case .decoding:
                    errorMessage = "decoding"
                }
                self?.loginViewState?(.errorNetwork(errorMessage))
            }
        }

    }
}
