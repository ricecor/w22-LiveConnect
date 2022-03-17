//
//  TemplateViewController.swift
//  LiveConnect
//
//  Created by Jake Stone on 2/13/22.
//

import UIKit
import FirebaseDynamicLinks

class TemplateViewController: UIViewController {

    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var Description: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var InviteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    lazy private var shareController: UIActivityViewController = {
       let activities: [Any] = [
         "Learn how to share content via liveConneect",
         URL(string: "https://github.com/ricecor/w22-LiveConnect")!
       ]
       let controller = UIActivityViewController(activityItems: activities,
                                                 applicationActivities: nil)
       return controller
     }()
    
    func generateContentLink() -> URL {
        let baseURL = URL(string: "https://installliveconnect.page.link/jTpt")!
        let domain = "https://installliveconnect.page.link/JTpt"
        let linkBuilder = DynamicLinkComponents(link: baseURL, domainURIPrefix: domain)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "LiveConnectW22.LiveConnect")


        // Fall back to the base url if we can't generate a dynamic link.
        return linkBuilder?.link ?? baseURL
      }
    
    @IBAction func InvitePressed(_ sender: Any) {
        let inviteController = UIStoryboard(name: "Main", bundle: nil)
          .instantiateViewController(withIdentifier: "InvitationViewController")
        self.navigationController?.pushViewController(inviteController, animated: true)
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
