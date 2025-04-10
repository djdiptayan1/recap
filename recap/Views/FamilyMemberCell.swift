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
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        // Remove circular shape to make it more gallery-like
        return imageView
    }()

    private let overlayGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        gradient.locations = [0.5, 1.0]
        return gradient
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let relationshipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.alpha = 0.9
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
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 16
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        
        // Add container view
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add image view
        containerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add gradient layer
        containerView.layer.addSublayer(overlayGradient)
        
        // Add text labels
        [nameLabel, relationshipLabel].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Container view constraints - fill the entire cell
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Profile image constraints - fill the container
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Text labels positioned at the bottom with padding
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: relationshipLabel.topAnchor, constant: -4),
            
            relationshipLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            relationshipLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            relationshipLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame
        overlayGradient.frame = bounds
    }

    // MARK: - Configuration
    
    func configure(with member: FamilyMember) {
        nameLabel.text = member.name
        relationshipLabel.text = member.relationship
        
        profileImageView.sd_setImage(
            with: URL(string: member.imageURL),
            placeholderImage: UIImage(systemName: "person.fill"),
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
        let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.98, y: 0.98) : .identity
        let shadowOpacity: Float = isHighlighted ? 0.2 : 0.15
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                self.transform = transform
                self.layer.shadowOpacity = shadowOpacity
            }
        )
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update shadow for dark mode
        if traitCollection.userInterfaceStyle == .dark {
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 0.08
        } else {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.15
        }
    }
}
