/*
 MIT License

 Copyright (c) 2017-2018 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import CoreLocation
import MessageKit

private struct CoordinateItem: LocationItem {

    var location: CLLocation
    var size: CGSize

    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }

}

private struct ImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}

internal struct MockMessage: MessageType {

    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    public var textMessage : String?
    public var senderName : String?
    public var senderImage : String?
    public var senderId : String?
    public var receiverName : String?
    public var receiverLocation : String?
    public var receiverImage : String?
    public var receiverId : String?
    public var receiverFcmToken : String?
    public var messageTime : String?
    public var senderFcmToken : String?
    public var senderLocation : String?

    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    /*public static func modelsFromDictionaryArray(array:NSArray,text: String,kind: MessageKind, sender: Sender, messageId: String, date: Date) -> [MockMessage]
    {
        var models:[MockMessage] = []
        for item in array
        {
            //models.append(MockMessage(dictionary: item as! NSDictionary)!)
            models.append(MockMessage(dictionary: item as! NSDictionary, kind: .text(text), sender: sender, messageId: messageId, date: date))
        }
        return models
    }
    
    init(dictionary: NSDictionary, kind: MessageKind, sender: Sender, messageId: String, date: Date)
    {
        textMessage = dictionary[kTextMessage] as? String
        senderName = dictionary[kSenderName] as? String
        senderImage = dictionary[kSenderImage] as? String
        senderId = dictionary[kSenderId] as? String
        receiverName = dictionary[kReceiverName] as? String
        receiverLocation = dictionary[kReceiverLocation] as? String
        receiverImage = dictionary[kReceiverImage] as? String
        receiverId = dictionary[kReceiverId] as? String
        receiverFcmToken = dictionary[kReceiverFcmToken] as? String
        messageTime = dictionary[kMessageTime] as? String
        senderFcmToken = dictionary[kSenderFcmToken] as? String
        senderLocation = dictionary[kSenderLocation] as? String
        
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }*/
    
    init(custom: Any?, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .custom(custom), sender: sender, messageId: messageId, date: date)
    }

    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }

    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        //self.textMessage = attributedText as? String
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }

    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }

    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date)
    }

    init(location: CLLocation, sender: Sender, messageId: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date)
    }

    init(emoji: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
}
