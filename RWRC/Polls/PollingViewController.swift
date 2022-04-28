// large file that controls the main part of polling creation
// user is taaken here from inside of the chat feature by hitting the threee vertical bar button on the bottom left of the screen
// has multiple outlets that take in the inputs from the user
// has fire base capabilities added into to save the poll to the firebase collection "Polls"
// ID variable is taken form the poll and sent to other screens

import UIKit
import Firebase
import FirebaseFirestore

class PollingViewController: UIViewController , UITextFieldDelegate{
  
  @IBOutlet weak var pTtile: UITextField?
  
  @IBOutlet weak var ChoiceControl: UISegmentedControl!
  @IBOutlet weak var DateExpire: UIDatePicker!

  @IBOutlet weak var c1: UITextField?
  @IBOutlet weak var c2: UITextField?
  @IBOutlet weak var c3: UITextField?
  @IBOutlet weak var c4: UITextField?
  @IBOutlet weak var c5: UITextField?
  
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var CreateButton: UIButton!
  var ID : String = " "
  
  // database variables used for storing
  private let database = Firestore.firestore()
  private var reference: CollectionReference {
    return database.collection("Polls/")
  }
  private let storage = Storage.storage().reference()
  private var pollListener: ListenerRegistration?
 

  init() { // required init func
    super.init(nibName: "PollingViewController", bundle: nil)
    
  }
  
  required init?(coder: NSCoder) { // required init func
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ID = random(digits: 6) // as soon as poll creation  is called the ID is made using random
    // if the user taps away on the screen, dismiss the keyboard
    let detectTouch = UITapGestureRecognizer(target: self, action:
                                                  #selector(self.dismiss(animated:completion:)))
    self.view.addGestureRecognizer(detectTouch) // bring up keyboard and dismiss once the user taps somewhere else on the screen
      
    // set up of variables form .xib file
    self.pTtile?.delegate = self
    self.c1?.delegate = self
    self.c2?.delegate = self
    self.c3?.delegate = self
    self.c4?.delegate = self
    self.c5?.delegate = self
    
  }

  // main func to add the poll. adds to both the poll model and firebase.
  func appendPoll() {
    // initializes variables
    var poll : Poll
    var pollModel : PollModel
    pollModel = .init()
    poll = .init()
   
    //sets up ID. ID is used for docID inside of firebase
    poll.idNum = ID
    poll.name = (pTtile?.text)!
    poll.ExpireDate = DateExpire.date
    if (ChoiceControl.selectedSegmentIndex == 0) {
      poll.SC = true // 0 is the left most position of the contorl switch.
      // meaning it is single choice and the user only wants one choice
    }
    else{
      poll.SC = false // multiple choice
    
    }
    // sets poll variables to the input from user
    poll.option1 = (c1?.text)!
    poll.option2 = (c2?.text)!
    poll.option3 = (c3?.text)!
    poll.option4 = (c4?.text)!
    poll.option5 = (c5?.text)!
    
    poll.countArray = [0, 0, 0, 0, 0]  // intializes all counts to 0 since noone has taken the poll
    pollModel.items.append(poll)
    
    database.collection("Polls").document(poll.idNum).setData(poll.representation) // adds poll to firebase
  }

  // func used to create a random ID number. 6 digits returned as String
  func random(digits:Int) -> String {
      var number = String()
      for _ in 1...digits {
         number += "\(Int.random(in: 1...9))"
      }
      return number
  }

  func getTextValues() -> Array<String>{ // returns array of all text fields taken from user
    var tmpItems : Array<String> = [" "]
    let var1 = pTtile?.text
    let var2 = c1?.text
    let var3 = c2?.text
    let var4 = c3?.text
    let var5 = c4?.text
    let var6 = c5?.text
    
    tmpItems.append(var1 ?? "No Title ")
    tmpItems.append(var2 ?? "No Option 1")
    tmpItems.append(var3 ?? "No Option 2")
    tmpItems.append(var4 ?? "No Option 3")
    tmpItems.append(var5 ?? "No Option 4")
    tmpItems.append(var6 ?? "No Option 5")
    
    return(tmpItems)
  }
  
  @IBAction func CreatePressed(_ sender: Any) { // creates poll and calls to add to the database
    appendPoll() // needs to be in here for proper inforamtion to be added to database
    let alertController = UIAlertController( // send dialogue box with ID
      title: nil,
      message: "Your Poll has been created! The code is " + ID,
      preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)// present alert box
    self.navigationController?.dismiss(animated: true, completion: nil)// dismiss screen once created
    
  }
  
  
  @IBAction func cancelPressed(_ sender: Any) {// pops out to chat view controller
    self.navigationController?.dismiss(animated: true, completion: nil)
  }

}
