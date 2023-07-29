//
//  ViewController.swift
//  SetCap
//
//  Created by Kyle Satti on 5/22/23.
//

import UIKit
import PhotosUI
import SetCapUIKit
import SwiftUI

@MainActor
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImagePicker()
    }


    private func showImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
        
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        _ = results.first!.itemProvider.loadDataRepresentation(for: .jpeg) { data, error in
            DispatchQueue.main.async {
                let captionVC = UIHostingController(rootView: CaptionPickerView())
                self.dismiss(animated:true) {
                    self.navigationController?.pushViewController(captionVC, animated: true)
                }
            }
        }
    }
    
    
}

