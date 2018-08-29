//
//  DetailsController.swift
//  DataBaseTest
//
//  Created by Denis Semerych on 06.06.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {

    var ageFP: String?
    var positionFP: String?
    var weightFP: String?
    var statsFP: String?
    var heightFP: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        age.text = checkString(ageFP)
        position.text = checkString(positionFP)
        weight.text = checkString(weightFP)
        stats.text = checkString(statsFP)
        height.text = checkString(heightFP)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var stats: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    
    
    func checkString(_ str: String?) -> String {
        return str != nil ? str! : "No data yet!"
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
