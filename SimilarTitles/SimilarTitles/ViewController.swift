//
//  ViewController.swift
//  SimilarTitles
//
//  Created by Armen Abrahamyan on 1/29/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // Outlet
    @IBOutlet weak var tableView: UITableView!
    // Member so that we won't get ARCed after event loop cycles
    var stLocationManager: STLocationManager?
    
    var dataSource: [String:AnyObject]? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Similar Image Titles"
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Setup Location Manager
        stLocationManager = STLocationManager(accuracy: kCLLocationAccuracyKilometer)
        stLocationManager!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: Location handler extension
extension ViewController: STLocationManagerDelegate {
    
    func succeedUserLocation(location: CLLocationCoordinate2D?) {
        if let loc = location {
            // Construct request
            
            // NOTE: Could be moved to data provider
            let paramsDictionary = [STRestConstants.STParamsKeys.action : "query",
                STRestConstants.STParamsKeys.list : "geosearch",
                STRestConstants.STParamsKeys.gsradius: "1000",
                STRestConstants.STParamsKeys.gscoord: "\(loc.latitude)|\(loc.longitude)",
                STRestConstants.STParamsKeys.gslimit: "50",
                STRestConstants.STParamsKeys.format: "json"]
            
            STWikipediaDataProvider.getNearByTitles(paramsDictionary, completionHandler: { (response: Dictionary<String, AnyObject>?, error: NSError?) -> Void in
                
                    if error == nil {
                        self.dataSource = response
                    } else {
                        print("Problem getting similars or data !!!!!")
                    }
            })
        }
    }
    
    func failedUserLocation(error: NSError?) {
        print("Error getting location: \(error?.localizedDescription)")
    }
}

//MARK: Table View Delegates handler extension

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.dataSource != nil {
            return (self.dataSource?.keys.count)!
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = self.dataSource?.startIndex.advancedBy(section)
        let key = self.dataSource?.keys[index!]
        let obj = self.dataSource?[key!] as! Set<String>
        
        return obj.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Dictionaries are unordered, so we can have different sorting here.
        let index = self.dataSource?.startIndex.advancedBy(section)
        return self.dataSource?.keys[index!]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell: STSimilarsTableViewCell = tableView.dequeueReusableCellWithIdentifier("similarsCell") as! STSimilarsTableViewCell

        let index = self.dataSource?.startIndex.advancedBy(indexPath.section)
        let key = self.dataSource?.keys[index!]
        let obj = self.dataSource?[key!] as! Set<String>
        let currentImageTitle = obj[obj.startIndex.advancedBy(indexPath.row)]
        tableViewCell.imageTitle.text = currentImageTitle
        
        return tableViewCell
    }
    
}

