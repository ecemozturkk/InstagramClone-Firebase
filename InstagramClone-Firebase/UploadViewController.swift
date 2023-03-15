//
//  UploadViewController.swift
//  InstagramClone-Firebase
//
//  Created by Ecem Öztürk on 13.03.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Kullanıcının görsel üzerine basınca fotoğraf seçebilmesi
        //imageView'ın tıklanabilir yapılması
        imageView.isUserInteractionEnabled = true
        //gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func chooseImage() {
        //Kullanıcının kütüphanesine erişebilmek için
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        //datayı nereden alacağının söylenmesi
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    //seçilen görselin aktarılması
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    //Not: Ardından info.plist'e gidip Privacy-Photo Library Usage Description iznini vermeyi unutma ve value vermeyi unutma
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

    //Firebase Storage'a kaydedilmesi
    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storaga = Storage.storage()
        //referans kullanarak hangi klasörle çalışacağımızı, nereye kaydedeceğimizi vs. belirtiyoruz
        let storageReference = storaga.reference()
        //Firebase storage'da oluşturduğumuz "media" klasörüne ulaşım
        let mediaFolder = storageReference.child("media")
        
        //imageView'dan gelen görselin media klasörüne kaydedilebilmesi için veriye (dataya) çevrilmesi lazım
        //Yani UIImage olarak kaydedilemiyor, veri olarak kaydediliyor
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) { // 0.5 = görseli yarısı kadar sıkıştır
            
            let uuid = UUID().uuidString
            
            //oluşturulan görselin referansı
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString //URL'nin alınıp String'e çevrilmesi
                            
                            //MARK: DATABASE
                            
                            //database oluşturulması
                            let firestoreDatabase = Firestore.firestore()
                            //refereans oluşturulması
                            var firestoreReference : DocumentReference? = nil
                            //addDocument() fonksiyonunun içinde istenen data: [String : Any] dictionary'sinin oluşturulması
                            let firestorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postCaption": self.captionText.text!, "date": FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost,completion: { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    //imageView sıfırlanarak default görseline dönsün
                                    self.imageView.image = UIImage(named: "addImage.png")
                                    //caption default görünümüne dönsün
                                    self.captionText.text = ""
                                    self.tabBarController?.selectedIndex = 0 // Feed'e götür. (selectedIndex 0=Feed,1=Upload,2=Settings)
                                }
                            })
                            
                        }
                    }
                }
            }
            
            
        }
    }
    
}
