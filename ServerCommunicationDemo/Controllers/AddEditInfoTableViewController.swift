//
//  AddEditInfoTableViewController.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/10/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Alamofire
import  NVActivityIndicatorView

class AddEditInfoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {

    // Outlet
    @IBOutlet var inputTextField: [UITextField]!
    @IBOutlet weak var coverImageView: UIImageView!
    
    // Property
    var book : [String : Any]?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if book != nil {
            inputTextField[0].text = book?["Title"] as? String
            inputTextField[1].text = book?["Description"] as? String
            // do more task
        }
        
        imagePicker.delegate = self
    }
    

    @IBAction func saveAction(_ sender: Any) {
        // loading indicatior
        startAnimating( message: "Loading", type: NVActivityIndicatorType.ballClipRotatePulse)
        
        // NSDateFormatter 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
       
        let dateString = dateFormatter.string(from: Date())
        print(dateString)
        
        let parameter = [
            "Title": inputTextField[0].text ?? "",
            "Description": inputTextField[1].text ?? "",
            "PageCount": 100,
            "Excerpt": "Example Excerpt",
            "PublishDate": dateString
        ] as [String : Any]
        
        var url = DataManager.Url.BOOK
        var method = HTTPMethod.post
        
        if book != nil {
            url = DataManager.Url.BOOK + "/\(book?["ID"] as! Int)"
            method = HTTPMethod.put
        }
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers: DataManager.Url.HEADERS)
            .responseJSON { (response) in
                
                self.stopAnimating()
                if response.response?.statusCode == 200{
                    print("\(method) success")
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    print("\(method) fail")
                }
        }
        
        
        
        
        
    }
}

extension AddEditInfoTableViewController{
    
    
    @IBAction func browseImage(_ sender: Any) {
        // confi property
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        // show image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    // open image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            coverImageView.contentMode = .scaleAspectFit
            coverImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}





