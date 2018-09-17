//
//  BroadcastViewController.swift
//  HMWebRTC_Example
//
//  Created by Ayyappa Salla on 16/09/18.
//  Copyright © 2018 TRAN DIEP Hue Man. All rights reserved.
//

import Foundation
import UIKit
import ReplayKit
import WebRTC
import HMWebRTC

class BroadcastViewController : UIViewController {
    
    var client:ARDAppClient!
    var capturer:ARDExternalSampleCapturer!
    
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var roomNameLabel: UILabel!
    override func viewDidLoad() {
        let model: ARDSettingsModel = ARDSettingsModel()
        client = ARDAppClient.init(delegate: self)
        client?.isBroadcast = true
        //client?.roomId = 577634885
        let randNumber = arc4random_uniform(1000)
        let roomName = "broadcast_" + String(Int(randNumber))
        self.roomNameLabel.text = roomName
        client?.connectToRoom(withId: roomName, settings: model, isLoopback: false)
        let url = URL.init(string: "https://www.google.com")
        let urlRequest = URLRequest(url: url!)
        self.webview.loadRequest(urlRequest)
    }
    @IBAction func startPressed(_ sender: Any) {
        if #available(iOS 11.0, *) {
            RPScreenRecorder.shared().startCapture(handler: { (sample, bufferType, error) in
                switch (bufferType) {
                case .video:
                    print("device video")
                    self.capturer!.didCapture(sample)
                break
                case .audioApp:
                    //self.capturer!.didCapture(sample)
                    print("device audio")
                break
                case .audioMic:
                    print("mic")
                break
                }
            })
        } else {
            print("yikes - thats not a ios 11 or higher device")
        }
    }
}

extension BroadcastViewController: ARDAppClientDelegate {
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        print("appClient ARDAppClientState state : \(state)")
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: RTCIceConnectionState) {
        print("appClient RTCIceConnectionState state : \(state)")
    }
    
    func appClient(_ client: ARDAppClient!, didCreateLocalCapturer localCapturer: RTCCameraVideoCapturer!) {
        print("appClient didCreateLocalCapturer")
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        print("appClient didReceiveLocalVideoTrack")
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        print("appClient didReceiveRemoteVideoTrack")

    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        print("appClient didError \(error)")
    }
    
    func appClient(_ client: ARDAppClient!, didGetStats stats: [Any]!) {
        print("appClient didGetStats \(stats)")
    }
    
    func appClient(_ client: ARDAppClient!,
                   didCreateLocalExternalSampleCapturer externalSampleCapturer: ARDExternalSampleCapturer) {
        self.capturer = externalSampleCapturer
        print("appClient didCreateLocalExternalSampleCapturer")
    }
}
