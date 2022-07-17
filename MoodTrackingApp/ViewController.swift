import UIKit
import UserNotifications

class ViewController: UIViewController{
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var zadowolonaLabel: UILabel!
    @IBOutlet weak var podekscytowanaLabel: UILabel!
    @IBOutlet weak var pogodnaLabel: UILabel!
    @IBOutlet weak var rozbawionaLabel: UILabel!
    @IBOutlet weak var obojetnaLabel: UILabel!
    @IBOutlet weak var zmeczonaLabel: UILabel!
    @IBOutlet weak var rozczarowanaLabel: UILabel!
    @IBOutlet weak var smutnaLabel: UILabel!
    @IBOutlet weak var wscieklaLabel: UILabel!
    
    var moods = [String]()
    var selectedDate = Date()
    var totalSquares = [String]()
    var dayOfMonth = Calendar.current.dateComponents([.day], from: Date()).day
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            if(!granted){
                print("permission denied!")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Hey!"
        content.body = "Don't remember to note how do you feel today."
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request) { error in
        }
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        
        setCellsView()
        setMonthView()
    }
    
    @IBAction func previousMonth(_ sender: Any){
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    @IBAction func nextMonth(_ sender: Any){
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    @IBAction func returnButton(_ sender: Any){
        selectedDate = Date()
        setMonthView()
    }
    
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 9

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width,height: height)
    }

    func setMonthView(){
        totalSquares.removeAll()
        moods.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        var zadowolona: Int = 0
        var podekscytowana: Int = 0
        var pogodna: Int = 0
        var rozbawiona: Int = 0
        var obojetna: Int = 0
        var zmeczona: Int = 0
        var rozczarowana: Int = 0
        var smutna: Int = 0
        var wsciekla: Int = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let monthString = dateFormatter.string(from: selectedDate)
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: selectedDate)
        
        let month = Int(monthString) ?? 0
        let year = Int(yearString) ?? 0
        
        while(count <= 42){
            if let mood = UserDefaults().value(forKey: "mood_\([count,month,year])") as? String {
                moods.append(mood)
                if(mood == "podekscytowana"){podekscytowana+=1}
                if(mood == "zadowolona"){zadowolona+=1}
                if(mood == "rozbawiona"){rozbawiona+=1}
                if(mood == "pogodna"){pogodna+=1}
                if(mood == "obojetna"){obojetna+=1}
                if(mood == "rozczarowana"){rozczarowana+=1}
                if(mood == "zmeczona"){zmeczona+=1}
                if(mood == "wsciekla"){wsciekla+=1}
                if(mood == "smutna"){smutna+=1}
            }
            else{ moods.append("clear") }
            
            if(count <= startingSpaces || count - startingSpaces > daysInMonth){
                totalSquares.append("")
            }
            else{
                totalSquares.append(String(count - startingSpaces))
            }
            count+=1
        }
        moods.append("clear")
        monthLabel.text = CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        podekscytowanaLabel.text = " " + String(podekscytowana*100/daysInMonth) + "%  "
        zadowolonaLabel.text = " " + String(zadowolona*100/daysInMonth) + "%  "
        rozbawionaLabel.text = " " + String(rozbawiona*100/daysInMonth) + "%  "
        pogodnaLabel.text = " " + String(pogodna*100/daysInMonth) + "%  "
        obojetnaLabel.text = " " + String(obojetna*100/daysInMonth) + "%  "
        rozczarowanaLabel.text = " " + String(rozczarowana*100/daysInMonth) + "%  "
        zmeczonaLabel.text = " " + String(zmeczona*100/daysInMonth) + "%  "
        wscieklaLabel.text = " " + String(wsciekla*100/daysInMonth) + "%  "
        smutnaLabel.text = " " + String(smutna*100/daysInMonth) + "%  "
        collectionView.reloadData()
    }
    
    @IBAction func showEmotion(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "emotion") as! EmotionHelper
        vc.title = "Jak się dzisiaj czujesz?"
        vc.update = {
            DispatchQueue.main.async{
                self.setMonthView()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showJournal(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "journal") as! journalHelper
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        cell.circle.tintColor = UIColor.clear
        cell.dayOfMonth.textColor = UIColor.black
        
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        if(indexPath.item-startingSpaces>=0){
            let emotion = moods[indexPath.item-startingSpaces]
            if(emotion == "clear"){ cell.circle.tintColor = UIColor.clear}
            if(emotion == "podekscytowana"){ cell.circle.tintColor = UIColor.systemYellow; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "zadowolona"){ cell.circle.tintColor = UIColor.systemGreen; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "rozbawiona"){ cell.circle.tintColor = UIColor.systemPurple; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "pogodna"){ cell.circle.tintColor = UIColor.magenta; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "obojetna"){ cell.circle.tintColor = UIColor.lightGray; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "rozczarowana"){ cell.circle.tintColor = UIColor.systemIndigo; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "zmeczona"){ cell.circle.tintColor = UIColor.systemOrange; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "wsciekla"){ cell.circle.tintColor = UIColor.systemRed; cell.dayOfMonth.textColor = UIColor.white }
            if(emotion == "smutna"){ cell.circle.tintColor = UIColor.systemBlue; cell.dayOfMonth.textColor = UIColor.white }
        }
        return cell
    }
}

