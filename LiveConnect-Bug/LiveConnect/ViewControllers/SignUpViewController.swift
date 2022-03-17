//
//  SignUpViewController.swift
//  LiveConnect
//
//  Created by Jake Stone on 2/11/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var First: UITextField!
    @IBOutlet weak var Last: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var ErrorMessage: UILabel!
    
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

    @IBAction func NextTapped(_ sender: Any) {
    }
}
