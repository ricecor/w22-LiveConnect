//
//  PollViewController.swift
//  LiveConnect
//
//  Created by Jake Stone on 3/17/22.
//

import UIKit

struct Question {
    var questionString: String?
    var answers: [String]?
    var selectedAnswerIndex: Int?
}

class PollViewController: UITableViewController {

    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var question = Question(questionString: "What is your favorite type of food?", answers: ["Mexican", "Asian", "American", "Italian"], selectedAnswerIndex: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(AnswerCell.self, forCellReuseIdentifier: cellId)
        tableView.register(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = question.answers?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath) as! AnswerCell
        cell.nameLabel.text = question.answers?[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! QuestionHeader
        header.nameLabel.text = question.questionString
        return header
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        question.selectedAnswerIndex = indexPath.row
        
        let controller = ResultsController()
        controller.question = question
        navigationController?.pushViewController(controller, animated: true)
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

class ResultsController: UIViewController {
    
    var question: Question? {
        didSet {
            
            let types = ["Mexican", "American", "Italian", "Chinese", "Indian",]
            
            let result = types[question!.selectedAnswerIndex!]
            resultsLabel.text = "Wow, you like \(result)? Me too!"
        }
    }

    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations, you just asnwered a poll!!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
        }()

        override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Results"

        view.backgroundColor = UIColor.white

        view.addSubview(resultsLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
            
            let controller2 = HomeViewController()
            navigationController?.pushViewController(controller2, animated: true)
        }
    
   
    
}

class QuestionHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Question"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AnswerCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Answer"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
}


