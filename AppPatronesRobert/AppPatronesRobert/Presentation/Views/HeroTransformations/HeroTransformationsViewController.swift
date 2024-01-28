//
//  HeroTransformationsViewController.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import UIKit

class HeroTransformationsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var transformationsTableView: UITableView!
    
    private var transformationsViewModel: HeroTransformationsViewModel
    private var id: String
    
    // MARK: INIT
    init (id:String , transformationsViewModel: HeroTransformationsViewModel = HeroTransformationsViewModel()){
        self.id = id
        self.transformationsViewModel = transformationsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        transformationsTableView.delegate = self
        transformationsTableView.dataSource = self
        transformationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransformationCell")
        transformationsViewModel.loadTransformations(id:self.id)
        setObservers()
        
    }
    
    private func setObservers(){
        transformationsViewModel.transformationsStatusLoad = { [weak self] status in
                switch status {
                case .loading:
                    print("Transformations Loading")
                case .loaded:
                    self?.transformationsTableView.reloadData()
                case .error:
                    print("Transformations Error")
                case .none:
                    print("Transformations none")
                }
            }
    }

}

extension HeroTransformationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}

extension HeroTransformationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transformationsViewModel.dataTransformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transformationsTableView.dequeueReusableCell(withIdentifier: "TransformationCell", for: indexPath)
        cell.textLabel?.text = transformationsViewModel.dataTransformations[indexPath.row].name
        return cell
    }
    
}
