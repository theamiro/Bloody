//
//  DonorFeedTableViewController.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


struct SingleRequest{
    let id: String!
    let patientName: String!
    let patientInformation: String!
    let bloodType: String!
    let created: String!
}

class RequestFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientInformation: UILabel!
    
}
class DonorFeedTableViewController: UITableViewController {

    var feed: [SingleRequest] = []
    let reusableIdentifier = "feedCell"
    override func viewDidLoad() {
        super.viewDidLoad()
//        var refreshControl = UIRefreshControl()
        feed.append(SingleRequest(id: "0949hf", patientName: "Johansen Mwajuma", patientInformation: "Involved in an accident yesternight and in critical condition. Donation required at Kenyatta National Hospital.", bloodType: "B+", created: "39939303"))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feed.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! RequestFeedTableViewCell
        let feedData = feed[indexPath.row]
        cell.bloodTypeLabel.text = feedData.bloodType
        cell.patientNameLabel.text = feedData.patientName
        cell.patientInformation.text = feedData.patientInformation
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
