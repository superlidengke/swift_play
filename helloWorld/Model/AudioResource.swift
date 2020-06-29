//
//  AudioFile.swift
//  helloWorld
//
//  Created by lidengke on 2020/06/29.
//  Copyright © 2020 lidengke. All rights reserved.
//

import UIKit

struct AudioResource {
    var name : String
    var duration : String
    var size : String
    
    init(name: String, duration : String, size : String){
        self.name = name
        self.size = size
        self.duration = duration
    }
}
