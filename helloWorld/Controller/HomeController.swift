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
                let url = self.getDocumentsDirectory().appendingPathComponent("news.mp3")
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

