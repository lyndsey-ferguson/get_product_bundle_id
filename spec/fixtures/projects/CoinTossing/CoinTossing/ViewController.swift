//
//  ViewController.swift
//  CoinTossing
//
//  Created by Shashikant Jagtap on 13/01/2017.
//  Copyright © 2017 Shashikant Jagtap. All rights reserved.
//

import UIKit

extension Array {
    func sample() -> Element? {
        if self.isEmpty { return nil }
        let randomInt = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomInt]
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var TossResult: UITextField!
    
    
    @IBAction func TosButton(_ sender: Any) {
        let toss = ["Heads", "Tails"]
        let tossResult = toss.sample()
        TossResult.text = tossResult
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

