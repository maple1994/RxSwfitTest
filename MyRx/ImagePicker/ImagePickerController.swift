//
//  ImagePickerController.swift
//  MyRx
//
//  Created by Maple on 2017/9/18.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class ImagePickerController: UIViewController {

    @IBOutlet weak var crop: UIButton!
    @IBOutlet weak var gallery: UIButton!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        camera.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self, animated: true, configureImagePicker: { (picker) in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                })
                    .flatMap{ $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
        }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
        }
            .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
        
        gallery.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self, animated: true, configureImagePicker: { (picker) in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                })
                    .flatMap {
                        $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
        }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
        }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        crop.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self, animated: true, configureImagePicker: { (picker) in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                })
                    .flatMap {
                        $0.rx.didFinishPickingMediaWithInfo
                    }
                    .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
    

}













