import UIKit

struct EntryChartDataHelper {
    
    func getSortedData(entries: [EntryEntity]) -> [BarEntry] {
        var barEntries: [BarEntry] = []
        var dateDouble: [Double] = []
        for i in 0..<entries.count{
            dateDouble.append(convertStringDateToDouble(date: entries[i].date!))
        }
        
        var sortedDates: [String] = []
        
        var sortedByDate = Array<Double>(Set(dateDouble))
        sortedByDate.sort { ($0) < ($1) }
        for i in 0..<sortedByDate.count{
            sortedDates.append(convertDoubleDateToString(date: sortedByDate[i]))
        }
        
        for j in 0..<sortedDates.count {
            
            var moodSum: Float = 0
            var counter: Float = 0
            var height:Float = 0
            
            for entry in entries {
                
                if entry.date == sortedDates[j]{
                    
                    moodSum = moodSum + Float(entry.mood)
                    if (entry.mood != 0){
                        counter = counter + 1
                    }
                }
            }
            
            if (counter != 0){
                height = Float(moodSum/counter)*0.1
            } else {
                height = 0
            }
            
            let barEntry = BarEntry(color: getColor(mood: height*10), height: height, textValue: "\(height*10)", title: sortedDates[j])
            barEntries.append(barEntry)
        }
        return barEntries
    }
    
    func convertDoubleDateToString(date: Double) -> String {
        var milliseconds:Int64 {
            return Int64((date * 1000.0).rounded())
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        let newDate = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
        return dateFormatter.string(from: newDate)
    }
    
    func convertStringDateToDouble(date: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let date = dateFormatter.date(from: date)
        return date!.timeIntervalSince1970
    }
    
    func getColor(mood: Float) -> UIColor {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        
        var color: UIColor
        
        switch mood {
        case 0..<2:
            color = colors[2]
        case 2..<4:
            color = colors[1]
        case 4..<5:
            color = colors[0]
        default:
            color = colors[0]
        }
        return color
    }
}
