 import UIKit

 class GamesTableViewCell: UITableViewCell {
    static let identifier = "GamesTableViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
        view.layer.shadowColor = Constants.FontandColors.defaultshadowColor
        view.layer.shadowOpacity = Float(
            Constants.FontandColors.defaultshadowOpacity
        )
        view.layer.shadowOffset = Constants.FontandColors.defaultshadowOffset
        view.layer.shadowRadius = Constants.FontandColors.defaultshadowRadius
        return view
    }()

    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.FontandColors.titleFont
        label.textColor = Constants.FontandColors.titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let accessoryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.FontandColors.chevronName)
        imageView.tintColor = Constants.FontandColors.chevronColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.FontandColors.descriptionFont
        label.textColor = Constants.FontandColors.descriptionColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Add subviews to cell
        contentView.addSubview(containerView)
        containerView.addSubview(gameImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(accessoryIcon)
        containerView.addSubview(dividerLine)
        containerView.addSubview(descriptionLabel)

        // Enable Auto Layout
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Set up constraints
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.paddingKeys.DefaultPaddingTop),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.paddingKeys.DefaultPaddingLeft),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.paddingKeys.DefaultPaddingRight),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.paddingKeys.DefaultPaddingBottom),

            // Image view constraints
            gameImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            gameImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            gameImageView.widthAnchor.constraint(equalToConstant: 60),
            gameImageView.heightAnchor.constraint(equalToConstant: 60),

            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: Constants.paddingKeys.DefaultPaddingLeft),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: accessoryIcon.leadingAnchor, constant: Constants.paddingKeys.DefaultPaddingRight),

            // Accessory icon constraints
            accessoryIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            accessoryIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            accessoryIcon.widthAnchor.constraint(equalToConstant: 14),
            accessoryIcon.heightAnchor.constraint(equalToConstant: 22),

            // Divider line constraints
            dividerLine.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            dividerLine.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: Constants.paddingKeys.DefaultPaddingLeft),
            dividerLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.paddingKeys.DefaultPaddingRight),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),

            // Description label constraints
            descriptionLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: Constants.paddingKeys.DefaultPaddingLeft),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }

    func configure(with game: Games) {
        gameImageView.image = UIImage(named: game.imageName)
        nameLabel.text = game.name
        descriptionLabel.text = game.description
    }
 }
 #Preview{
    GamesTableViewCell()
 }


//import UIKit
//
//class GamesTableViewCell: UITableViewCell {
//    static let identifier = "GamesTableViewCell"
//
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
//        view.layer.shadowColor = Constants.FontandColors.defaultshadowColor
//        view.layer.shadowOpacity = Float(
//            Constants.FontandColors.defaultshadowOpacity
//        )
//        view.layer.shadowOffset = Constants.FontandColors.defaultshadowOffset
//        view.layer.shadowRadius = Constants.FontandColors.defaultshadowRadius
//        return view
//    }()
//
//    private let gameImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let dividerLine: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGray4
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = Constants.FontandColors.titleFont
//        label.textColor = Constants.FontandColors.titleColor
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let accessoryIcon: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "chevron.right")
//        imageView.tintColor = .systemGray
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        selectionStyle = .none
//        backgroundColor = .clear
//        contentView.backgroundColor = .clear
//
//        // Add subviews to cell
//        contentView.addSubview(containerView)
//        containerView.addSubview(gameImageView)
//        containerView.addSubview(dividerLine)
//        containerView.addSubview(nameLabel)
//        containerView.addSubview(accessoryIcon)
//
//        // Enable Auto Layout
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        // Set up constraints
//        NSLayoutConstraint.activate([
//            // Container view (unchanged)
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//
//            // Image view (centered horizontally)
//            gameImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
//            gameImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            gameImageView.widthAnchor.constraint(equalToConstant: 140),
//            gameImageView.heightAnchor.constraint(equalToConstant: 140),
//
//            // Divider line
//            dividerLine.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 16),
//            dividerLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            dividerLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            dividerLine.heightAnchor.constraint(equalToConstant: 1),
//
//            // Name label (centered below divider)
//            nameLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 16),
//            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
//
//            // Accessory icon
//            accessoryIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
//            accessoryIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            accessoryIcon.widthAnchor.constraint(equalToConstant: 20),
//            accessoryIcon.heightAnchor.constraint(equalToConstant: 20),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        gameImageView.image = nil
//        nameLabel.text = "Default Game Name"
//    }
//
//    func configure(with game: Games) {
//        gameImageView.image = UIImage(named: game.imageName)
//        nameLabel.text = game.name
//        // Debug print to see what's being set
//        print("Configuring cell with game name: \(game.name)")
//    }
//}
//
//#Preview {
//    GamesTableViewCell()
//}
