

import UIKit

class PollTableViewCell: UITableViewCell {
  // basic table view cell used for formatting of polls.
  // three outlets into the .xib file, the option label, the count label that displays the amount of votes that the specific option has at the time
  // the vote button that increments the count for the option by one. shown in ChoosePollViewController

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var Votebutton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
  var count: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
