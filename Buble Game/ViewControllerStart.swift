//
//  ViewControllerStart.swift
//  Buble Game
//
//  Created by George on 5/7/18.
//  Copyright © 2018 George. All rights reserved.
//

import Foundation
import UIKit


class ViewControllerStart : UIViewController {
   
    var playerName : String = "Empty"
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var buttonStartOutlet: UIButton!
    
    @IBAction func buttonStart(_ sender: Any) {
        
        if (textFieldName.text != "" && textFieldName.text != " " && textFieldName.text != "Please Enter Your Name" ){
            self.playerName = textFieldName.text!
            
        }
        else{
            
            let alert = UIAlertController(title: "Name Required", message:
                "Please Enter Your Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
  
    }
    
   
    
    override func viewDidLoad() {
      super.viewDidLoad()


    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewControlerSettings : ViewControllerSettings = segue.destination as! ViewControllerSettings
        
        destViewControlerSettings.playerName = self.playerName
        
    }
    
    
    
}

