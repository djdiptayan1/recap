//
//  PatientQuestionViewController.swift
//  recap
//
//  Created by s1834 on 08/02/25.
//

import UIKit
import FirebaseFirestore

protocol PatientQuestionsDelegate: AnyObject {
    func didSubmitAnswer(for question: Question)
}

class PatientQuestionViewController: UIViewController, NextQuestionCardViewDelegate {
    func didTapGoHome() {
        dismissCard()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func didTapNextQuestion() {
        dismissCard()
        moveToNextQuestion()
    }
    
    func didTapPlayGame() {
        dismissCard()
        let playGameVC = PlayGameViewController()
        navigationController?.pushViewController(playGameVC, animated: true)
    }
    
    func didTapReadArticle() {
        dismissCard()
        let articleVC = ArticleTableViewController()
        navigationController?.pushViewController(articleVC, animated: true)
    }
    
    weak var delegate: PatientQuestionsDelegate?
    var question: Question?
    var selectedOptionButton: UIButton?
    var verifiedUserDocID: String
    var currentQuestionIndex = 0
    var questions: [Question] = []
    
    let db = Firestore.firestore()
    
    private var blurEffectView: UIVisualEffectView?
    private var nextQuestionCardView: NextQuestionCardView?
    
    init(verifiedUserDocID: String) {
        self.verifiedUserDocID = verifiedUserDocID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let optionsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        button.layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep going — each one sharpens your mind and warms hearts!"
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BGs.GreyBG
        setupUI()
        fetchQuestionsFromFirestore()
    }
    
    private func setupUI() {
        view.addSubview(questionLabel)
        view.addSubview(questionImageView)
        view.addSubview(optionsContainer)
        view.addSubview(submitButton)
        view.addSubview(footerLabel)
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            questionImageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            questionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionImageView.widthAnchor.constraint(equalToConstant: 150),
            questionImageView.heightAnchor.constraint(equalToConstant: 150),
            
            optionsContainer.topAnchor.constraint(equalTo: questionImageView.bottomAnchor, constant: 5),
            optionsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 120),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            footerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            footerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func createOptionButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        selectedOptionButton?.layer.borderColor = UIColor.lightGray.cgColor
        selectedOptionButton?.backgroundColor = .white
        
        selectedOptionButton = sender
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        sender.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
    }
    
    @objc private func submitAnswer() {
        guard let selectedAnswer = selectedOptionButton?.title(for: .normal) else {
            print("❌❌ Error: No answer selected.")
            return
        }

        var currentQuestion = questions[currentQuestionIndex]
        guard let questionID = currentQuestion.id else {
            print("❌❌ Error: Question ID is missing.")
            return
        }

        currentQuestion.isAnswered = true
        currentQuestion.answers.append(selectedAnswer)

        let questionRef = db.collection("users").document(verifiedUserDocID).collection("questions").document(questionID)
        questionRef.updateData([
            "isAnswered": true,
            "answers": currentQuestion.answers,
            "lastAsked": Date()
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌❌ Error updating question: \(error.localizedDescription)")
            } else {
                self.updateStreakAndAnalytics()
                self.showNextQuestionConfirmation()
            }
        }
    }
    private func showNextQuestionConfirmation() {
        let alertController = UIAlertController(
            title: "Question Submitted",
            message: "Do you want to go to the next question or exit?",
            preferredStyle: .alert
        )
        
        // "Next Question" action
        let nextQuestionAction = UIAlertAction(title: "Next Question", style: .default) { [weak self] _ in
            self?.moveToNextQuestion()
        }
        
        // "Exit" action
        let exitAction = UIAlertAction(title: "Quit", style: .cancel) { [weak self] _ in
            self?.exitQuestionFlow()
        }
        
        // Add actions to alert
        alertController.addAction(nextQuestionAction)
        alertController.addAction(exitAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }

    
//    func showNextQuestionCardView() {
//        let blurEffect = UIBlurEffect(style: .dark)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView?.frame = view.bounds
//        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(blurEffectView!)
//        
//        nextQuestionCardView = NextQuestionCardView()
//        guard let nextQuestionCardView = nextQuestionCardView else { return }
//        nextQuestionCardView.delegate = self
//        nextQuestionCardView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nextQuestionCardView)
//        
//        NSLayoutConstraint.activate([
//            nextQuestionCardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            nextQuestionCardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            nextQuestionCardView.widthAnchor.constraint(equalToConstant: 300),
//            nextQuestionCardView.heightAnchor.constraint(equalToConstant: 200)
//        ])
//    }
    
    private func dismissCard() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView?.alpha = 0
            self.nextQuestionCardView?.alpha = 0
        }) { _ in
            self.blurEffectView?.removeFromSuperview()
            self.nextQuestionCardView?.removeFromSuperview()
        }
    }
    
    func showNoQuestionsReadyAlert() {
        let successVC = SuccessQuestionsViewController()
        successVC.modalPresentationStyle = .overFullScreen
        successVC.modalTransitionStyle = .crossDissolve
        
        // Set the exit action
        successVC.onExitTapped = { [weak self] in
            self?.exitQuestionFlow()
        }
        
        present(successVC, animated: true, completion: nil)
    }



    // MARK: - Exit the Question Flow
    private func exitQuestionFlow() {
        // Optionally, you can handle any exit logic (e.g., navigate to another screen or stop the process)
        print("Exiting question flow.")
        // For example, pop the current view controller if you're using a navigation controller
        navigationController?.popViewController(animated: true)
    }
    
    func moveToNextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            displayQuestion(questions[currentQuestionIndex])
        } else {
            showNoQuestionsReadyAlert()
        }
    }
    
    func displayQuestion(_ question: Question) {
        questionLabel.text = question.text
        
        if let imageString = question.image, let imageData = Data(base64Encoded: imageString) {
            questionImageView.image = UIImage(data: imageData)
        }
        
        optionsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let options = question.answerOptions
        for option in options {
            let button = createOptionButton(with: option)
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            optionsContainer.addArrangedSubview(button)
        }
    }
}
