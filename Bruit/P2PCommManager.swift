//
//  P2PCommManager.swift
//  Bruit
//
//  Created by Asanga Udugama on 14/02/16.
//

import Foundation
import MultipeerConnectivity

class P2PCommManager: NSObject {
    var commManagerDelegate: P2PCommManagerDelegate?
    
    fileprivate var serviceName:String?
    fileprivate var myPeerId: MCPeerID?
    fileprivate var serviceAdvertiser : MCNearbyServiceAdvertiser?
    fileprivate var serviceBrowser : MCNearbyServiceBrowser?
    
 
    override init() {
        super.init()
        
        serviceName = "keetchi"
        myPeerId = MCPeerID(displayName: UIDevice.current.name)
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId!, discoveryInfo: nil,
            serviceType: serviceName!)
        serviceAdvertiser!.delegate = self
        
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId!, serviceType: serviceName!)
        serviceBrowser!.delegate = self
        
    }

    deinit {
        serviceAdvertiser!.stopAdvertisingPeer()
    }
    
    func startP2PCommManager() {
        
        serviceAdvertiser!.startAdvertisingPeer()
        serviceBrowser!.startBrowsingForPeers()
        
        print("P2P communications started ...")
        
    }
    
    func sendMessageToAllPeers(_ messageData: Data) {
        print("sendMessageToAllPeers")
        
        let itemDict: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: messageData) as! NSDictionary
        
        
        print("trying to send \(itemDict["messageType"]) message")
        print("     \(itemDict["dataName"])")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(messageData, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
            } catch _ {
                print("sendMessageToAllPeers error")
            }
        } else {
            print("no connected peers, therefore item not sent")
        }
        
        
        
        
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId!, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.required)
        session.delegate = self
        return session
    }()


}

extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
            case .notConnected:
                return "NotConnected"
            case .connecting:
                return "Connecting"
            case .connected:
                return "Connected"
        }
    }
}

extension P2PCommManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    
        print("didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
}

extension P2PCommManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
                                    
        NSLog("%@", "foundPeer: \(peerID.displayName)")
        NSLog("%@", "invitePeer: \(peerID.displayName)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        print("lostPeer: \(peerID)")
        
    }
}

extension P2PCommManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.stringValue())")
        commManagerDelegate?.processNewNeighbourList(session.connectedPeers.map({$0.displayName}))
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: ")
        commManagerDelegate?.receivedMessage(data)
        
    }

    func session(_ session: MCSession, didReceive stream: InputStream,
                            withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String,
                    fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
}

protocol P2PCommManagerDelegate {
    func receivedMessage(_ messageData: Data)
    func processNewNeighbourList(_ neighbourList: [String])
}
