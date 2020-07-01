//
//  ViewController.swift
//  helloWorld
//
//  Created by lidengke on 2020/06/04.
//  Copyright © 2020 lidengke. All rights reserved.
//

import UIKit
import AVFoundation

class HomeController: UIViewController {
    
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    var menuOut = false
    
    var resourceManager : ResourcesManager = ResourcesManager()
    
    @IBAction func menuTapped(_ sender: Any) {
        if menuOut == false {
                   trailing.constant = -150
                   leading.constant = 150
                   menuOut = true
               }else{
                   trailing.constant = 0
                   leading.constant = 0
                   menuOut = false
               }
               UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                   self.view.layoutIfNeeded()
               }, completion: nil)
    }
    
    @IBOutlet weak var playAndPause: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    
    func preparePlay(url: URL){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            let audioSession = AVAudioSession.sharedInstance();
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }catch{
                print(error)
            }
        } catch {
            // couldn't load file :(
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        if(audioPlayer?.isPlaying ?? false){
            audioPlayer?.pause()
            sender.setTitle("Play", for: .normal)
        }else{
            sender.setTitle("Pause", for: .normal)
            
            if(audioPlayer == nil){
                let url = self.resourceManager.getResources()[0]
                print(url.absoluteURL)
                preparePlay(url:url)
            }
            audioPlayer?.play()
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

