//
//  ViewController.swift
//  Calculator
//
//  Created by Denis Semerych on 20.04.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calc = Calculator()
    var typing = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var showNumbers: UILabel!
    @IBAction func calculate(_ sender: UIButton) {
        switch sender.tag {
        case 1...9:
            if typing {showNumbers.text! += String(sender.tag)} else {showNumbers.text = String(sender.tag)}
            typing = true
        case 10:
            if Int(showNumbers.text!) != 0 && typing{
            showNumbers.text! += "0"
            } else {
                showNumbers.text! = "0"
                typing = true
            }
        case 11:
            if !showNumbers.text!.contains(".") && showNumbers.text! != ""
            {
                showNumbers.text! += "."
                typing = true
            } else if showNumbers.text! == "" {
                showNumbers.text! = "0."
            }
        case 12...17:
            if typing {
                showNumbers.text = calc.save(numbers: showNumbers.text!, mod: sender.tag)
                if sender.tag != 12 {typing = false}
            } else {
                calc.saveLastOp(sender.tag)
            }
        case 18:
            if showNumbers.text![showNumbers.text!.startIndex] != "-" {showNumbers.text?.insert("-", at: (showNumbers.text?.startIndex)!)
            } else {showNumbers.text?.remove(at: showNumbers.text!.startIndex)}
        case 19:
            typing = false
            showNumbers.text! = "0"
            calc.numArr = []
            calc.ops = []
        default:
            break
        }
    }
}

