import UIKit

final class DetailViewController: UIViewController {

    var item: FavoriteItem?   
    @IBOutlet weak var paintingImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else { return }

        title = item.title
        paintingImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.details

        let rating = max(0, min(5, item.rating))
        for (index, view) in ratingStack.arrangedSubviews.enumerated() {
            guard let star = view as? UIImageView else { continue }
            star.image = UIImage(systemName: index < rating ? "star.fill" : "star")
        }
    }
}
