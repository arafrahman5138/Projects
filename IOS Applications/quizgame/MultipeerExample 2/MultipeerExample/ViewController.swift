//
//  ViewController.swift
//  MultipeerExample
//
//  Created by Eyuphan Bulut on 4/5/19.
//  Copyright © 2017 Eyuphan Bulut. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var session: MCSession!
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    
    @IBOutlet weak var imgView: UIImageView!
    var picker: UIImagePickerController!
    
    @IBOutlet weak var chatWindow: UITextView!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var gameTypeSC: UISegmentedControl!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "chat17", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "chat17", discoveryInfo: nil, session: session)
        
        assistant.start()
        session.delegate = self
        browser.delegate = self
        
    }
    
    
    @IBAction func chooseGameType(_ sender: Any) {
        let getIndex = gameTypeSC.selectedSegmentIndex
        if getIndex == 0 {
            connectBtn.isEnabled = false
            playBtn.isEnabled = true
        }
        if getIndex == 1 {
            connectBtn.isEnabled = true
            playBtn.isEnabled = false
        }
    }
    
    @IBAction func playGame(_ sender: Any) {
        let start = NSKeyedArchiver.archivedData(withRootObject: "yes")
        do{
            try session.send(start, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        let msg = messageTF.text
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg!)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        
        updateChatView(newText: msg!, id: peerID)
        
    }
    
    func updateChatView(newText: String, id: MCPeerID){
        
        let currentText = chatWindow.text
        var addThisText = ""
        
        if(id == peerID){
            addThisText = "Me: " + newText + "\n"
        }
        else
        {
            addThisText = "\(id.displayName): \(newText)\n"
        }
        chatWindow.text = currentText! + addThisText
        
    }
    
    @IBAction func connect(_ sender: Any) {
        
        present(browser, animated: true, completion: nil)
        
    }
    
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
     //**********************************************************
    
    
    
    
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("inside didReceiveData")
        
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
        
            
            
        if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
            if receivedString == "yes" {
                print("YEESSSSSS")
                self.performSegue(withIdentifier: "toQuiz", sender: nil)
            }
            else {
            self.updateChatView(newText: receivedString, id: peerID)
            }
        }

        if let image = UIImage(data: data) {
                
            self.imgView.image = image
                
            self.updateChatView(newText: "received image", id: peerID)
                
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                
            }
         
        
        
        })
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        DispatchQueue.main.async(execute: {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            self.playBtn.isEnabled = true
            self.gameTypeSC.selectedSegmentIndex = 1
            self.chatWindow.text! += "Connected to \(peerID.displayName)\n"
            self.gameTypeSC.setEnabled(false, forSegmentAt: 0)
            self.connectBtn.titleLabel?.text = "Disconnect"
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Deafult")
        }
        })
        
    }
    
    func disableSinglePlayer() {
        
    }
    //**********************************************************

    @IBAction func sendImage(){
        picker = UIImagePickerController()
        picker.delegate  = self
        
        present(picker, animated: true, completion: nil)
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey: Any]) {
        
        let chosenImage = info[.originalImage] as! UIImage
        
        if let imageData = chosenImage.pngData() {
            do {
                try session.send(imageData, toPeers: session.connectedPeers, with: .reliable)
                
                updateChatView(newText: "sending image", id: peerID)
                
            } catch let error as NSError {
                let ac = UIAlertController(title: "Sending image error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is QuizViewController {
            
            let vc = segue.destination as? QuizViewController
            
            vc?.assistant = self.assistant
            vc?.browser = self.browser
            vc?.peerID = self.peerID
            vc?.session = self.session
            
        }
    }


}

