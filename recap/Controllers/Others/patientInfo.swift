import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import UIKit

class patientInfo: UIViewController {
    weak var delegate: PatientInfoDelegate?

    private var storage: ProfileStorageProtocol

    init(storage: ProfileStorageProtocol = UserDefaultsStorageProfile.shared) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        storage = UserDefaultsStorageProfile.shared
        super.init(coder: coder)
    }

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    private let firstNameField = CustomTextField(placeholder: "First Name")
    private let lastNameField = CustomTextField(placeholder: "Last Name")
    private let dobField = CustomTextField(placeholder: "Date of Birth")
    private let sexField = CustomTextField(placeholder: "Sex")
    private let bloodGroupField = CustomTextField(placeholder: "Blood Group")
    private let stageField = CustomTextField(placeholder: "Stage")

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = Constants.ButtonStyle.DefaultButtonBackgroundColor
        button.layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
        button.titleLabel?.font = Constants.ButtonStyle.DefaultButtonFont
        button
            .setTitleColor(
                Constants.ButtonStyle.DefaultButtonTextColor,
                for: .normal
            )
        return button
    }()

    // MARK: - Properties

    private let imagePicker = UIImagePickerController()
    private let datePicker = UIDatePicker()
    private let sexPicker = UIPickerView()
    private let bloodGroupPicker = UIPickerView()
    private let stagePicker = UIPickerView()

    // Define options for the pickers
    let sexOptions = SexOptions.allCases.map { $0.rawValue }
    let bloodGroupOptions = BloodGroupOptions.allCases.map { $0.rawValue }
    let stageOptions = StageOptions.allCases.map { $0.rawValue }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        title = "Add Details"
        super.viewDidLoad()
        setupUI()
        setupImagePicker()
        setupPickers()
        setupTextFields()
        
        setupKeyboardNotifications()

        // Prevent dismissal by swipe down gesture
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        if let user = GIDSignIn.sharedInstance.currentUser,
           let imageURL = user.profile?.imageURL(withDimension: 200) {
            downloadImage(from: imageURL)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            removeKeyboardNotifications()
        }

    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }.resume()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Add scrollView to view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Setup scrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        [profileImageView, stackView, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [firstNameField, lastNameField, dobField, sexField, bloodGroupField, stageField].forEach {
            stackView.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)

        // Add tap gesture to dismiss keyboard when tapping outside text fields
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapToDismiss)

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }

    private func setupTextFields() {
        // Make text fields non-editable since we're using pickers
        dobField.isUserInteractionEnabled = true
        sexField.isUserInteractionEnabled = true
        bloodGroupField.isUserInteractionEnabled = true
        stageField.isUserInteractionEnabled = true

        // Optional: Add any additional text field customization
        firstNameField.autocapitalizationType = .words
        lastNameField.autocapitalizationType = .words

        // Prevent keyboard from showing up for picker fields
        dobField.inputView = datePicker
        sexField.inputView = sexPicker
        bloodGroupField.inputView = bloodGroupPicker
        stageField.inputView = stagePicker
    }

    private func setupPickers() {
        // Date Picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        dobField.inputView = datePicker

        // Sex Picker
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sexField.inputView = sexPicker

        // Blood Group Picker
        bloodGroupPicker.delegate = self
        bloodGroupPicker.dataSource = self
        bloodGroupField.inputView = bloodGroupPicker

        // Stage Picker
        stagePicker.delegate = self
        stagePicker.dataSource = self
        stageField.inputView = stagePicker

        // Add toolbar with Done button to all pickers
        [dobField, sexField, bloodGroupField, stageField].forEach {
            $0.inputAccessoryView = createToolbar()
        }
    }

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(dismissPicker)
        )
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)

        return toolbar
    }

    // MARK: - Actions

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        // Determine if the active text field is obscured by the keyboard
        var visibleRect = view.frame
        visibleRect.size.height -= keyboardFrame.height

        if let activeField = findFirstResponder() as? UITextField {
            let fieldRect = activeField.convert(activeField.bounds, to: scrollView)
            if !visibleRect.contains(fieldRect.origin) {
                scrollView.scrollRectToVisible(fieldRect, animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    private func findFirstResponder() -> UIView? {
        return findFirstResponder(in: view)
    }

    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }

        for subview in view.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }

        return nil
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func datePickerChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dobField.text = formatter.string(from: datePicker.date)
    }

    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    @objc private func profileImageTapped() {
        present(imagePicker, animated: true)
    }

    @objc private func saveButtonTapped() {
        guard let firstName = firstNameField.text, !firstName.isEmpty,
              let lastName = lastNameField.text, !lastName.isEmpty,
              let dob = dobField.text, !dob.isEmpty,
              let sex = sexField.text, !sex.isEmpty,
              let bloodGroup = bloodGroupField.text, !bloodGroup.isEmpty,
              let stage = stageField.text, !stage.isEmpty else {
            showLocalAlert(message: "Please fill in all fields")
            return
        }

        // Show loading indicator
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        saveButton.isEnabled = false

        guard let userId = Auth.auth().currentUser?.uid else {
            showLocalAlert(message: "User not logged in.")
            return
        }

        let profileImageURL = GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""

        let updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": dob,
            "sex": sex,
            "bloodGroup": bloodGroup,
            "stage": stage,
            "profileImageURL": profileImageURL,
        ]

        let db = Firestore.firestore()

        // Update existing document with new details
        db.collection("users").document(userId).updateData(updatedData) { [weak self] error in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
                self?.saveButton.isEnabled = true

                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                    self?.showLocalAlert(message: "Failed to save profile. Please try again.")
                } else {
                    print("Profile updated successfully")

                    UserDefaultsStorageProfile.shared.saveProfile(details: updatedData, image: nil) { success in
                        if success {
                            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKeys.hasPatientCompletedProfile)
                            UserDefaults.standard.synchronize()

                            if let delegate = self?.delegate {
                                delegate.didCompleteProfile()
                            } else {
                                // Fallback if delegate is not set
                                let tabBarVC = TabbarViewController()
                                guard let window = UIApplication.shared.windows.first else { return }
                                window.rootViewController = tabBarVC
                                window.makeKeyAndVisible()
                            }
                        } else {
                            self?.showLocalAlert(message: "Failed to save profile locally. Please try again.")
                        }
                    }
                }
            }
        }
    }

    // Local alert method that doesn't dismiss the view controller
    private func showLocalAlert(message: String) {
        let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension patientInfo: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension patientInfo: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Add validation logic for DOB, sex, and blood group if needed
        return true
    }
}

// MARK: - UIPickerViewDelegate & DataSource

extension patientInfo: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sexPicker:
            return sexOptions.count
        case bloodGroupPicker:
            return bloodGroupOptions.count
        case stagePicker:
            return stageOptions.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sexPicker:
            return sexOptions[row]
        case bloodGroupPicker:
            return bloodGroupOptions[row]
        case stagePicker:
            return stageOptions[row]
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case sexPicker:
            if let selectedSex = SexOptions(rawValue: sexOptions[row]) {
                sexField.text = selectedSex.rawValue
            }
        case bloodGroupPicker:
            if let selectedBloodGroup = BloodGroupOptions(rawValue: bloodGroupOptions[row]) {
                bloodGroupField.text = selectedBloodGroup.rawValue
            }
        case stagePicker:
            if let selectedStage = StageOptions(rawValue: stageOptions[row]) {
                stageField.text = selectedStage.rawValue
            }
        default:
            break
        }
    }
}

// MARK: - Custom TextField

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }

    private func setup() {
        backgroundColor = .systemGray6
        layer.cornerRadius = Constants.CardSize.DefaultCardCornerRadius
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        leftViewMode = .always
        heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
