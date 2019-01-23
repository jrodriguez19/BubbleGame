//
//  ViewCotrollerResults.swift
//  Buble Game
//
//  Created by George on 5/7/18.
//  Copyright © 2018 George. All rights reserved.
//

import Foundation
import UIKit


class ViewControllerResults : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var tableViewResults: UITableView!
  
    

    
 
    var playerName = "empty"
    var scorePlayer = 0
    
    
    var lastPlayerName : [String] = [String]()
    var lastScorePlayer : [Int] = [Int]()
    
    
    
    override func viewDidLoad() {
        tableViewResults.delegate = self
        tableViewResults.dataSource = self
        
        if let saved = UserDefaults.standard.object(forKey: "name") as? [String] {
            lastPlayerName = saved
            
            if let saved = UserDefaults.standard.object(forKey: "score") as? [Int] {
                lastScorePlayer = saved
            }
            
            for i in 0...lastPlayerName.count-1 {
                if playerName == lastPlayerName[i] {
                    if scorePlayer > lastScorePlayer[i] {
                        lastScorePlayer[i] = scorePlayer
                    }
                    break
                }
                else{
                    if i == lastPlayerName.count-1 {
                        lastPlayerName.append(playerName)
                        lastScorePlayer.append(scorePlayer)
                    }
                }
            }
            
            UserDefaults.standard.set(lastPlayerName, forKey: "name")
            UserDefaults.standard.set(lastScorePlayer, forKey: "score")
        
        }
        else {
            let pName : [String] = [playerName]
            let sPlayer : [Int] = [scorePlayer]
            
            UserDefaults.standard.set(pName, forKey: "name")
            UserDefaults.standard.set(sPlayer, forKey: "score")
        }
        
        self.tableViewResults.reloadData()
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  lastPlayerName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewResults.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = lastPlayerName[indexPath.row]
        cell?.detailTextLabel?.text = String(lastScorePlayer[indexPath.row])
        return cell!
    }
    

    
}


