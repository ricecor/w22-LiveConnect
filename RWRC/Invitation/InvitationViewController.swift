//
//  InvitationViewController.swift
//  LiveConnect
//
//  Created by Jake Stone on 3/1/22.
//

import UIKit

class InvTableViewCell: UITableViewCell{
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func populate(with presenter: InvitePresenter) {
      iconView.image = presenter.icon
      nameLabel.text = presenter.name
    }
    
}

class InvitationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: InviteTableViewDataSource! = nil
    private var delegate: InviteTableViewDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = InviteTableViewDataSource(invitePresenters:
            DefaultInvitePresenters(presentingController: self))
        delegate = InviteTableViewDelegate(invitePresenters:
            DefaultInvitePresenters(presentingController: self))

        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      tableView.reloadData()
    }
    
    deinit {
          tableView.dataSource = nil
          tableView.delegate = nil
    }
    
}

class InviteTableViewDelegate: NSObject, UITableViewDelegate {

      let invitePresenters: [InvitePresenter]

      @available(*, unavailable)
      public override init() {
        fatalError()
      }

      required public init(invitePresenters: [InvitePresenter]) {
        self.invitePresenters = invitePresenters
      }

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        invitePresenters.filter { $0.isAvailable } [indexPath.row].sendInvite()
      }

}

class InviteTableViewDataSource: NSObject, UITableViewDataSource {

      let invitePresenters: [InvitePresenter]

      @available(*, unavailable)
      public override init() {
        fatalError()
      }

      required public init(invitePresenters: [InvitePresenter]) {
        self.invitePresenters = invitePresenters
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitePresenters.filter { $0.isAvailable } .count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "InvTableViewCell", for: indexPath)
              as! InvTableViewCell
          cell.populate(with: invitePresenters.filter { $0.isAvailable} [indexPath.row])
          return cell
        }
  }


