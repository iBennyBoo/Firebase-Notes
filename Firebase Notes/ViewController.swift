public struct Person: Codable{
    var name: String
    var age: Int
    var money: Double
}

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let database = Firestore.firestore()
    var names: [String] = ["name1", "name2", "name3"]
    var people = Person(name: "Bill", age: 17, money: 2446.87)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField1.delegate = self
        ageField.delegate = self
        moneyField.delegate = self
        
        //Custom object
        let objRef = database.document("random/stuff")
        do{
            try objRef.setData(from: people)
        }catch{
            print("L firmly grasp it L")
        }
        
        
        //Reading data from file
        
        let docRef = database.document("user/person")
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            
            print(data)
            
            guard let text = data["text"] as? String else{
                return
            }
            self.label.text = "\(text)"
        }
    }
    
    func writeData(text: String, age: Int, money: Double){
        let docRef = database.document("user/person")
        docRef.setData(["name": text, "age": age, "money": money])
    }

    func readData(){
        let docRef = database.document("user/person")
        docRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            
            print(data)
            
            guard let x = data["name"] as? String else{
                return
            }
            guard let y = data["age"] as? Int else{
                return
            }
            guard let z = data["money"] as? Double else{
                return
            }

            self.label.text = "Your name is \(x) aged \(y) years with $\(z)."
            
        }
    }
    
    
    
    @IBAction func readButtonAction(_ sender: UIButton) {
        readData()
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let text = textField1.text!
        let age = Int(ageField.text!)!
        let money = Double(moneyField.text!)!
        //label.text = "\(text)"
        writeData(text: text, age: age, money: money)
        
        textField1.resignFirstResponder()
        ageField.resignFirstResponder()
        moneyField.resignFirstResponder()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField1.resignFirstResponder()
        ageField.resignFirstResponder()
        moneyField.resignFirstResponder()
        return true
        
    }
}

