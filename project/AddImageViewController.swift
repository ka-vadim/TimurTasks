import UIKit
import SnapKit

class AddImageViewController: UIViewController {
    private let imageDataTextField = UITextField()
    private let imageDataTypeSwitch = UISwitch()
    private let imageDataTypeLabel = UILabel()
    private let addImageBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedViews()
        setupAppearence()
        setupBehavior()
        setupLayout()
    }
}


// MARK: - Setup appearence
private extension AddImageViewController {
    func setupAppearence() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "Add image"
        
        addImageBarButton.title = "Add"
        
        imageDataTypeLabel.text = "Enter image systemName:"
        
        imageDataTypeSwitch.onTintColor = .link
        
        imageDataTextField.borderStyle = .roundedRect
        imageDataTextField.placeholder = "list.bullet.clipboard.fill"
        imageDataTextField.keyboardType = .URL
        imageDataTextField.clearButtonMode = .whileEditing
        imageDataTextField.autocapitalizationType = .none
        imageDataTextField.returnKeyType = .go
    }
}

// MARK: - Embed views
private extension AddImageViewController {
    func embedViews() {
        view.addSubview(imageDataTextField)
        view.addSubview(imageDataTypeLabel)
        view.addSubview(imageDataTypeSwitch)
    }
}

// MARK: - Setup layout
private extension AddImageViewController {
    func setupLayout() {
        imageDataTextField.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.layoutMarginsGuide.snp.horizontalEdges)
            $0.top.equalTo(imageDataTypeSwitch.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        
        imageDataTypeSwitch.snp.makeConstraints {
            $0.left.equalTo(imageDataTextField.snp.left)
            $0.centerY.equalTo(imageDataTypeLabel.snp.centerY)
        }
        
        imageDataTypeLabel.snp.makeConstraints {
            $0.left.equalTo(imageDataTypeSwitch.snp.right).offset(20)
            $0.top.equalTo(view.layoutMarginsGuide.snp.top).offset(20)
        }
    }
}

// MARK: - Setup Behavior
private extension AddImageViewController {
    func setupBehavior() {
        self.navigationItem.rightBarButtonItem = addImageBarButton
        
        imageDataTextField.delegate = self
        
        imageDataTypeSwitch.addTarget(self, action: #selector(changeEnterMode), for: .valueChanged)
        
        imageDataTextField.addTarget(self, action: #selector(checkTextFieldContent), for: .editingChanged)
        
        addImageBarButton.action = #selector(processTextFieldContent)
        addImageBarButton.isEnabled = false
    }
    
    @objc func processTextFieldContent() {
        //TODO: Add processing of text field content
        fatalError("This function hasn't been implemented!")
    }
    
    @objc func changeEnterMode() {
        if imageDataTypeSwitch.isOn {
            imageDataTypeLabel.text = "Enter image URL:"
            imageDataTextField.placeholder = "https://site.com/someimage.jpg"
        } else {
            imageDataTypeLabel.text = "Enter image systemName:"
            imageDataTextField.placeholder = "list.bullet.clipboard.fill"
        }
    }
    
    @objc func checkTextFieldContent(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            addImageBarButton.isEnabled = true
        } else {
            addImageBarButton.isEnabled = false
        }
    }
}

// MARK: - TextField delegate subscription
extension AddImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addImageBarButton.perform(addImageBarButton.action)
        return true
    }
}

#Preview {
    AddImageViewController()
}
