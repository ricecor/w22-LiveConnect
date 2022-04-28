// large controller that send the user to the polling screen (creation and taking), the upload picture feature and out to the home screen.

import UIKit
import Photos
import Firebase
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import SwiftUI

final class ChatViewController: MessagesViewController { // based off of MessageKit View controller. located within package dependencies
  
  private var isSendingPhoto = false {
    didSet {
     
      messageInputBar.leftStackViewItems.forEach { item in
        guard let item = item as? InputBarButtonItem else {
          return // intializes input bar items
        }
        item.isEnabled = !self.isSendingPhoto
      }
    }
  }

  // database variables
  private let database = Firestore.firestore()
  private var reference: CollectionReference?
  private let storage = Storage.storage().reference()

  // message variable used to sedn the message each time
  private var messages: [Message] = []
  private var messageListener: ListenerRegistration? // listens to database for updates

  // user and channel varibles used for sending messages
  private let user: User
  private let channel: Channel
  
  deinit {// once exited out fo the function turns off the listener
    messageListener?.remove()
  }

  // requied init
  init(user: User, channel: Channel) {
    self.user = user
    self.channel = channel
    super.init(nibName: nil, bundle: nil)

    title = channel.name
  }

  //required init
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    listenToMessages() //check for updates
    navigationItem.largeTitleDisplayMode = .never // we dont like big titles
    setUpMessageView() // sets up screeen
    removeMessageAvatars() // removes avtar pictures on the side of the screen to allow more room for user messages
    addCameraBarButton() // adds camera AND polling buttons to screen
  }

  private func listenToMessages() {
    guard let id = channel.id else { // if no id, pop out to the chat view controller
      navigationController?.popViewController(animated: true)
      return
    }

    reference = database.collection("channels").document(id).collection("thread") // used for database listening

    // set up listener
    messageListener = reference?.addSnapshotListener { [weak self] querySnapshot, error in
      guard let self = self else { return }
      guard let snapshot = querySnapshot else {
        print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
        return
      }

      snapshot.documentChanges.forEach { change in
        self.handleDocumentChange(change) // call function to handle all changes associated with document
      }
    }
  }
  
  private func getUser() -> UserInfo{ // simple get functions
    return self.user
  }

  private func setUpMessageView() { // sets up screen programatically
    maintainPositionOnKeyboardFrameChanged = true
    messageInputBar.inputTextView.tintColor = .primary
    messageInputBar.sendButton.setTitleColor(.primary, for: .normal)

    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }

  private func removeMessageAvatars() { // removes message avatars and pcitues
    guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else {
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

  private func addCameraBarButton() { // adds camera, polling and take poll nav items to view
    let cameraItem = InputBarButtonItem(type: .system)
    cameraItem.tintColor = .primary
    cameraItem.image = UIImage(named: "camera")
    cameraItem.addTarget(
      self,
      action: #selector(cameraButtonPressed),
      for: .primaryActionTriggered)
    cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
    
    //reusing code from camera button
    let pollItem = InputBarButtonItem(type: .system)
    pollItem.tintColor = .primary
    pollItem.image = UIImage(named: "poll")
    pollItem.addTarget(self,
                       action: #selector(pollButtonPressed), for: .primaryActionTriggered)
    pollItem.setSize(CGSize(width: 60, height: 30), animated: false)
    
    //upper right corner button. used for taking polls
    UIBarButtonItem(title: channel.name, style: .plain, target: self, action: nil)
    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let takePoll = UIBarButtonItem(title:"Take Poll", style: .plain, target: self, action: #selector(takePollPressed))
    
    self.navigationItem.setRightBarButton(takePoll,  animated: true)
   
    
    let items = [
      cameraItem,
      pollItem
      ]
    
    messageInputBar.leftStackView.alignment = .center
    messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: false)
    messageInputBar.setStackViewItems(items, forStack: .left, animated: false)
    reloadInputViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isToolbarHidden = false
  }
  
  // MARK: - Actions
  @objc private func cameraButtonPressed() {
    let picker = UIImagePickerController()
    picker.delegate = self

    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    } else {
      picker.sourceType = .photoLibrary
    }

    present(picker, animated: true)
  }
  
  @objc private func pollButtonPressed() {
    let newViewController = PollingViewController()
    self.navigationController?.pushViewController(newViewController, animated: true)
    let gassy : Message = Message(user: self.user, content: "Hey come check out the poll I created! Just hit the poll button and enter this code to access the poll:")
    self.save(gassy)
    
  }
  

  @objc private func takePollPressed(_ sender: Any){
    let newVC = ChoosePollViewController()
    self.navigationController?.pushViewController(newVC, animated: true)
   
  }


  // MARK: - Helpers
  private func save(_ message: Message) {
    reference?.addDocument(data: message.representation) { [weak self] error in
      guard let self = self else { return }
      if let error = error {
        print("Error sending message: \(error.localizedDescription)")
        return
      }
      self.messagesCollectionView.scrollToLastItem(animated: true)
    }
  }

  private func insertNewMessage(_ message: Message) {
    if messages.contains(message) {
      return
    }

    messages.append(message)
    messages.sort()

    let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage

    messagesCollectionView.reloadData()

    if shouldScrollToBottom {
      messagesCollectionView.scrollToLastItem(animated: true)
    }
  }

  private func handleDocumentChange(_ change: DocumentChange) {
    guard var message = Message(document: change.document) else {
      return
    }

    switch change.type {
    case .added:
      if let url = message.downloadURL {
        downloadImage(at: url) { [weak self] image in
          guard
            let self = self,
            let image = image
          else {
            return
          }
          message.image = image
          self.insertNewMessage(message)
        }
      } else {
        insertNewMessage(message)
      }
    default:
      break
    }
  }

  private func uploadImage(
    _ image: UIImage,
    to channel: Channel,
    completion: @escaping (URL?) -> Void
  ) {
    guard
      let channelId = channel.id,
      let scaledImage = image.scaledToSafeUploadSize,
      let data = scaledImage.jpegData(compressionQuality: 0.4)
    else {
      return completion(nil)
    }

    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
    let imageReference = storage.child("\(channelId)/\(imageName)")
    imageReference.putData(data, metadata: metadata) { _, _ in
      imageReference.downloadURL { url, _ in
        completion(url)
      }
    }
  }

  private func sendPhoto(_ image: UIImage) {
    isSendingPhoto = true

    uploadImage(image, to: channel) { [weak self] url in
      guard let self = self else { return }
      self.isSendingPhoto = false

      guard let url = url else {
        return
      }

      var message = Message(user: self.user, image: image)
      message.downloadURL = url

      self.save(message)
      self.messagesCollectionView.scrollToLastItem()
    }
  }

  private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
    let ref = Storage.storage().reference(forURL: url.absoluteString)
    let megaByte = Int64(1 * 1024 * 1024)

    ref.getData(maxSize: megaByte) { data, _ in
      guard let imageData = data else {
        completion(nil)
        return
      }
      completion(UIImage(data: imageData))
    }
  }
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? .primary : .incomingMessage
  }

  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
    return false
  }

  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    avatarView.isHidden = true
  }

  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(corner, .curved)
  }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 20
  }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }

  func currentSender() -> SenderType {
    return Sender(senderId: user.uid, displayName: AppSettings.displayName)
  }

  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
  }

  func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let name = message.sender.displayName
    return NSAttributedString(
      string: name,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor(white: 0.3, alpha: 1)
      ])
  }
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    let message = Message(user: user, content: text)
    save(message)
    inputBar.inputTextView.text = ""
  }
}

// MARK: - UIImagePickerControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    picker.dismiss(animated: true)

    if let asset = info[.phAsset] as? PHAsset {
      let size = CGSize(width: 500, height: 500)
      PHImageManager.default().requestImage(
        for: asset,
        targetSize: size,
        contentMode: .aspectFit,
        options: nil
      ) { result, _ in
        guard let image = result else {
          return
        }
        self.sendPhoto(image)
      }
    } else if let image = info[.originalImage] as? UIImage {
      sendPhoto(image)
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}
