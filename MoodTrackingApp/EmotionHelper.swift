import UIKit

class EmotionHelper: UIViewController {
    var update: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var dayNow = Calendar.current.dateComponents([.day], from: Date()).day
    var monthNow = Calendar.current.dateComponents([.month], from: Date()).month
    var yearNow = Calendar.current.dateComponents([.year], from: Date()).year
    @IBAction func radosna(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("radosna", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func zadowolona(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("zadowolona", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func rozbawiona(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("rozbawiona", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func pogodna(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("pogodna", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func obojetna(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("obojetna", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func rozczarowana(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("rozczarowana", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func zmeczona(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("zmeczona", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func wsciekla(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("wsciekla", forKey: "mood_\(mood)")
        goback()
    }
    @IBAction func smutna(){
        guard let day = dayNow else { return }
        guard let month = monthNow else { return }
        guard let year = yearNow else { return }
        let mood = [day, month, year]
        UserDefaults().set("smutna", forKey: "mood_\(mood)")
        goback()
    }

    func goback(){
        update?()
        navigationController?.popViewController(animated: true)
    }
}
