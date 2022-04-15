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

import Foundation

class Poll{
  
  static let instance1 = Poll()
  
  var idNum: Int? // use in hardcoded version before firstore database is implemented
  var name: String?
  var ExpireDate: Date?
  var SC : Bool?
  
  var option1: String?
  var option2: String?
  var option3: String?
  var option4: String?
  var option5: String?
  
  var o1Count: Int?
  var o2Count: Int?
  var o3Count: Int?
  var o4Count: Int?
  var o5Count: Int?
  
  init(idNum: Int?, name: String?, ExpireDate: Date?, SC: Bool?, option1: String?,
       option2: String?, option3: String?, option4: String?, option5: String?,
       o1Count: Int?, o2Count: Int?, o3Count: Int?, o4Count: Int?, o5Count: Int?){
    
    self.idNum = idNum
    self.name = name
    self.ExpireDate = ExpireDate
    self.SC = SC
    self.option1 = option1
    self.option2 = option2
    self.option3 = option3
    self.option4 = option4
    self.option5 = option5
    
    self.o1Count = o1Count
    self.o2Count = o2Count
    self.o3Count = o3Count
    self.o4Count = o4Count
    self.o5Count = o5Count
  }
  
  convenience init(){
    self.init(idNum: nil, name: nil, ExpireDate: nil, SC: nil, option1: nil,
              option2: nil, option3: nil, option4: nil, option5: nil,
              o1Count: 0, o2Count: 0, o3Count: 0, o4Count: 0, o5Count: 0)
  }
}
