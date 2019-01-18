
class Entry {
    
    var date: String
    var photo: String?
    var mood: Int
    
    init?(date: String, photo: String, mood: Int) {
        
        guard (mood >= 0) && (mood <= 5) else {
            return nil
        }
        
        self.date = date
        self.photo = photo
        self.mood = mood
    }
    
}
