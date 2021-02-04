//
//  AlertController.swift
//  Knila_Test
//
//  Created by Jeyakumar on 04/02/21.
//

import Foundation
import UIKit

extension UIAlertController {
    
    //  By passing the title and message the UIAlertController will appear on the particular screen
    static func showAlertViewWithOkAction(_ aViewController: UIViewController, message aMessage: String, okButtonBlock okAction: @escaping (_ action: UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: Constants.App.appName, message: aMessage, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            okAction(action)
        })
        alert.addAction(Ok)
        aViewController.present(alert, animated: true, completion: nil)
    }
    
}

