import SwiftUI
import UIKit

struct CollectionViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let collectionViewController = CollectionViewController()
        let navigationController = UINavigationController(rootViewController: collectionViewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {

    }
}
