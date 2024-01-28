//
//  LoginViewController.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/23/24.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    
    private var viewModel:LoginViewModel
    
    // MARK: Inits
    init(viewModel: LoginViewModel = LoginViewModel()){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        // Do any additional setup after loading the view.
    }
    
    // MARK: IBActions
    
    @IBAction func onLoginButtonTap(_ sender: Any) {
        viewModel.onLoginButton(email:emailTextField.text, password: passwordTextField.text)
    }
    
}

// MARK: Extension
extension LoginViewController{
    private func setObservers() {
        viewModel.loginViewState = {[weak self] status in
            switch status {
            case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
            case .loaded:
                self?.loadingView.isHidden = true
                self?.navigateToHome()
            case .showErrorEmail(let error):
                self?.errorEmailLabel.text = error
                self?.errorEmailLabel.isHidden = (error==nil || error?.isEmpty == true)
            case .showErrorPassword(let error):
                self?.errorPasswordLabel.text = error
                self?.errorPasswordLabel.isHidden = (error==nil || error?.isEmpty == true)
            case .errorNetwork(let errorMessage):
                self?.loadingView.isHidden = true
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    // MARK: - Navigate
    private func navigateToHome() {
        let homeViewModel = HomeViewModel(homeUseCase: HomeUseCase())
        let nextViewController = HomeTableViewController(homeViewModel: homeViewModel)
        navigationController?.setViewControllers([nextViewController], animated: true)
    }
    
    // MARK: - Alert
    private func showAlert(message: String){
        let alertController = UIAlertController(title: "ERROR NETWORK", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController,animated: true, completion: nil)
    }
}
