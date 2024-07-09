import UIKit
import SwiftUI

class HostingController: UIHostingController<AnyView> {
    override init(rootView: AnyView) {
        super.init(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class FearDetailView: UIViewController {
    
    // MARK: - Properties
    var fears: Fears?
    weak var delegate: FearDetailViewDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let triggersLabel = UILabel()
    private let supportsLabel = UILabel()
    private let buttonT = UIButton()
    private let buttonS = UIButton()
    
    private var chatContainerView: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupScrollView()
        setupContentView()
        setupViews()
        setupChatbotView()
        populateData()
    }
    
    private func setupNavigationBar() {
        title = "Fear Details"
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        if let fears = fears {
            delegate?.didUpdateFear(fears)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViews() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        triggersLabel.font = UIFont.systemFont(ofSize: 18)
        triggersLabel.numberOfLines = 0
        triggersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        supportsLabel.font = UIFont.systemFont(ofSize: 18)
        supportsLabel.numberOfLines = 0
        supportsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonT.setTitle("Add", for: .normal)
        buttonT.setTitleColor(.white, for: .normal)
        buttonT.backgroundColor = .red
        buttonT.layer.cornerRadius = 10
        buttonT.addTarget(self, action: #selector(addTrigger), for: .touchUpInside)
        buttonT.translatesAutoresizingMaskIntoConstraints = false
        
        buttonS.setTitle("Add", for: .normal)
        buttonS.setTitleColor(.white, for: .normal)
        buttonS.backgroundColor = .red
        buttonS.layer.cornerRadius = 10
        buttonS.addTarget(self, action: #selector(addSupport), for: .touchUpInside)
        buttonS.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(triggersLabel)
        contentView.addSubview(supportsLabel)
        contentView.addSubview(buttonT)
        contentView.addSubview(buttonS)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            triggersLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            triggersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            triggersLabel.trailingAnchor.constraint(lessThanOrEqualTo: buttonT.leadingAnchor, constant: -10),

            buttonT.topAnchor.constraint(equalTo: triggersLabel.topAnchor),
            buttonT.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            supportsLabel.topAnchor.constraint(equalTo: triggersLabel.bottomAnchor, constant: 20),
            supportsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            supportsLabel.trailingAnchor.constraint(lessThanOrEqualTo: buttonS.leadingAnchor, constant: -10),

            buttonS.topAnchor.constraint(equalTo: supportsLabel.topAnchor),
            buttonS.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            supportsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Add bottom constraint to contentView
        ])
    }
    
    @objc private func addTrigger() {
        let alert = UIAlertController(title: "Add trigger", message: "What is your trigger?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "What is your trigger?"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let triggerName = alert.textFields?.first?.text,
                  !triggerName.isEmpty else { return }
            self.fears?.triggers.append(triggerName)
            self.updateTriggersLabel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateTriggersLabel() {
        guard let fears = fears else { return }
        triggersLabel.text = "Triggers:\n" + "      -" + fears.triggers.joined(separator: "\n" + "      -")
        delegate?.didUpdateFear(fears)
    }
    
    @objc private func addSupport() {
        let alert = UIAlertController(title: "Add calming thought", message: "What is a calming thought?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "What is a calming thought?"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let supportName = alert.textFields?.first?.text,
                  !supportName.isEmpty else { return }
            self.fears?.support.append(supportName)
            self.updateSupportsLabel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateSupportsLabel() {
        guard let fears = fears else { return }
        supportsLabel.text = "Supports:\n" + "      -" + fears.support.joined(separator: "\n" + "      -")
        delegate?.didUpdateFear(fears)
    }
    
    private func populateData() {
        guard let fears = fears else { return }
        titleLabel.text = fears.id
        
        triggersLabel.text = "Triggers:\n" + "      -" + fears.triggers.joined(separator: "\n" + "      -")
        supportsLabel.text = "Supports: \n" + "     -" + fears.support.joined(separator: "\n" + "       -")
    }
    

    private func setupChatbotView() {
        chatContainerView = UIView()
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chatContainerView)
        
        let fearId = fears?.id ?? ""
        let hostingController = UIHostingController(rootView: ChatbotView(fearId: fearId))
        addChild(hostingController)
        chatContainerView.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chatContainerView.topAnchor.constraint(equalTo: supportsLabel.bottomAnchor, constant: 20),
            chatContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chatContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            chatContainerView.heightAnchor.constraint(equalToConstant: 500),
            
            hostingController.view.topAnchor.constraint(equalTo: chatContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: chatContainerView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: chatContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: chatContainerView.trailingAnchor)
        ])
    }

}
