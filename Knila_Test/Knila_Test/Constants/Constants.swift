//
//  Constants.swift
//  Knila_Test
//
//  Created by Jeyakumar on 04/02/21.
//

import Foundation
import UIKit

struct Constants {
    
    struct App {
        static let appName = "Knila"
        static let imageName = "person"
    }
    struct ApiFields {
        
        static let main_url = "https://reqres.in/api/users"
    }
    
    struct  Title {
        static let cameraAccessDenied = "Camera Access Disabled"
        static let photoAccessDenied = "Photo Library Access Disabled"
        
        static let Cancel = "Cancel"
        static let Camera = "Camera"
        
        static let UPDATE = "UPDATE"

        static let OpenSettings = "Open Settings"
        static let PhotoLibrary = "Photo Library"
    }
    
    struct Message {
        
        static let userAdded = "Congrats! You have added the user successfully"
        static let userUpdate = "Congrats! You have updated the user successfully"
        static let cameraAccessDeniedMessage = "App would like to access your Camera for your Photo upload.Your photos wont be shared without your permission. Please click the Open Settings and enable the camera."
        static let photoAccessDeniedMessage = "App would like to access your photo library for your Photo upload. Your photos wont be shared without your permission.Please click the Open Settings and set Photo Library access to 'Read and Write' mode."
    }
    
    struct Validation {
        
        static let imageUpload = "Please Upload the Image"
        static let firstName = "Please enter the first name"
        static let lastName = "Please enter the last name"
        static let email = "Please enter the email address"
        static let validEmail = "Please enter the valid email address"
    }
    
    struct CoreData {
        
        struct Entity {
            static let Users = "Users"
        }
        
        struct Attribute {
            static let first_name = "first_name"
            static let last_name =  "last_name"
            static let email = "email"
            static let id = "id"
            static let avatar = "avatar"
        }
        
    }
}


