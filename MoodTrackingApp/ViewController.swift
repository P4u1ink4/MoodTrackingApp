import UIKit
import UserNotifications

class ViewController: UIViewController{
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var zadowolonaLabel: UILabel!
    @IBOutlet weak var radosnaLabel: UILabel!
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
    
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width,height: height)
    }

    func setMonthView(){
        totalSquares.removeAll()
        moods.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        print(startingSpaces)
        
        var count: Int = 1
        var zadowolona: Int = 0
        var radosna: Int = 0
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
                if(mood == "radosna"){radosna+=1}
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
        radosnaLabel.text = String(radosna*100/daysInMonth) + "%"
        zadowolonaLabel.text = String(zadowolona*100/daysInMonth) + "%"
        rozbawionaLabel.text = String(rozbawiona*100/daysInMonth) + "%"
        pogodnaLabel.text = String(pogodna*100/daysInMonth) + "%"
        obojetnaLabel.text = String(obojetna*100/daysInMonth) + "%"
        rozczarowanaLabel.text = String(rozczarowana*100/daysInMonth) + "%"
        zmeczonaLabel.text = String(zmeczona*100/daysInMonth) + "%"
        wscieklaLabel.text = String(wsciekla*100/daysInMonth) + "%"
        smutnaLabel.text = String(smutna*100/daysInMonth) + "%"
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
        
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        if(indexPath.item-startingSpaces>=0){
            let emotion = moods[indexPath.item-startingSpaces]
            if(emotion == "clear"){ backgroundConfig.backgroundColor = UIColor.clear}
            if(emotion == "radosna"){ backgroundConfig.backgroundColor = UIColor.yellow}
            if(emotion == "zadowolona"){ backgroundConfig.backgroundColor = UIColor.green}
            if(emotion == "rozbawiona"){ backgroundConfig.backgroundColor = UIColor.purple}
            if(emotion == "pogodna"){ backgroundConfig.backgroundColor = UIColor.systemPink}
            if(emotion == "obojetna"){ backgroundConfig.backgroundColor = UIColor.gray}
            if(emotion == "rozczarowana"){backgroundConfig.backgroundColor = UIColor.systemIndigo}
            if(emotion == "zmeczona"){ backgroundConfig.backgroundColor = UIColor.orange}
            if(emotion == "wsciekla"){ backgroundConfig.backgroundColor = UIColor.red}
            if(emotion == "smutna"){ backgroundConfig.backgroundColor = UIColor.systemBlue}
            cell.backgroundConfiguration = backgroundConfig
        }
        return cell
    }
}

