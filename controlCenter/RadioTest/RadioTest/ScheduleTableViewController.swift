//
//  ScheduleTableViewController.swift
//  RadioTest
//
//  Created by ben on 5/3/17.
//  Copyright © 2017 Hwang Lee. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    var shows = [Show]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadShows()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ShowTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShowTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ShowTableViewCell.")
        }        // Configure the cell...
        
        let thisshow=shows[indexPath.row]
        
        cell.showTime.text = String(thisshow.time)
        cell.showTitle.text = thisshow.name
        cell.showDj.text = thisshow.dj
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadShows() {
        
        let showname1="Show1"
        let showname2="Show2"
        let showname3="Show3"
        let dj = "me bro"
        let time1 = 9
        let time2 = 10
        let time3 = 11
        
        let show1 = Show(name: showname1, dj: dj, time: time1)
        
        let show2 = Show(name: showname2, dj: dj, time: time2)
            
        let show3 = Show(name: showname3, dj: dj, time: time3)
        
        shows+=[show1,show2,show3]
        
    }

}
