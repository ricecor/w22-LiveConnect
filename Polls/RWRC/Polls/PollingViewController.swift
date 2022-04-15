/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class PollingViewController: UIViewController, UITextFieldDelegate, Poll{

    @IBOutlet weak var pTtile: UITextField!
    
    @IBOutlet weak var ChoiceControl: UISegmentedControl!
    @IBOutlet weak var DateExpire: UIDatePicker!
  
    @IBOutlet weak var c1: UITextField!
    @IBOutlet weak var c2: UITextField!
    @IBOutlet weak var c3: UITextField!
    @IBOutlet weak var c4: UITextField!
    @IBOutlet weak var c5: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var CreateButton: UIButton!
    
  
    var instance: ChatViewController? // used for passing variables
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      
      // if the user taps away on the screen, dismiss the keyboard
      let detectTouch = UITapGestureRecognizer(target: self, action:
                                                    #selector(self.dismiss(animated:completion:)))
      self.view.addGestureRecognizer(detectTouch)
        
      self.pTtile.delegate = self
      self.c1.delegate = self
      self.c2.delegate = self
      self.c3.delegate = self
      self.c4.delegate = self
      self.c5.delegate = self
      
    }
  
  
  
    func getTextValues() -> Array<String>{ // returns array of all text fields taken from user
      var tmpItems : Array<String> = [" "]
      let var1 = pTtile.text
      let var2 = c1.text
      let var3 = c2.text
      let var4 = c3.text
      let var5 = c4.text
      let var6 = c5.text
      
      tmpItems.append(var1 ?? " ")
      tmpItems.append(var2 ?? " ")
      tmpItems.append(var3 ?? " ")
      tmpItems.append(var4 ?? " ")
      tmpItems.append(var5 ?? " ")
      tmpItems.append(var6 ?? " ")
      
      return(tmpItems)
    }
    
    @IBAction func CreatePressed(_ sender: Any) {
      let alertController = UIAlertController(
        title: nil,
        message: "Your Poll has been created!",
        preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "OK", style: .cancel)
      alertController.addAction(cancelAction)
      present(alertController, animated: true)
      self.presentingViewController?.dismiss(animated: true)
      //let vca = ChatViewController(
      //self.present(vca, animated: true, completion: nil)
      instance?.onUserAction(dat)
      let message: String? = "Hey come take my Poll! Just use this code to take my specifc poll" +
      (String(Poll.instance1.idNum!))
      _ = Message(user: text, content: message ?? "Error")
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
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
