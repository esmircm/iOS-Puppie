//
//  DailyEntryViewController.swift
//  puppies
//
//  Created by Milan Kokic on 04/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import UIKit
import os.log

class DailyEntryViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var entry: Entry?
    var imageUrl: URL?
    var editingImageUrl: URL?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moodControl: MoodControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = entry {
            navigationItem.title = entry.date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            
            let date = dateFormatter.date(from: entry.date)
            
            if date != nil{
                datePicker.setDate(date!, animated: true)
            }
            
            if let photoString = entry.photo {
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath          = paths.first {
                    editingImageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(photoString)
                    if editingImageUrl != nil{
                        photoImageView.image = UIImage(contentsOfFile: editingImageUrl!.path)
                    }
                }
            }
            moodControl.mood = entry.mood
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddEntryMode = presentingViewController is UINavigationController
        
        if isPresentingInAddEntryMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DailyEntryViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        let date = dateFormatter.string(from: datePicker.date)
        
        var photo = "orange_paw"
        
        if imageUrl != nil && imageUrl != editingImageUrl {
            photo = imageUrl!.lastPathComponent
            if let data = photoImageView.image!.jpegData(compressionQuality: 1.0){
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self?.saveImage(data: data, path: photo)
                }
            }
        } else {
            photo = editingImageUrl?.lastPathComponent ??  ""
        }
        
        let mood = moodControl.mood
        
        entry = Entry(date: date, photo: photo, mood: mood)
        
    }
    
    func saveImage(data: Data, path: String){
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(path)
        
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("Image Added Successfully")
            } catch {
                print(error)
            }
        } else {
            print("Image Not Added")
        }
    }
    
    @IBAction func openGallery(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
        photoImageView.image = image
        dismiss(animated:true, completion: nil)
    }
}
