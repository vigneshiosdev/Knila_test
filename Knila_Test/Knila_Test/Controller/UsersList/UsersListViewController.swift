//
//  UsersListViewController.swift
//  Knila_Test
//
//  Created by Jeyakumar on 03/02/21.
//

import UIKit
import Foundation
import CoreData

class UsersListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var userModel = users()
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
      
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        
        getUserData()
    }
    
    func getUserData(){
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.Entity.Users)
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            if(user.count == 0){
                callUserAPI()
            }
            else {
                getLocalUserData()
            }
        } catch let erroe as NSError {
            print(erroe)
        }
    }
    
    func callUserAPI(){
            
        service.getUsers(completionHandler: { (_ user_list ) in
            
            DispatchQueue.main.async {

                self.userModel = user_list
                self.addLiveUsersToCoreData()
                self.tableView.reloadData()
            }
        }) { (_ Error) in
                
        }
    }

    func getLocalUserData(){
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.Entity.Users)
        
        do {
            let local_users = try managedContext.fetch(fetchRequest)
            var jsonArray = [[String: Any]]()

            for item in local_users {
                
                var dict: [String: Any] = [:]
                for attribute in item.entity.attributesByName {
                        //check if value is present, then add key to dictionary so as to avoid the nil value crash
                    if let value = item.value(forKey: attribute.key) {
                        dict[attribute.key] = value
                    }
                }
                jsonArray.append(dict)
            }

            var allUser = [String: Any]()
            allUser["data"] = jsonArray

            let jsonData = try JSONSerialization.data(withJSONObject: allUser, options: [])
            self.userModel = try JSONDecoder().decode(users.self, from: jsonData)
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addLiveUsersToCoreData() {
        
        if let users = self.userModel.data {
            
            for user in users {
                            
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: Constants.CoreData.Entity.Users, in: managedContext)!
                let person = NSManagedObject(entity: entity, insertInto: managedContext)
                
                person.setValue(user.first_name, forKeyPath: Constants.CoreData.Attribute.first_name)
                person.setValue(user.last_name, forKeyPath: Constants.CoreData.Attribute.last_name)
                person.setValue(user.email, forKeyPath: Constants.CoreData.Attribute.email)
                person.setValue(user.id, forKeyPath: Constants.CoreData.Attribute.id)
                person.setValue(user.avatar, forKeyPath: Constants.CoreData.Attribute.avatar)
                
                do {
                    try managedContext.save()
                 } catch _ as NSError {
                }
            }
        }
    }
    
    @IBAction func btnAddUsers(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let AddUsersViewController = storyBoard.instantiateViewController(withIdentifier: "AddUsersViewController") as! AddUsersViewController
        self.present(AddUsersViewController, animated: false, completion: nil)
    }
}

extension UsersListViewController : UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.userModel.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? userListTableViewCell
        Cell?.selectionStyle = .none
        let person = self.userModel.data?[indexPath.row]
        
        Cell?.lblName.text = "\(person?.first_name ?? "") \(person?.last_name ?? "")"
        Cell?.lblEmail.text = person?.email ?? ""
        
        if let UrlString = person?.avatar {
            let url = URL(string: UrlString)!
            Cell?.imgView.downloadImage(from: url)
        }
        else {
            Cell?.imgView.image = UIImage(systemName: Constants.App.imageName)
        }
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let UserDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        UserDetailsViewController.userData = userModel.data?[indexPath.row]
        self.present(UserDetailsViewController, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .normal, title: "EDIT") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let AddUsersViewController = storyBoard.instantiateViewController(withIdentifier: "AddUsersViewController") as! AddUsersViewController
            AddUsersViewController.userData = self.userModel.data?[indexPath.row]
            AddUsersViewController.isForEdit = 1
            self.present(AddUsersViewController, animated: false, completion: nil)
            
        }
        contextItem.backgroundColor = UIColor.blue
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
}

