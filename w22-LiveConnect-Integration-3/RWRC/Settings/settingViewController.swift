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
import FirebaseAuth

final class settingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var prefButton: UIButton!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var birthPicker: UIDatePicker!
    @IBOutlet weak var langPicker: UIPickerView!
    @IBOutlet weak var langSelection: UILabel!
    var langPickerData: [String] = [String]()

    override func viewDidLoad() {
      super.viewDidLoad()

      self.langPicker.delegate = self
      self.langPicker.dataSource = self

      langPickerData = ["English", "Spanish (Coming Soon!)", "Mandarin (Coming Soon!)", "French (Coming Soon!)", "Russian (Not Coming as Soon!)"]
    }

  @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }

  func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return langPickerData.count
    }

  internal func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return langPickerData[row]
      }
  }
//  func loanLabelTap() {
//      let tapSelect = UITapGestureRecognizer(target: self, action: #selector(self.pickerTapped))
//      self.langSelection.isUserInteractionEnabled = true
//      self.langSelection.addGestureRecognizer(tapSelect)
//  }
//
//  @objc func pickerTapped(sender: UITapGestureRecognizer){
//      print("gesture recognizer tapped.")
//      self.langPicker.isHidden = false
//      self.lPickerData = ["English", "Spanish (Coming Soon!)", "Mandarin (Coming Soon!)", "French (Coming Soon!)", "German (Coming Soon!)", "Russian (Coming Soon!)"]
//      self.langPicker.reloadAllComponents()
//      self.langPicker.isHidden = false
//      self.isLang = true
//
//  }
//}

//extension settingViewController: UIPickerViewDataSource, UIPickerViewDelegate{
//  func numberOfComponents(in: UIPickerView) -> Int
//  {
//      return 1
//  }
//
//  // The number of rows of data
//  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
//  {
//      return lPickerData.count
//  }
//
//  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
//  {
//      return self.lPickerData[row]
//  }
//
//  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
//  {
//      if self.isLang{
//        self.langSelection.text = self.lPickerData[row]
//          self.lSelect = self.lPickerData[row]
//      }
//  }
//
//}

