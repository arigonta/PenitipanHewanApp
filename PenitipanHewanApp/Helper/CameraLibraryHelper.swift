//
//  CameraLibraryHelper.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 01/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

protocol CameraLibraryHelperDelegate: class {
    func resultCamera(image: UIImage, base64: String)
}

class CameraLibraryHelper: NSObject {
    
    var viewController: UIViewController?
    weak var delegate: CameraLibraryHelperDelegate?
    
    init(_ screen: UIViewController, _ delegate: CameraLibraryHelperDelegate?) {
        self.viewController = screen
        self.delegate = delegate
    }
    
    public func checkAndOpenCamera() {
        let cameraMediaType: AVMediaType = .video
        let authorizeStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch authorizeStatus {
        case .authorized:
            presentCamera()
        case .notDetermined:
            requestCameraPermission()
        case .denied:
            presentAlert("Buka pengaturan untuk izinkan akses kamera")
        default:
            break
        }
    }
    
    public func checkAndOpenlibrary() {
        let photosPermission = PHPhotoLibrary.authorizationStatus()
        
        switch photosPermission {
        case .authorized:
            presentPhotoLibrary()
        case .notDetermined:
            requestPhotoLibraryPermission()
        case .denied:
            presentAlert("Buka pengaturan untuk izinkan akses photo library")
            
        default:
            break
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self, granted else { return }
            self.presentCamera()
        }
    }
    
    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] (granted) in
            guard let self = self else { return }
            
            if granted == .authorized {
                self.presentPhotoLibrary()
            }
        }
    }
    
    private func presentAlert(_ message: String) {
        guard let screen = self.viewController else { return }
        var modelAction = [AlertActionModel]()
        let action1 = AlertActionModel("Tidak Boleh", .default)
        let action2 = AlertActionModel("Buka Pengaturan", .default) { [weak self] _ in
            guard let self = self else { return }
            self.openSetting()
        }
        modelAction.append(action1)
        modelAction.append(action2)
        let modelAlert = AlertModel("", message, .alert, modelAction)
        screen.setAlert(data: modelAlert)
        
    }
    
    private func openSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: .init(), completionHandler: nil)
    }
    
    private func presentCamera() {
        guard let screen = self.viewController else { return }
        let cameraVC = UIImagePickerController()
        cameraVC.sourceType = .camera
        cameraVC.allowsEditing = true
        cameraVC.delegate = self
        screen.present(cameraVC, animated: true, completion: nil)
    }
    
    private func presentPhotoLibrary() {
        guard let screen = self.viewController else { return }
        let photoLibraryVC = UIImagePickerController()
        photoLibraryVC.sourceType = .photoLibrary
        photoLibraryVC.allowsEditing = true
        photoLibraryVC.delegate = self
        screen.present(photoLibraryVC, animated: true, completion: nil)
    }
    
    private func convertBase64(image: UIImage) -> String {
        let data = image.jpegData(compressionQuality: 0.2)
        let base64 = data?.base64EncodedString()
        return base64 ?? ""
    }
}

extension CameraLibraryHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        let base64 = convertBase64(image: image)
        delegate?.resultCamera(image: image, base64: base64)
    }
}
