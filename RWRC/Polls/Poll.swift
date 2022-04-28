

import Foundation
import FirebaseFirestore

//Poll structure has all variables of the poll needed
struct Poll{
  
  var idNum: String
  var name: String?
  var ExpireDate: Date?
  var SC : Bool?
  
  var option1: String?
  var option2: String?
  var option3: String?
  var option4: String?
  var option5: String?
  
  
  var countArray : Array<Int> = [0,0,0,0,0]

  // initializer functions
  init(idNum: String, name: String?, ExpireDate: Date?, SC: Bool?, option1: String?,
       option2: String?, option3: String?, option4: String?, option5: String?,
       countArray: Array<Int>){
    
    self.idNum = idNum
    self.name = name
    self.ExpireDate = ExpireDate
    self.SC = SC
    
    self.option1 = option1
    self.option2 = option2
    self.option3 = option3
    self.option4 = option4
    self.option5 = option5
    
    self.countArray[0] = 0
    self.countArray[1] = 0
    self.countArray[2] = 0
    self.countArray[3] = 0
    self.countArray[4] = 0
  }
  
  // intializer functions
  init(){
    self.init(idNum: "Error", name: nil, ExpireDate: nil, SC: nil, option1: nil,
              option2: nil, option3: nil, option4: nil, option5: nil,
              countArray: [0, 0, 0, 0, 0])
  }
  // gets ID num as String
  func getId() -> String {
    return idNum
  }
  //called from vote button to add to the count
  //IMPORTANT: THe user only has one chance to submit and they are not allowed to go back and vote again.
  //no cancel function deployed yet
  mutating func addToCount(index: Int) {
    countArray[index]+=1
  }
}

// sets up poll to be sent to the database for firebase. sent as [String: Any] type
extension Poll: DatabaseRepresentation{
  var representation: [String: Any] {
    let rep: [String: Any] = [
      "Title": name!,
      "Expires": ExpireDate!,
      "Single or Multiple Choice?": SC!,
      "Option1": option1 as Any,
      "Option2": option2 as Any,
      "Option3": option3 as Any,
      "Option4": option4 as Any,
      "Option5": option5 as Any,
      "Counts": countArray
      
    ]
    
    return rep
  }
}
