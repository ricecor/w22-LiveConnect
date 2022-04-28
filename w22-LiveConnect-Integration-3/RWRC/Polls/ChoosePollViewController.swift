

import UIKit
import Firebase
import FirebaseFirestore

class ChoosePollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pollTable: UITableView!
  
  var polls: [Poll]
    var Cells: [String]!
  var id: String = " "
  var listen: ListenerRegistration?
  private let database = Firestore.firestore()
  private var reference: CollectionReference?
  
  let pool : Any = {
    options = [
    "Mexican", "American", "Thai", "Italian", "Chinese"]
    counts = [0, 0, 0, 0, 0]
  }
  
  deinit{
    listen?.remove()
  }
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        pollTable.register(UINib(nibName: "PollTableViewCell", bundle: nil), forCellReuseIdentifier: "PollCell")
        pollTable.delegate = self
        pollTable.dataSource = self
      id = gotsent()
      listenToMessages()
  
    }
  private func listenToMessages() {
 

    database.collection("channels/\(id)/")
      .addSnapshotListener { [weak self] querySnapshot, error in
      guard let self = self else { return }
        guard let snapshot = querySnapshot?.documentChanges else {
        print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
        return
      }
          //self.polls = snapshot.flatMap( -> Poll in
                  //                    return try! documentChange

    
    }
  }
  
  
  @objc private func gotsent() -> String {
    var ret: String = " "
    //1. Create the alert controller.
    let alert = UIAlertController(title: "Take Poll", message: "Enter a poll code", preferredStyle: .alert)

    //2. Add the text field. You can configure it however you need.
    alert.addTextField { (textField) in
        textField.text = "123"
    
    // 3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
      print("Text field: \(textField!.text ?? "000")")
      ret = (textField?.text)!
    }))

    // 4. Present the alert.
    self.present(alert, animated: true, completion: nil)
    }
    return ret
}
    @objc private func voted() {
    let alert = UIAlertController(title: "Final choice?", message: "Is this your final choice? you will only be able to submit once", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    let submitAction = UIAlertAction(
      title: "Submit",
      style: .default)
    alert.addAction(submitAction)
    alert.preferredAction = submitAction
    present(alert, animated: true, completion: nil)
      
    
    pollTable.reloadData()
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 110.0
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath) as! PollTableViewCell
    cell.Votebutton.tag = 1000*(1+indexPath.section)+indexPath.row
    cell.Votebutton.addTarget(self, action: #selector(voted), for: .valueChanged);
    let ref = database.collection("Polls/\(id)/")
    
  
  
    cell.optionLabel.text = pool.options[indexPath]
    cell.countLabel.text = "Votes: " + pool.counts[indexPath]
    return cell
  }
}
