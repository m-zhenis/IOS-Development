//
//  ViewController.swift
//  serials
//
//  Created by Malika Zhenis on 14.10.2026.
//

import UIKit

struct Favorite {
    let imageName: String
    let title: String
    let description: String
}

class ViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    let favorites: [Favorite] = [
        Favorite(imageName: "hiddenLove", title: "Hidden Love", description: "A childhood crush grows into true love"),
        Favorite(imageName: "loveBetweenLines", title: "Love Between Lines", description: "A mystery game blurs the lines between virtual and real romance"),
        Favorite(imageName: "queensGambit", title: "The Queen's Gambit", description: "Chess genius, obsession, and overcoming personal addiction"),
        Favorite(imageName: "strangerThings", title: "Stranger Things", description: "Small-town secrets, dimensional monsters, and brave kids"),
        Favorite(imageName: "strongWoman", title: "Strong Woman Do Bong Soon", description: "A girl with superhuman strength learns to control her power"),
        Favorite(imageName: "susPartner", title: "Suspicious Partner", description: "Lawyers solving a twisted murder case while falling in love"),
        Favorite(imageName: "theBridgerton", title: "Bridgerton 4", description: "London's high society, lavish balls, and hidden identities"),
        Favorite(imageName: "theCrown", title: "The Crown", description: "An inside look into the life of the British royal family"),
        Favorite(imageName: "theFairy", title: "Gyeonwoo and Fairy", description: "A high school shaman fights fate to save her doomed crush"),
        Favorite(imageName: "theFirstFrost", title: "The First Frost", description: "A long-lost first love reuniting after years apart")
    ]

    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        showRandomFavorite()
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        showRandomFavorite()
    }

    func showRandomFavorite() {
        var newIndex = favorites.indices.randomElement()!
        while newIndex == currentIndex && favorites.count > 1 {
            newIndex = favorites.indices.randomElement()!
        }
        currentIndex = newIndex

        let favorite = favorites[currentIndex]
        poster.image = UIImage(named: favorite.imageName)
        titleLabel.text = favorite.title
        descriptionLabel.text = favorite.description
    }
}
