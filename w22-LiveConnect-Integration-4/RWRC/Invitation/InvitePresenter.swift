//
//  InvitePresenter.swift
//  LiveConnect
//
//  Created by Jake Stone on 3/1/22.
//  invitePresenter Class taken from tutorial. class is used to set up strucutre of invite links
//
//  Copyright (c) 2019 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import MessageUI
import Foundation


struct InviteContent {

  var subject: String?
  var body: String?
  var link: URL

}

protocol InvitePresenter {

  var name: String { get }
  var icon: UIImage? { get }
  var isAvailable: Bool { get }
  var content: InviteContent { get }

  init(content: InviteContent, presentingController: UIViewController)
    
  func sendInvite()

}
//gets list of medias to use
func DefaultInvitePresenters(presentingController: UIViewController) -> [InvitePresenter] {
  let url = URL(string: "https://github.com/ricecor/w22-LiveConnect")!
  return [
    EmailInvitePresenter(
      content: InviteContent(
        subject: "Check out LiveConnect!",
        body: "Come make fun groups with me and attend cool events together! ",
        link: url
      )
      , presentingController: presentingController
    ),
    SocialDeepLinkInvitePresenter(
      content: InviteContent(
        subject: nil,
        body: "Come join me on LiveConnect, An event planning platform! ",
        link: url
      ),
      presentingController: presentingController
    ),
    TextMessageInvitePresenter(
      content: InviteContent(
        subject: nil,
        body: "Check out LiveConnect, The event planning masterpiece app ",
        link: url
      ),
      presentingController: presentingController
    ),
    CopyLinkInvitePresenter(
      content: InviteContent(
        subject: nil,
        body: nil,
        link: url
      ), presentingController: presentingController
    ),
    OtherInvitePresenter(
      content: InviteContent(
        subject: nil,
        body: "Check out LiveConnect, The event planning masterpiece app ",
        link: url
      ),
      presentingController: presentingController
    )
  ]
}

final class EmailInvitePresenter: NSObject, InvitePresenter, MFMailComposeViewControllerDelegate {

  let name = "Email"

  var icon: UIImage? {
    return UIImage(named: "email")
  }

  let content: InviteContent

  private let presentingController: UIViewController

  var isAvailable: Bool {
    return MFMailComposeViewController.canSendMail()
  }

  private weak var mailController: MFMailComposeViewController? = nil

  required init(content: InviteContent, presentingController: UIViewController) {
    self.content = content
    self.presentingController = presentingController
  }

  func sendInvite() {
    let mailUI = MFMailComposeViewController()
    mailUI.mailComposeDelegate = self

    mailUI.setSubject(content.subject ?? "")
    mailUI.setMessageBody((content.body ?? "") + content.link.absoluteString, isHTML: false)

    mailController = mailUI

    presentingController.present(mailUI, animated: true, completion: nil)
  }

  func mailComposeController(_ controller: MFMailComposeViewController,
                             didFinishWith result: MFMailComposeResult,
                             error: Error?) {
    if let error = error {
      print("Error sending mail invite: \(error)")
    }
    mailController?.dismiss(animated: true, completion: nil)
    mailController?.mailComposeDelegate = nil
    mailController = nil
  }

}

final class SocialDeepLinkInvitePresenter: InvitePresenter {

  let name = "Social"

  var icon: UIImage? {
    return UIImage(named: "social")
  }

  // This url is provided for the sake of example, this isn't actually a viable
  // url for deep linking into Twitter.
  private var socialBaseURL = URL(string: "twitter://compose")!

  lazy private(set) var isAvailable: Bool = {
    return UIApplication.shared.canOpenURL(socialBaseURL)
  }()

  var content: InviteContent

  required init(content: InviteContent, presentingController: UIViewController) {
    self.content = content
  }

  func sendInvite() {
    let queryItems = [
      URLQueryItem(name: "body", value: (content.body ?? "") + content.link.absoluteString)
    ]
    var components = URLComponents(url: socialBaseURL, resolvingAgainstBaseURL: true)
    components?.queryItems = queryItems

    if let url = components?.url {
      UIApplication.shared.open(url, options: [.universalLinksOnly: true], completionHandler: nil)
    } else {
      fatalError("Unable to build deep link url with content \(content)")
    }
  }

}

final class TextMessageInvitePresenter: NSObject, InvitePresenter, MFMessageComposeViewControllerDelegate {

  let name = "Message"

  var icon: UIImage? {
    return UIImage(named: "sms")
  }

  let content: InviteContent

  private let presentingController: UIViewController

  var isAvailable: Bool {
    return MFMessageComposeViewController.canSendText()
  }

  private weak var messageController: MFMessageComposeViewController? = nil

  required init(content: InviteContent, presentingController: UIViewController) {
    self.content = content
    self.presentingController = presentingController
  }

  func sendInvite() {
    let messageUI = MFMessageComposeViewController()
    messageUI.messageComposeDelegate = self

    // Sending texts discards the content's subject line, if there is one.
    messageUI.body = (content.body ?? "") + content.link.absoluteString

    messageController = messageUI

    presentingController.present(messageUI, animated: true, completion: nil)
  }

  func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                    didFinishWith result: MessageComposeResult) {
    messageController?.dismiss(animated: true, completion: nil)
    messageController?.messageComposeDelegate = nil
    messageController = nil
  }

}

final class CopyLinkInvitePresenter: InvitePresenter {

  let name = "Copy Link"

  var icon: UIImage? {
    return UIImage(named: "copy")
  }

  var isAvailable: Bool {
    return true
  }

  var content: InviteContent

  required init(content: InviteContent, presentingController: UIViewController) {
    self.content = content
  }

  func sendInvite() {
    UIPasteboard.general.string = content.link.absoluteString
    // Display a "Link copied!" dialogue here.
    print("Link copied!")
  }

}

final class OtherInvitePresenter: InvitePresenter {

  let name = "More"

  var icon: UIImage? {
    return UIImage(named: "more")
  }

  var isAvailable: Bool {
    return true
  }

  var content: InviteContent

  private let presentingController: UIViewController

  init(content: InviteContent, presentingController: UIViewController) {
    self.content = content
    self.presentingController = presentingController
  }

  lazy private var activityController: UIActivityViewController = {
    var activities: [Any] = []
    [content.subject, content.body].forEach {
      if let value = $0 {
        activities.append(value)
      }
    }
    activities.append(content.link)

    let controller = UIActivityViewController(activityItems: activities,
                                              applicationActivities: nil)
    return controller
  }()

  func sendInvite() {
    presentingController.present(activityController, animated: true, completion: nil)
  }

}
