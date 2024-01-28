//
//  HomeTableViewController.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/24/24.
//

import UIKit

final class HomeTableViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var heroesTableView: UITableView!
    
    private var homeViewModel: HomeViewModel
    
    // MARK: INIT
    init(homeViewModel: HomeViewModel = HomeViewModel()){
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
        heroesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
        homeViewModel.loadHeroes()
        setObservers() 
        
    }
    
    private func setObservers(){
        homeViewModel.homeStatusLoad = { [weak self] status in
                switch status {
                case .loading:
                    print("Home Loading")
                case .loaded:
                    self?.heroesTableView.reloadData()
                case .error:
                    print("Home Error")
                case .none:
                    print("Home none")
                }
            }
    }


}

extension HomeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let heroName = homeViewModel.dataHeroes[indexPath.row].name
        let detailViewController = DetailHeroViewController(heroName: heroName)
        navigationController?.show(detailViewController,sender: nil)
    }
    
}

extension HomeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.dataHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = heroesTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        cell.textLabel?.text = homeViewModel.dataHeroes[indexPath.row].name
        return cell
    }
    
}


