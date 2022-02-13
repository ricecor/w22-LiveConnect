/// Copyright (c) 2021 Razeware LLC
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

import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

final class ChatViewController: MessagesViewController {
  private let user: User
  private let channel: Channel
  private var messages: [Message] = []
  private var messageListener: ListenerRegistration?
  private let database = Firestore.firestore()
  private var reference: CollectionReference?


  init(user: User, channel: Channel) {
    self.user = user
    self.channel = channel
    super.init(nibName: nil, bundle: nil)

    title = channel.name
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  deinit {
    messageListener?.remove()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    listenToMessages()
    navigationItem.largeTitleDisplayMode = .never
    setUpMessageView()
    removeMessageAvatars()

  }
  private func listenToMessages() {
    guard let id = channel.id else {
      navigationController?.popViewController(animated: true)
      return
    }

    reference = database.collection("channels/\(id)/thread")
    messageListener = reference?
      .addSnapshotListener { [weak self] querySnapshot, error in
        guard let self = self else { return }
        guard let snapshot = querySnapshot else {
          print("""
            Error listening for channel updates: \
            \(error?.localizedDescription ?? "No error")
            """)
          return
        }

        snapshot.documentChanges.forEach { change in
          self.handleDocumentChange(change)
        }
      }

  }
  

  

  // MARK: - Helpers
  private func save(_ message: Message) {
    reference?.addDocument(data: message.representation) { [weak self] error in
      guard let self = self else { return }
      if let error = error {
        print("Error sending message: \(error.localizedDescription)")
        return
      }
      self.messagesCollectionView.scrollToLastItem()
    }
  }

  private func insertNewMessage(_ message: Message) {
    if messages.contains(message) {
      return
    }
    messages.append(message)
    messages.sort()

    let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
    let shouldScrollToBottom =
      messagesCollectionView.isAtBottom && isLatestMessage

    messagesCollectionView.reloadData()

    if shouldScrollToBottom {
      messagesCollectionView.scrollToLastItem(animated: true)
    }
  }
  private func handleDocumentChange(_ change: DocumentChange) {
    guard let message = Message(document: change.document) else {
      return
    }

    switch change.type {
    case .added:
      insertNewMessage(message)
    default:
      break
    }
  }



  private func setUpMessageView() {
    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.inputTextView.tintColor = .primary
    messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self

  }
  private func removeMessageAvatars() {
    guard
      let layout = messagesCollectionView.collectionViewLayout
        as? MessagesCollectionViewFlowLayout
    else {
      return
    }
    layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
    layout.textMessageSizeCalculator.incomingAvatarSize = .zero
    layout.setMessageIncomingAvatarSize(.zero)
    layout.setMessageOutgoingAvatarSize(.zero)
    let incomingLabelAlignment = LabelAlignment(
      textAlignment: .left,
      textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
    layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
    let outgoingLabelAlignment = LabelAlignment(
      textAlignment: .right,
      textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
    layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
  }

}




// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
  // 1
  func backgroundColor(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> UIColor {
    return isFromCurrentSender(message: message) ? .primary : .incomingMessage
  }

  // 2
  func shouldDisplayHeader(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> Bool {
    return false
  }

  // 3
  func configureAvatarView(
    _ avatarView: AvatarView,
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) {
    avatarView.isHidden = true
  }

  // 4
  func messageStyle(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> MessageStyle {
    let corner: MessageStyle.TailCorner =
      isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(corner, .curved)
  }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
  // 1
  func numberOfSections(
    in messagesCollectionView: MessagesCollectionView
  ) -> Int {
    return messages.count
  }

  // 2
  func currentSender() -> SenderType {
    return Sender(senderId: user.uid, displayName: AppSettings.displayName)
  }

  // 3
  func messageForItem(
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> MessageType {
    return messages[indexPath.section]
  }

  // 4
  func messageTopLabelAttributedText(
    for message: MessageType,
    at indexPath: IndexPath
  ) -> NSAttributedString? {
    let name = message.sender.displayName
    return NSAttributedString(
      string: name,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor(white: 0.3, alpha: 1)
      ])
  }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
  // 1
  func footerViewSize(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  // 2
  func messageTopLabelHeight(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> CGFloat {
    return 20
  }
}


// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
  func inputBar(
    _ inputBar: InputBarAccessoryView,
    didPressSendButtonWith text: String
  ) {
    // 1
    let message = Message(user: user, content: text)

    // 2
    save(message)

    // 3
    inputBar.inputTextView.text = ""
  }

}


// MARK: - UIImagePickerControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {}
