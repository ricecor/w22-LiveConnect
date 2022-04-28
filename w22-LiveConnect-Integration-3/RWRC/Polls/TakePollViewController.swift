//testing view contorller to help enter code. replaced with alert dialogue through chat view controller

import UIKit

class TakePollViewController: UIViewController {

    @IBOutlet weak var CodeField: UITextField!
    @IBOutlet weak var Cancel: UIButton!
    @IBOutlet weak var Enter: UIButton!
    var code : String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
      //code = CodeField.text! as String
        // Do any additional setup after loading the view.
    }
  init(){
  super.init(nibName: "TakePollViewController", bundle: nil) 
    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    @IBAction func CancelPressed(_ sender: UIButton) {
      self.dismiss(animated: true)
    }
    
  @IBAction func EnterPressed(_ sender: UIButton) {
    if(code == "1234"){
      
      let vc = ChoosePollViewController()
      self.navigationController?.pushViewController(vc, animated: true)
    }
    else {
      
    }
  }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
