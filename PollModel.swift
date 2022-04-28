// class to hold an array of polls inside of it.
// used for local storage of polling type objects
// future use could help the user look bakc on any decision that was made with more clarity
// by deploying

import Foundation
import SwiftUI

class PollModel {
  var items : [Poll] = [Poll]()
  
  // basic function that returns the users poll from their input/ using the poll id
  func getPoll(id: String) -> Poll
  {
    var tmpPoll : Poll? = nil // temp variable used for return
    for p in items { // loop through array and find poll
      if(p.idNum == id){
        tmpPoll! = p
      }
    }
    return tmpPoll! // return poll with matching id that was entered
  }
  
  func getIdFromIndex(index: Int) -> String { //if known the index inside of the poll array, get polling ID
    return (items[index].getId())
  }
  func addPoll(poll : Poll) {// adds poll to end of the array list. 
    items.append(poll)
  }
}
