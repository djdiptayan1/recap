//
//  QuestionsCardView.swift.swift
//  recap
//
//  Created by admin70 on 11/02/25.
//
import UIKit

class QuestionsCardView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let separatorView = UIView()
    private let arrowImageView = UIImageView()
    
    var navigateToDetail: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupTapGesture()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
        layer.shadowColor = Constants.FontandColors.defaultshadowColor
        layer.shadowOpacity = Float(Constants.FontandColors.defaultshadowOpacity)
        layer.shadowOffset = Constants.FontandColors.defaultshadowOffset
        layer.shadowRadius = Constants.FontandColors.defaultshadowRadius
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.image = UIImage(named: "oldMan")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        titleLabel.text = "Questions"
        titleLabel.font = Constants.FontandColors.titleFont
        titleLabel.textColor = Constants.FontandColors.titleColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        arrowImageView.image = UIImage(
            systemName: Constants.FontandColors.chevronName
        )
        arrowImageView.tintColor = Constants.FontandColors.chevronColor
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowImageView)
        
        separatorView.backgroundColor = .systemGray4
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
        
        descriptionLabel.text = "Boost your memory by up to 20%."
        descriptionLabel.font = Constants.FontandColors.descriptionFont
        descriptionLabel.textColor = Constants.FontandColors.descriptionColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate(
[
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor
                .constraint(
                    equalTo: iconImageView.trailingAnchor,
                    constant: Constants
                        .paddingKeys
                        .DefaultPaddingLeft),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: Constants
                .paddingKeys
                .DefaultPaddingRight),
            
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            arrowImageView.heightAnchor.constraint(equalToConstant: 22),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separatorView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants
                .paddingKeys
                .DefaultPaddingLeft),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants
                .paddingKeys
                .DefaultPaddingRight),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants
                .paddingKeys
                .DefaultPaddingLeft),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ]
)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapCard() {
        navigateToDetail?()
    }
}

#Preview {
    QuestionsCardView()
}
