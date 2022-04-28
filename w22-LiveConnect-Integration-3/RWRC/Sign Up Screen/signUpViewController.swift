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

import FirebaseAuth
import UIKit

final class signUpViewController: UIViewController{
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction private func actionButtonPressed() {
    guard let email = emailTextField.text, !email.isEmpty,
          let password = passwordTextField.text, !password.isEmpty else{
            print("Missing Field")
            return
          }
    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
      guard let strongSelf = self else {
        return
      }
      guard error == nil else{
        strongSelf.showCreation(email: email, password: password)
        return
      }
      print("Signed in")
    })
    let newViewController = LoginViewController()
    self.navigationController?.pushViewController(newViewController, animated: true)
  }
  func showCreation(email: String, password: String){
    let alert = UIAlertController(title: "Create this Account?",
                                  message: "Would you like to create an account with this email and password?",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Continue",
                                  style: .default,
                                  handler: {_ in
                                    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self]result, error in
                                      guard let strongSelf = self else {
                                        return
                                      }
                                      guard error == nil else{
                                        return
                                      }
                                      print("Signed in")
                                    })
      }))
    alert.addAction(UIAlertAction(title: "Cancel",
                                  style: .default,
                                  handler: {_ in
      }))
    present(alert, animated: true)
  }
  @objc private func cancelPressed(){
    let newViewController = LoginViewController()
    self.navigationController?.pushViewController(newViewController, animated: true)
  }

  
}
