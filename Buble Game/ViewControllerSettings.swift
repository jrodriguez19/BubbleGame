//
//  ViewControllerSettings.swift
//  Buble Game
//
//  Created by George on 5/7/18.
//  Copyright © 2018 George. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerSettings : UIViewController {
    
    var gameTime : Int = 60
    var maxBubbles : Int = 15
    var playerName : String = "Empty"
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelBubbles: UILabel!
    
  
    
    
    @IBAction func sliderTimeGame(_ sender: UISlider) {
        self.labelTime.text = "Time: \(Int(sender.value))"
        self.gameTime = Int(sender.value)
    }
    
    
    @IBAction func sliderBubbleNumber(_ sender: UISlider) {
    
        self.labelBubbles.text = "Number of Bubbles: \(Int(sender.value))"
        self.maxBubbles = Int(sender.value)
    }
    
    
    override func viewDidLoad() {
        
        self.labelTime.text = "Time: \(String(gameTime))"
        self.labelBubbles.text = "Number of Bubbles: \(String(maxBubbles))"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewControler : ViewController = segue.destination as! ViewController
        
        destViewControler.maxBubbles = maxBubbles
        destViewControler.gameTime = gameTime
        destViewControler.playerName = playerName
        
    }
    
    
}
