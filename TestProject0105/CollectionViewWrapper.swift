import SwiftUI
import UIKit

struct CollectionViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CollectionViewController {
        return CollectionViewController()
    }
    
    func updateUIViewController(_ uiViewController: CollectionViewController, context: Context) {
    }
}
