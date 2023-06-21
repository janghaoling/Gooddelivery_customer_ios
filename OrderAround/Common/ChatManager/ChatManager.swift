//
//  ChatManager.swift
//  orderAround
//
//  Created by Rajes on 14/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import Foundation
import PubNub

fileprivate let publishKey = "pub-c-ad0dc654-a0e9-43e7-93b1-60edac08b082"
fileprivate let subscribeKey = "sub-c-60ee60f8-a398-11e7-af4e-0a68e4e3f63a"

protocol ChatProtocol:class {
    func getMessageList(message:[MessageDetails])
}

class ChatManager : PubNub, PNObjectEventListener {
    
    private var channel:String!
    
    weak var delegate:ChatProtocol?
    
    static let shared: ChatManager = {
        var config = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        config.uuid = UUID().uuidString
        config.presenceHeartbeatValue = 5
        let pubNubObj = ChatManager.clientWithConfiguration(config)
        pubNubObj.addListener(pubNubObj)
        return pubNubObj
    }()
    
    func setChannelWithChannelID(channelID:String) {
        ChatManager.shared.subscribeToChannels([channelID], withPresence: true)
        ChatManager.shared.subscribeToPresenceChannels([channelID])
        channel = channelID
    }
    
    func leftFromChatRoom(){
        guard let currentChannel = channel else { return  }
        ChatManager.shared.unsubscribeFromPresenceChannels([currentChannel])
    }
    
    func getCurrentRoomChatHistory(){
        
        guard let currentChannel = channel else { return  }
        ChatManager.shared.historyForChannel(currentChannel, start: nil, end: nil, limit: 50, reverse: false) { (chatResponse, chatError) in
            let jsonData = try? JSONSerialization.data(withJSONObject:chatResponse?.data.messages)
            do {
                //here dataResponse received from a network request
                let model = try JSONDecoder().decode([MessageDetails].self, from:jsonData ?? Data()) //Decode JSON Response Data
                if let _ = self.delegate {
                    self.delegate?.getMessageList(message: model)
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
    }
    
    func sentMessage(message:String) {
        guard let currentChannel = channel else { return  }
        let userDic = ["Metadata":"user"]
        let sendMsgDic = ["type":"user","message":"\(message)"]
        ChatManager.shared.publish(sendMsgDic, toChannel: currentChannel, storeInHistory: true, withMetadata: userDic) { (responseStatus) in
            //print("mesaage status \(responseStatus)")
            self.getCurrentRoomChatHistory()
        }
    }
    
    
    // MARK: - PNObjectEventListener
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        // This is a good place to deal with unexpected status messages like
        // network failures
        print(status)
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        // This most likely won't be used here, but in any relevant view controllers
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        // This most likely won't be used here, but in any relevant view controllers
    }
}
