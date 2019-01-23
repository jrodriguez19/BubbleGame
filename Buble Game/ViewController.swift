//
//  ViewController.swift
//  Buble Game
//
//  Created by George on 4/26/18.
//  Copyright © 2018 George. All rights reserved.
//

import UIKit
class BubbleType{
    
    var points : Int = 0

    func randomType (){
        //Random probability acording to the requirements
        switch arc4random_uniform(100){
        case 0..<40:    //Red 40 %
            self.points = 1
        case 40..<70:   //Pink 30 %
            self.points = 2
        case 70..<85:   //Green 15 %
            self.points = 5
        case 85..<95:   //Blue 10 %
            self.points = 8
        case 95..<100:  //Black 5 %
            self.points = 10
        default:
            self.points = 0
        }
    }
 
}

class Bubble : UIButton {
    
    var bubbleType : BubbleType = BubbleType()
    
    
    func assignCharacteritics(){
        self.layer.cornerRadius = self.bounds.size.width / 2
        switch bubbleType.points {
        case 1:    //Red
            self.setImage(#imageLiteral(resourceName: "redBubble.png"), for: .normal)
        case 2:   //Pink
            self.setImage(#imageLiteral(resourceName: "pinkBubble.png"), for: .normal)
        case 5:   //Green
            self.setImage(#imageLiteral(resourceName: "greenBubble.png"), for: .normal)
        case 8:   //Blue
            self.setImage(#imageLiteral(resourceName: "blueBubble.png"), for: .normal)
        case 10:  //Black
            self.setImage(#imageLiteral(resourceName: "blackBubble.png"), for: .normal)
        default:
            self.backgroundColor = UIColor.yellow
        }

    }
    
    
    
}

////// End Classes  ////



class ViewController: UIViewController {
    
    
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelLaunchTimer: UILabel!
    @IBOutlet weak var labelBestScore: UILabel!
    
    var maxBubbles : Int?
    var gameTime : Int?
    var playerName : String = "Empty"
    var time = 0
    
    let boardWidth = UIScreen.main.bounds.width
    let boardHeight = UIScreen.main.bounds.height
    var score : Int = 0
    var lastTapBubble : Int = 0
    // size of the bubble acording to the size of screen
    let bubbleSize  = UIScreen.main.bounds.width/6
    
    var timer = Timer()
    
    var bestScorePlayer : [Int] = [Int]()
    
    override func viewDidLoad() {
        //Allocate of board view according to the screen size
        super.viewDidLoad()
        time = 3
        self.board.frame.size.width = self.boardWidth
        self.board.frame.size.height = self.boardHeight
        self.board.center = self.view.center + CGPoint(x: 0, y: 50)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.launchGameTimer)), userInfo: nil, repeats: true)
        
        if let saved = UserDefaults.standard.object(forKey: "score") as? [Int] {
            self.bestScorePlayer = saved
            self.bestScorePlayer = self.bestScorePlayer.sorted(by: { $0 > $1})
            self.labelBestScore.text = "BS: \((String(self.bestScorePlayer.first!)))"
        }
        else{
            self.labelBestScore.text = "BS: 0"
        }
    }
    
    
    func createBubble (){
        let randomX : Int = Int(arc4random_uniform(UInt32(Int(boardWidth - self.bubbleSize))))
        let randomY : Int = Int(arc4random_uniform(UInt32(Int(boardHeight - self.bubbleSize*2))))
        
        let bubble = Bubble(frame: CGRect(x: randomX , y: randomY , width: Int(self.bubbleSize), height: Int(self.bubbleSize)))
        bubble.bubbleType.randomType()
        bubble.assignCharacteritics()
     
        var overlap = false
        for subView in self.board.subviews{
            overlap = subView.frame.intersects(bubble.frame)
            if(overlap == true){
                break
            }
        }

        if(overlap == false){
            bubble.alpha = 0
            self.board.addSubview(bubble)
            
            let bounds = bubble.bounds
            bubble.alpha = 0
            
            //Animate the creation of Bubbles
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                bubble.alpha = 1
                bubble.layoutIfNeeded()
                bubble.bounds = CGRect(x: bounds.origin.x-200, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            }, completion: nil)
            
            bubble.addTarget(self, action: #selector(bubbleTapped(_:)), for: .touchUpInside)
        }
    }
    
    
    @objc func updateTimer(){
        self.time -= 1
        self.lastTapBubble = 0
        self.labelTime.text = String(self.time)
        
        // Randomly Remove bubbles
        if (self.board.subviews.count>0){
            for subView in self.board.subviews{
                if(arc4random_uniform(10) == 0){
                    subView.removeFromSuperview()
                }
            }
        }
        // Randomly add bubbles up to the maximum configured number
        for _ in 0...(maxBubbles! - self.board.subviews.count) {
            if(self.board.subviews.count<maxBubbles!){
                createBubble()
            }
        }
        if time == 0{
            performSegue(withIdentifier: "showResults", sender: nil)
        }
    }
    
    

    
    
    
    @objc func bubbleTapped(_ sender: Bubble) {
        //Check last taped bubble and compare with current one to give or not bonus
        if self.lastTapBubble == sender.bubbleType.points {
            self.score += sender.bubbleType.points + Int(round(Float(sender.bubbleType.points)/2))
        } else{
            self.score += sender.bubbleType.points
            self.lastTapBubble = sender.bubbleType.points
        }
        labelScore.text = String(self.score)
        sender.removeFromSuperview()
    }
    
    @objc func launchGameTimer (){
        time -= 1
        self.labelLaunchTimer.text = String(time)
        if time == 0 {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
            time = gameTime!
            self.labelLaunchTimer.removeFromSuperview()
            self.labelScore.text = "0"
            self.labelTime.text = String(gameTime!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //after game finishe remove all bubbles
        for subView in self.board.subviews{
                subView.removeFromSuperview()
        }
        
        let destViewControlerResults : ViewControllerResults = segue.destination as! ViewControllerResults
        timer.invalidate()
        destViewControlerResults.playerName = playerName
        destViewControlerResults.scorePlayer = score
        
    }
    
}

//Function to Sum two CGPoint
func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}



