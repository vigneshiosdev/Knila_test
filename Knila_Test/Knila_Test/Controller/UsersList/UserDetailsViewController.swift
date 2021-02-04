//
//  UserDetailsViewController.swift
//  Knila_Test
//
//  Created by Jeyakumar on 04/02/21.
//

import UIKit
import CoreData

class UserDetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lblFirstName: UILabel!
    @IBOutlet var lblLastName: UILabel!
    @IBOutlet var lblEmailAddress: UILabel!
    @IBOutlet var lblUserID: UILabel!
    
    var userData:data?//model Object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupData(){
        lblFirstName.text = userData?.first_name
        lblLastName.text = userData?.last_name
        lblEmailAddress.text = userData?.email
        lblUserID.text = "\(userData?.id ?? 0)"
        if let UrlString = userData?.avatar {
            let url = URL(string: UrlString)
            imageView.downloadImage(from: url!)
        } else {
            imageView.image = UIImage(systemName: Constants.App.imageName)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
