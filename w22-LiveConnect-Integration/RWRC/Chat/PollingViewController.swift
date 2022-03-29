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

class PollingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var expireDP: UIDatePicker!
    @IBOutlet weak var SCSwitch: UISwitch!
  
    @IBOutlet weak var op1: UITextField!
    @IBOutlet weak var op2: UITextField!
    @IBOutlet weak var op3: UITextField!
    @IBOutlet weak var op4: UITextField!
    @IBOutlet weak var op5: UITextField!
  
    @IBOutlet weak var SendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      let detectTouch = UITapGestureRecognizer(target: self, action:
                                                #selector(self.dismiss(animated:completion:)))
      self.view.addGestureRecognizer(detectTouch)
      
      self.questionTF.delegate = self
      self.op1.delegate = self
      self.op2.delegate = self
      self.op3.delegate = self
      self.op4.delegate = self
      self.op5.delegate = self
      
      SCSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        // Do any additional setup after loading the view.
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
