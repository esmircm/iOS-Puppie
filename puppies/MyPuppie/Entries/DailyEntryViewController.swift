
import UIKit
import os.log

class DailyEntryViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var entry: EntryEntity?
    var imageUrl: URL?
    var date: String?
    var mood: Int?
    var id: String?
    var photo: String?
    var entryId: UUID?
    var puppieImageHelper: PuppieImageHelper?
    var camera: Bool?
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moodControl: MoodControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        puppieImageHelper = PuppieImageHelper()
        
        if let entry = entry {
            entryId = entry.id
            navigationItem.title = entry.date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            
            let date = dateFormatter.date(from: entry.date!)
            
            if date != nil{
                datePicker.setDate(date!, animated: true)
            }
            
            if let photoString = entry.photo {
                imageUrl = URL(string: entry.photo!)
                if photoString == "puppie_placeholder" {
                    photoImageView.image = UIImage(named: photoString)
                } else {
                    puppieImageHelper!.loadImage(imagePath: entry.photo!, resize: false) {[weak self](image: UIImage) in
                        self?.photoImageView.image = image
                    }
                }
            }
            moodControl.mood = Int(entry.mood)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        if let owningNavigationController = navigationController{
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
        
        date = dateFormatter.string(from: datePicker.date)
        
        photo = "puppie_placeholder"
        
        if imageUrl != nil {
            photo = imageUrl!.lastPathComponent
            if let data = photoImageView.image!.jpegData(compressionQuality: 1.0){
                puppieImageHelper!.saveImage(data: data, path: photo!)
            }
        }
        mood = moodControl.mood
        if entryId == nil {
            entryId = UUID()
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
