//
//  AddUsersViewController.swift
//  Knila_Test
//
//  Created by Jeyakumar on 03/02/21.
//

import UIKit
import Photos
import CoreData

class AddUsersViewController: UIViewController {
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmailAddress: UITextField!
    @IBOutlet var imgView: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userData:data? //model Object
    var userId = 0
    var imageUrl = ""
    var timer:Timer?
    var isForEdit = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.isForEdit == 1) {
            
            setupUI()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        txtFirstName.text = userData?.first_name
        txtLastName.text = userData?.last_name
        txtEmailAddress.text = userData?.email
        userId = userData?.id ?? 0

        if let UrlString = userData?.avatar {
            
            let url = URL(string: UrlString)
            self.imageUrl = UrlString
            imgView.downloadImage(from: url!)
        }
        else {
            
            imgView.image = UIImage(systemName: Constants.App.imageName)
        }
        
        btnSave.setTitle(Constants.Title.UPDATE, for: .normal)
    }
    
    func addUserValues() {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.CoreData.Entity.Users, in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(self.txtFirstName.text, forKeyPath: Constants.CoreData.Attribute.first_name)
        person.setValue(self.txtLastName.text, forKeyPath: Constants.CoreData.Attribute.last_name)
        person.setValue(self.txtEmailAddress.text, forKeyPath: Constants.CoreData.Attribute.email)
        person.setValue(self.userId + 1, forKeyPath: Constants.CoreData.Attribute.id)
        person.setValue(self.imageUrl, forKeyPath: Constants.CoreData.Attribute.avatar)
        
        do {
            
            try managedContext.save()
            UIAlertController.showAlertViewWithOkAction(self,  message: Constants.Message.userAdded) { (_ action) in
                self.Update()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func editUserValues() {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.Entity.Users)
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(self.userId)")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if let person = fetchedResults.first {
                
                person.setValue(self.txtFirstName.text, forKeyPath: Constants.CoreData.Attribute.first_name)
                person.setValue(self.txtLastName.text, forKeyPath: Constants.CoreData.Attribute.last_name)
                person.setValue(self.txtEmailAddress.text, forKeyPath: Constants.CoreData.Attribute.email)
                person.setValue(self.userId, forKeyPath: Constants.CoreData.Attribute.id)
                person.setValue(self.imageUrl, forKeyPath: Constants.CoreData.Attribute.avatar)
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            try managedContext.save()
            UIAlertController.showAlertViewWithOkAction(self,  message: Constants.Message.userUpdate) { (_ action) in
                self.Update()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func Update() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let UsersListViewController = storyBoard.instantiateViewController(withIdentifier: "UsersListViewController") as! UsersListViewController
        self.present(UsersListViewController , animated: false, completion: nil)
    }
    
    @IBAction func btnUpload(_ sender: Any) {
        
        showImagePicker()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        self.view.endEditing(true)
        if(imageUrl == "") {
            UIAlertController.showAlertViewWithOkAction(self, message: Constants.Validation.imageUpload) { (_ action) in
            }
        }
        else if(txtFirstName.text == "") {
            UIAlertController.showAlertViewWithOkAction(self,  message: Constants.Validation.firstName) { (_ action) in
            }
        }
        else if(txtLastName.text == "") {
            UIAlertController.showAlertViewWithOkAction(self,  message: Constants.Validation.lastName) { (_ action) in
            }
        }
        else if(txtEmailAddress.text == "") {
            UIAlertController.showAlertViewWithOkAction(self,  message: Constants.Validation.email) { (_ action) in
            }
        }else if(!txtEmailAddress.text!.isValidEmail()) {
            UIAlertController.showAlertViewWithOkAction(self,  message: Constants.Validation.validEmail) { (_ action) in
            }
        }else{
            if(self.isForEdit == 1) {
                self.editUserValues()
            }else{
                self.addUserValues()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         let touch = touches.first
         if touch?.view == self.view {
            self.view.endEditing(true)
        }
    }
}

extension AddUsersViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

extension AddUsersViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func showImagePicker() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: Constants.Title.Camera, style: .default) { action in
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                
                self.showCamera()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.showCamera()
                    }
                }
                
            case .denied: // The user has previously denied access.
                self.openSettings()
            case .restricted: // The user can't grant access due to restrictions.
                self.openSettings()
            @unknown default:
                break
            }
        }
        
        actionSheet.addAction(cameraAction)
        
        let albumAction = UIAlertAction(title: Constants.Title.PhotoLibrary, style: .default) { action in
            //Photos
            switch PHPhotoLibrary.authorizationStatus() {
            
            case .authorized:  // The user has previously granted access .
                
                self.openPhotoAlbum()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                do {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized{
                            
                            self.openPhotoAlbum()
                        }
                        else {
                            
                            self.openSettingsPhoto()
                        }
                    })
                }
                
            case .denied: // The user has previously denied access.
                self.openSettingsPhoto()
            case .restricted: // The user can't grant access due to restrictions.
                self.openSettingsPhoto()
            case .limited: break
                
            @unknown default: break
                
            }
        }
        actionSheet.addAction(albumAction)
        
        let cancelAction = UIAlertAction(title: Constants.Title.Cancel, style: .cancel) { action in }
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openSettings() {
        
        let alertController = UIAlertController(
            title: Constants.Title.cameraAccessDenied,
            message: Constants.Message.cameraAccessDeniedMessage,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.Title.Cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: Constants.Title.OpenSettings, style: .default) { (action) in
            if let url = NSURL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.canOpenURL(url as URL)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openSettingsPhoto()
    {
        let alertController = UIAlertController(
            title: Constants.Title.photoAccessDenied,
            message: Constants.Message.photoAccessDeniedMessage,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.Title.Cancel, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: Constants.Title.OpenSettings, style: .default) { (action) in
            if let url = NSURL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.canOpenURL(url as URL)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCamera() {
        
        DispatchQueue.main.async {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .camera
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func openPhotoAlbum() {
        
        DispatchQueue.main.async {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - UIImagePickerController delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        DispatchQueue.main.async {
            var id = 0
            if(self.isForEdit == 1) {
                id = self.userId
            }
            else {
                id = self.userId + 1
            }
            self.imgView.image = image
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            if let filePath = paths.first?.appendingPathComponent("MyImageName\(id).png") {
                // Save image.
                do {
                    try image.pngData()?.write(to: filePath, options: .atomic)
                    print(filePath)
                    self.imageUrl = "\(filePath)"
                }
                catch {
                    // Handle the error
                }
            }
        }
        dismiss(animated: true) {
        }
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        
        return input.rawValue
    }
    
}
