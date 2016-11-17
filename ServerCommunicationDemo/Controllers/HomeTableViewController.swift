//
//  HomeTableViewController.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 11/11/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Kingfisher

class HomeTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    // Property
    var books : [JSON]! = [JSON]()
    var coverPhotos : [JSON]! = [JSON]()
    var authors : [JSON]! = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register XIB Class
        
        let nib = UINib(nibName: "TableViewSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        getData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // get default data
        getData()
    }
    
    func getData() {
        // Create NVActivityIndicator
        startAnimating(message: "Loading", type: NVActivityIndicatorType.ballBeat)
        
        
        //#1
        Alamofire.request("http://fakerestapi.azurewebsites.net/api/Books").responseJSON { (response) in
            
            if let data = response.data {
                // JSON Results
                let jsonObject = JSON(data: data)
                self.books = jsonObject.array
                
                //#2
                Alamofire.request("http://fakerestapi.azurewebsites.net/api/CoverPhotos").responseJSON(completionHandler: { (response) in
                    if let bookCoverData = response.data{
                        // JSON Results
                        let bookCoverObject = JSON(data: bookCoverData)
                        self.coverPhotos = bookCoverObject.array
                        
                        //#3
                        Alamofire.request("http://fakerestapi.azurewebsites.net/api/Authors").responseJSON(completionHandler: { (response) in
                            if let authorData = response.data{
                                // JSON Results
                                let authorObject = JSON(data: authorData)
                                self.authors = authorObject.array
                                self.tableView.reloadData()
                                self.stopAnimating()
                                self.refreshControl?.endRefreshing()
                            }
                        })
                    }
                })
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


// MARK: - Table view data source
extension HomeTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.books.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        // Configure the cell...
        
        let book = self.books[indexPath.section]
        let coverPhoto = self.coverPhotos[indexPath.section]
        
        cell.titleLabel.text = book["Title"].stringValue
        cell.descriptionLabel.text = book["Description"].stringValue
        
      //  cell.coverImageView.image = UIImage(data: try! Data(contentsOf: URL(string: coverPhoto["Url"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!))
        
        let url = URL(string: coverPhoto["Url"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let placeHolderImage = UIImage(named: "google_logo")
        
        cell.coverImageView.kf.setImage(with: url, placeholder: placeHolderImage)
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableViewSectionHeader
        
        header.titleLabel.text = authors[section]["FirstName"].stringValue
       
        // load profile image
        let coverPhoto = self.coverPhotos[section]
        
        let url = URL(string: coverPhoto["Url"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let placeHolderImage = UIImage(named: "google_logo")
        
        header.profileImageView.kf.setImage(with: url, placeholder: placeHolderImage)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}









