//
//  DetailHeroViewController.swift
//  AppPatronesRobert
//
//  Created by Robert Aguero on 1/28/24.
//

import UIKit

final class DetailHeroViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    
    @IBOutlet weak var heroTransformationButton: UIButton!
    // MARK: Actions
    @IBAction func didTapTransformationButton(_ sender: Any) {
        let tranformationsViewController = HeroTransformationsViewController(id:self.heroId)
        navigationController?.show(tranformationsViewController,sender: nil)
        
    }
    
    // MARK: - Model
    private let heroName: String
    private var detailHeroViewModel: DetailHeroViewModel
    private var heroId: String
    
    // MARK: - Initializers
    init(heroName: String, detailHeroViewModel: DetailHeroViewModel = DetailHeroViewModel(heroName: "",hero: HeroModel(id: "", name: "", description: "", photo: "", favorite: false))){
        self.heroName = heroName
        self.detailHeroViewModel = detailHeroViewModel
        self.heroId = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        detailHeroViewModel.loadHero(heroName: heroName)
        setObservers()
        
        // Do any additional setup after loading the view.
    }
    
    private func setObservers(){
        detailHeroViewModel.detailHeroStatusLoad = { [weak self] status in
                switch status {
                case .loading:
                    print("Detail Hero Loading")
                case .loaded:
                    self?.configureView()
                case .error:
                    print("Detail Hero Error")
                case .none:
                    print("Detail Hero")
                }
            }
    }


}

// MARK: View configuration
private extension DetailHeroViewController {
    func configureView(){
        heroId = detailHeroViewModel.hero.id
        heroNameLabel.text = detailHeroViewModel.hero.name
        heroDescriptionLabel.text = detailHeroViewModel.hero.description
        guard let imageURL = URL(string: detailHeroViewModel.hero.photo) else {
            return
        }
        
        heroImageView.setImage(url: imageURL)
        heroImageView.layer.cornerRadius = heroImageView.bounds.size.width / 2.0
        
         
    }
}
