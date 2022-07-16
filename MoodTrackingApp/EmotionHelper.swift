import UIKit

class EmotionHelper: UIViewController {
    var update: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var dayOfMonth = Calendar.current.dateComponents([.day], from: Date()).day
    @IBAction func radosna(){
        if let day = dayOfMonth{
            UserDefaults().set("radosna", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func zadowolona(){
        if let day = dayOfMonth{
            UserDefaults().set("zadowolona", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func rozbawiona(){
        if let day = dayOfMonth{
            UserDefaults().set("rozbawiona", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func pogodna(){
        if let day = dayOfMonth{
            UserDefaults().set("pogodna", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func obojetna(){
        if let day = dayOfMonth{
            UserDefaults().set("obojetna", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func rozczarowana(){
        if let day = dayOfMonth{
            UserDefaults().set("rozczarowana", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func zmeczona(){
        if let day = dayOfMonth{
            UserDefaults().set("zmeczona", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func wsciekla(){
        if let day = dayOfMonth{
            UserDefaults().set("wsciekla", forKey: "mood_\(day)")
        }
        goback()
    }
    @IBAction func smutna(){
        if let day = dayOfMonth{
            UserDefaults().set("smutna", forKey: "mood_\(day)")
        }
        goback()
    }

    func goback(){
        update?()
        navigationController?.popViewController(animated: true)
    }
}
