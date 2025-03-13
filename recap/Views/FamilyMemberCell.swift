//
//  FamilyMemberCell.swift
//  recap
//
//  Created by Diptayan Jash on 05/11/24.
//

import SDWebImage
import UIKit

class FamilyMemberCell: UICollectionViewCell {
    static let identifier = "FamilyMemberCell"
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50 // Make it perfectly circular
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.2).cgColor
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.FontandColors.titleFont
        label.textColor = Constants.FontandColors.titleColor
        label.textAlignment = .center
        return label
    }()

    private let relationshipLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.FontandColors.descriptionFont
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()

    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.FontandColors.descriptionFont
        label.textColor = Constants.FontandColors.descriptionColor
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Add shadow to the cell
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        
        // Add container view
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        [profileImageView, nameLabel, relationshipLabel, phoneLabel].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Profile image constraints
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            // Relationship label constraints
            relationshipLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            relationshipLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            relationshipLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            // Phone label constraints
            phoneLabel.topAnchor.constraint(equalTo: relationshipLabel.bottomAnchor, constant: 4),
            phoneLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            phoneLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
        ])
    }

    // MARK: - Configuration
    
    func configure(with member: FamilyMember) {
        nameLabel.text = member.name
        relationshipLabel.text = member.relationship
        phoneLabel.text = member.phone
        
        profileImageView.sd_setImage(
            with: URL(string: member.imageURL),
            placeholderImage: UIImage(systemName: "person.circle.fill"),
            options: .refreshCached
        )
    }
    
    // MARK: - Selection Animation
    
    override var isHighlighted: Bool {
        didSet {
            animateSelection(isHighlighted: isHighlighted)
        }
    }
    
    private func animateSelection(isHighlighted: Bool) {
        let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
        let shadowOpacity: Float = isHighlighted ? 0.2 : 0.1
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                self.transform = transform
                self.layer.shadowOpacity = shadowOpacity
                self.containerView.backgroundColor = isHighlighted ? .systemGray6 : .white
            }
        )
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update shadow for dark mode
        if traitCollection.userInterfaceStyle == .dark {
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 0.05
        } else {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
        }
    }
}
