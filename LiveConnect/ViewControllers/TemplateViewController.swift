//
//  TemplateViewController.swift
//  LiveConnect
//
//  Created by Jake Stone on 2/13/22.
//

import UIKit

class TemplateViewController: UIViewController {

    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var Description: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
