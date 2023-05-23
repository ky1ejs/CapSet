//
//  CaptionViewController.swift
//  SetCap
//
//  Created by Kyle Satti on 5/22/23.
//

import UIKit

class CaptionViewController: UIViewController {
    let image: UIImage
    let metadata: ImageMetadata
    
    init(imageData: Data) {
        image = UIImage(data: imageData)!
        let ciImage = CIImage(data: imageData)!
        metadata = ImageMetadata(image: ciImage)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        let imageView = UIImageView(image: image)
        let captionLabel = UILabel()
        
        view.addSubview(imageView)
        view.addSubview(captionLabel)
        
        view.subviews.disableAutoConstraintTranslation()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            captionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
}

extension Array where Element == UIView {
    func disableAutoConstraintTranslation() {
        forEach(disableTranslation)
    }
    
    private func disableTranslation(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.subviews.forEach(disableTranslation)
    }
}
