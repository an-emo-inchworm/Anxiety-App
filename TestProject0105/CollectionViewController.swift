import UIKit

class CollectionViewController: UICollectionViewController, FearsViewDelegate {
    
    private var collectionView1: UICollectionView!
//    var allFears: [Fears] = []
    
    // MARK: - Properties (data)
    var dummydata = [
        Fears(id: "Fear1", triggers: ["trigger 1"], support: ["support 1"]),
        Fears(id: "Fear2", triggers: ["trigger 2", "trigger 3"], support: ["support 2"]),
        Fears(id: "Fear3", triggers: ["trigger 4", "trigger 5"], support: ["support 3", "support 4", "support 5"]),
    ]
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 300)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.white
            setupAddButton()
            setupTitleLabel()
            setupCollectionView()
            collectionView.alwaysBounceVertical = true

            dummydata = loadFearsFromUserDefaults()
    }
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "New Fear", message: "Name of Fear", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Fear name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let fearName = alert.textFields?.first?.text, !fearName.isEmpty else { return }
            self?.addNewFear(named: fearName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func addNewFear(named name: String) {
        let newFear = Fears(id: name, triggers: [], support: [])
        dummydata.append(newFear)
        collectionView.reloadData()
        saveFearsToUserDefaults(fears: dummydata)
    }
    
    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "My Fears"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func saveFearsToUserDefaults(fears: [Fears]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(fears) {
            UserDefaults.standard.set(encoded, forKey: "fears")
        }
    }

    func loadFearsFromUserDefaults() -> [Fears] {
        if let savedFears = UserDefaults.standard.object(forKey: "fears") as? Data {
            let decoder = JSONDecoder()
            if let loadedFears = try? decoder.decode([Fears].self, from: savedFears) {
                return loadedFears
            }
        }
        return []
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.itemSize = CGSize(width: 200, height: 200)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FearsView.self, forCellWithReuseIdentifier: FearsView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummydata.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FearsView.reuseIdentifier, for: indexPath) as! FearsView
        cell.configure(with: dummydata[indexPath.row].id)
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = dummydata[indexPath.item]
        let detailViewController = FearDetailView()
        detailViewController.fears = selected
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didTapDeleteButton(on cell: FearsView) {
        if let indexPath = collectionView.indexPath(for: cell) {
            dummydata.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
            saveFearsToUserDefaults(fears: dummydata)
        }
    }
}

protocol FearDetailViewDelegate: AnyObject {
    func didUpdateFear(_ fear: Fears)
}
extension CollectionViewController: FearDetailViewDelegate {
    func didUpdateFear(_ fear: Fears) {
        if let index = dummydata.firstIndex(where: { $0.id == fear.id }) {
            dummydata[index] = fear
            collectionView.reloadData()
            saveFearsToUserDefaults(fears: dummydata)
        }
    }
}
