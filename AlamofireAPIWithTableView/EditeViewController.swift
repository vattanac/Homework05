//
//  EditeViewController.swift
//  AlamofireAPIWithTableView
//
//  Created by Vattanac on 12/17/18.
//  Copyright © 2018 vattanac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class EditeViewController: UIViewController{

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var uploadTitle: UITextField!
    @IBOutlet weak var uploadDescription: UITextView!
   
    var temImage:UIImage?
    var isSelectImage = false
    
    @IBAction func saveData(_ sender: Any) {
        if isSelectImage {
            uploadData(image: temImage!)
            print("saved")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    static let shared = EditeViewController()
    
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImage.image = #imageLiteral(resourceName: "noimage")
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        uploadImage.isUserInteractionEnabled = true
        uploadImage.addGestureRecognizer(singleTap)
        
    }
    
    //Action
    @objc func tapDetected() {
        showActionSheet(vc: self)
        print("camera")
    }
    
    //MARK:Camera
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    //MARK:photoLibrary
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController) {
        self == vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


extension EditeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func Uploadfile(){
//        let parameter: Parameters = [
//            
//        ]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
            uploadImage.image = image
            
            temImage = image
            isSelectImage = true
            
        }else{
            print("Something went wrong")
            isSelectImage = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadData(image:UIImage){
        let url = "http://api-ams.me/v1/api/uploadfile/single"
        let header = ["Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
                      "Content-Type":"application/json",
                      "Accept": "application/json"]

        Alamofire.upload(multipartFormData: { (form) in
            form.append(image.jpegData(compressionQuality: 0.1)!, withName: "FILE", fileName : ".jpg", mimeType: "image/jpeg")
        }, to: url, encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard response.result.isSuccess else{
                        print("error")
                        return
                    }
                   
                    let json = response.result.value as! [String:Any]
                    let imageurlgenerated = json["DATA"]
                    print(imageurlgenerated!)
                   
                    let parameter : Parameters = [
                        "TITLE": self.uploadTitle.text,
                        "DESCRIPTION": self.uploadDescription.text ,
                        "IMAGE": imageurlgenerated!
                    ]
                    
                    let  urlupload = "http://api-ams.me/v1/api/articles"
                    let header = ["Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="]
                    
                    Alamofire.request(urlupload, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                        guard response.result.isSuccess else{
                            print("error")
                            return
                        }
                    })
                    
                    
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
            }
    
    
    
}
