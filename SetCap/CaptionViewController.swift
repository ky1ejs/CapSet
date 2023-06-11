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
    let caption: String
    
    init(imageData: Data) {
        image = UIImage(data: imageData)!
        let ciImage = CIImage(data: imageData)!
        metadata = ImageMetadata(image: ciImage)
        caption = createCaption(with: metadata)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        let imageView = UIImageView(image: image)
        let captionLabel = UILabel()
        captionLabel.text = caption
        view.addSubview(imageView)
        view.addSubview(captionLabel)

        let buttonRounding: CGFloat = 4
        let buttonView = UIView()
        let copyButton = UIButton()
        let instagramButton = UIButton()
        copyButton.setTitle("Copy", for: .normal)
        copyButton.backgroundColor = .darkGray
        copyButton.setTitleColor(.white, for: .normal)
        copyButton.layer.cornerRadius = buttonRounding
        copyButton.addTarget(self, action: #selector(copyCaptionToClipboard), for: .touchUpInside)
        instagramButton.setTitle("Share to Instagram", for: .normal)
        instagramButton.backgroundColor = .purple
        instagramButton.setTitleColor(.white, for: .normal)
        instagramButton.layer.cornerRadius = buttonRounding

        buttonView.addSubview(copyButton)
        buttonView.addSubview(instagramButton)
        view.addSubview(buttonView)
        
        view.subviews.disableAutoConstraintTranslation()

        let buttonHeight: CGFloat = 38
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            captionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 12),

            copyButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            copyButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            copyButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            copyButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),

            instagramButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            instagramButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            instagramButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            instagramButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),
            instagramButton.leadingAnchor.constraint(equalTo: copyButton.trailingAnchor, constant: 12),
            instagramButton.widthAnchor.constraint(equalTo: copyButton.widthAnchor)
        ])
    }

    @objc private func copyCaptionToClipboard() {
        UIPasteboard.general.string = caption
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


func createCaption(with metadata: ImageMetadata) -> String {
    var template =  """
                    📷 %{body}
                    🔭 %{lens}
                    ⚙️ ƒ%{fNumber} | %{shutter_speed} | ISO %{iso}
                    """

    let metadata = [
        "body" : metadata.body,
        "lens" : metadata.lens,
        "fNumber" : metadata.fNumber?.stringValue,
        "shutter_speed" : metadata.shutterSpeed?.stringValue,
        "iso" : metadata.iso?.stringValue,
    ]

    let variables = template.matches(of: try! Regex("%{.*{!}!%!}"))
    variables.forEach { match in
        var key = String(template[match.range])
        key.removeAll { ["%", "{", "}"].contains($0) }
        let value = metadata[key]!!
        template.replaceSubrange(match.range, with: value)
    }

    return "Caption"

}
