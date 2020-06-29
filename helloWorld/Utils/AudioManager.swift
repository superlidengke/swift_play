//
//  AudioManager.swift
//  helloWorld
//
//  Created by lidengke on 2020/06/29.
//  Copyright © 2020 lidengke. All rights reserved.
//

import Foundation

public class AudioManager {
    private lazy var audios : [AudioResource] = self.loadAudios()
    var audioCount : Int {return audios.count}
    
    func getAudio(at index: Int) -> AudioResource {
        return audios[index]
    }
    
    private func loadAudios() -> [AudioResource] {
        let audioDir = getDocumentsDirectory()
        var audiosFiles = [AudioResource]()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: audioDir, includingPropertiesForKeys: nil)
            for fileURL in fileURLs{
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                let fileSize = fileAttributes[FileAttributeKey.size] as? NSNumber
                let fileSizeM = (fileSize?.doubleValue ?? 0.0)/1024.0/1024.0
                let audioResource = AudioResource(name: fileURL.lastPathComponent, duration: "", size: String(format:"%.1f M" ,fileSizeM))
                audiosFiles.append(audioResource)
            }
            
        } catch {
            print("Error while enumerating files \(audioDir.path): \(error.localizedDescription)")
        }
        
        return audiosFiles
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
