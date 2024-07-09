import UIKit

struct Fears: Decodable, Encodable {
    let id: String
    var triggers: [String]
    var support: [String]
}
import UIKit

protocol FearsViewDelegate: AnyObject {
    func didTapDeleteButton(on cell: FearsView)
}

class FearsView: UICollectionViewCell {
    
    static let reuseIdentifier = "FearsViewReuse"
    weak var delegate: FearsViewDelegate?
    
    private var button = UIButton()
    
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
        setUpButton()
        
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
    }
    
    func setUpLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
        ])
    }
    
    func setUpButton() {
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(del), for: .touchUpInside)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        button.widthAnchor.constraint(equalToConstant: 30),
        button.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func del() {
        delegate?.didTapDeleteButton(on: self)
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
