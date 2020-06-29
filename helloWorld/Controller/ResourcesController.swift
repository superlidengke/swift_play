//
//  ResourcesController.swift
//  helloWorld
//
//  Created by lidengke on 2020/06/29.
//  Copyright © 2020 lidengke. All rights reserved.
//

import UIKit

class ResourcesController: UITableViewController {
    
    var audioManager : AudioManager = AudioManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioManager.audioCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath)
        let audio = audioManager.getAudio(at: indexPath.row)
        cell.textLabel?.text = audio.name
        cell.detailTextLabel?.text = audio.duration + ", " + audio.size
        return cell
    }
}
