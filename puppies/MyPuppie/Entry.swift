//
//  Entry.swift
//  puppies
//
//  Created by Milan Kokic on 04/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

class Entry {
    
    var date: String
    var photo: String?
    var mood: Int
    var id: String
    
    init?(id: String, date: String, photo: String, mood: Int) {
        
        guard !id.isEmpty else {
            return nil
        }
        
        guard (mood >= 0) && (mood <= 5) else {
            return nil
        }
        
        self.id = id
        self.date = date
        self.photo = photo
        self.mood = mood
    }
    
}
