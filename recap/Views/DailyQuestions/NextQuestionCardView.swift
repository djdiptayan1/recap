//
//  NextQuestionCardView.swift
//  recap
//
//  Created by s1834 on 13/03/25.
//

import UIKit

protocol NextQuestionCardViewDelegate: AnyObject {
    func didTapNextQuestion()
    func didTapPlayGame()
    func didTapReadArticle()
    func didTapGoHome()
}

class NextQuestionCardView: UIView {

    weak var delegate: NextQuestionCardViewDelegate?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What would you like to do next?"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nextQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next Question", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let playGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play Game", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let readArticleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read Article", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let goHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go Home", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 18
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 8
        clipsToBounds = false
        
        let headerStack = UIStackView(arrangedSubviews: [logoImageView, titleLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonsStack = UIStackView(arrangedSubviews: [nextQuestionButton, playGameButton, readArticleButton, goHomeButton])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 12
        buttonsStack.distribution = .fillEqually
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [headerStack, buttonsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            nextQuestionButton.heightAnchor.constraint(equalToConstant: 50),
            playGameButton.heightAnchor.constraint(equalToConstant: 50),
            readArticleButton.heightAnchor.constraint(equalToConstant: 50),
            goHomeButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 50)
        ])

        nextQuestionButton.addTarget(self, action: #selector(didTapNextQuestion), for: .touchUpInside)
        playGameButton.addTarget(self, action: #selector(didTapPlayGame), for: .touchUpInside)
        readArticleButton.addTarget(self, action: #selector(didTapReadArticle), for: .touchUpInside)
        goHomeButton.addTarget(self, action: #selector(didTapGoHome), for: .touchUpInside)
    }

    @objc private func didTapNextQuestion() {
        delegate?.didTapNextQuestion()
    }

    @objc private func didTapPlayGame() {
        delegate?.didTapPlayGame()
    }

    @objc private func didTapReadArticle() {
        delegate?.didTapReadArticle()
    }
    
    @objc private func didTapGoHome() {
        delegate?.didTapGoHome()
    }
}
