//
//  QuizViewController.swift
//  MultipeerExample
//
//  Created by Araf Rahman on 4/27/20.
//  Copyright © 2020 Eyuphan Bulut. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreMotion

class QuizViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var motionManager = CMMotionManager()
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    @IBOutlet weak var myAnswer: UILabel!
    @IBOutlet weak var player2Answer: UILabel!
    @IBOutlet weak var player3Answer: UILabel!
    @IBOutlet weak var player4Answer: UILabel!
    @IBOutlet weak var myLbl: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLbl: UILabel!
    @IBOutlet weak var fourLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bigLbl: UILabel!
    @IBOutlet var choiceButtons: [UIButton]!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    
    @IBOutlet weak var questionLbl: UILabel!
    var timer : Timer?
    var gameTime = 20
    var quiz = [["" : nil]]
    var questionNum = 1
    var myScore = 0
    var correct = false
    var highestScore = 0
    var answered = false
    var answered2 = false
    var answered3 = false
    var answered4 = false
    var goNext = false
    var p2Score = 0
    var p3Score = 0
    var p4Score = 0
    
    var session: MCSession!
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
         
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        DispatchQueue.main.async(execute: {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Deafult")
        }
        })
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async(execute: {
        
            print("yeeeeee")
            print(session.connectedPeers.count)
        let peers = session.connectedPeers.count
            
        if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
            if receivedString == "A" {
                if(peerID == self.peerID) {
                    self.myAnswer.text = receivedString
                }
                else {
                    if(peers >= 1){ if peerID == session.connectedPeers[0] {
                        self.player2Answer.text = receivedString
                    }}
                    if(peers >= 2){ if peerID == session.connectedPeers[1] {
                        self.player3Answer.text = receivedString
                    }}
                        
                    if(peers >= 3){ if peerID == session.connectedPeers[2] {
                        self.player4Answer.text = receivedString
                    }}
                }
            }
            if receivedString == "B" {
                if(peerID == self.peerID) {
                    self.myAnswer.text = receivedString
                }
                else {
                    if(peers >= 1){ if peerID == session.connectedPeers[0] {
                        self.player2Answer.text = receivedString
                    }}
                    if(peers >= 2){ if peerID == session.connectedPeers[1] {
                        self.player3Answer.text = receivedString
                    }}
                        
                    if(peers >= 3){ if peerID == session.connectedPeers[2] {
                        self.player4Answer.text = receivedString
                    }}
                }
            }
            if receivedString == "C" {
                if(peerID == self.peerID) {
                    self.myAnswer.text = receivedString
                }
                else {
                    if(peers >= 1){ if peerID == session.connectedPeers[0] {
                        self.player2Answer.text = receivedString
                    }}
                    if(peers >= 2){ if peerID == session.connectedPeers[1] {
                        self.player3Answer.text = receivedString
                    }}
                        
                    if(peers >= 3){ if peerID == session.connectedPeers[2] {
                        self.player4Answer.text = receivedString
                    }}
                }
            }
            if receivedString == "D" {
                if(peerID == self.peerID) {
                    self.myAnswer.text = receivedString
                }
                else {
                    if(peers >= 1){ if peerID == session.connectedPeers[0] {
                        self.player2Answer.text = receivedString
                    }}
                    if(peers >= 2){ if peerID == session.connectedPeers[1] {
                        self.player3Answer.text = receivedString
                    }}
                        
                    if(peers >= 3){ if peerID == session.connectedPeers[2] {
                        self.player4Answer.text = receivedString
                    }}
                }
            }
            if receivedString == "Next" {
                self.questionNum += 1
                print("next")
                self.addQuestionLbl()
                self.updateQuiz()
            }
            if receivedString == "answered" {
               if(peerID == self.peerID) {
                  self.answered = true
               }
               else {
                   if(peers >= 1){ if peerID == session.connectedPeers[0] {
                    self.answered2 = true
                   }}
                   if(peers >= 2){ if peerID == session.connectedPeers[1] {
                    self.answered3 = true
                   }}
                       
                   if(peers >= 3){ if peerID == session.connectedPeers[2] {
                    self.answered4 = true
                   }}
               }
            }
            }
            if let receivedInt = NSKeyedUnarchiver.unarchiveObject(with: data) as? Int{
               if(peerID == self.peerID) {
                   self.myAnswer.text = String(receivedInt)
               }
               else {
                   if(peers >= 1){ if peerID == session.connectedPeers[0] {
                       self.player2Answer.text = String(receivedInt)
                    self.p2Score = receivedInt
                   }}
                   if(peers >= 2){ if peerID == session.connectedPeers[1] {
                       self.player3Answer.text = String(receivedInt)
                    self.p3Score = receivedInt
                   }}
                       
                   if(peers >= 3){ if peerID == session.connectedPeers[2] {
                       self.player4Answer.text = String(receivedInt)
                    self.p4Score = receivedInt
                   }}
               }
            }
        })
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        assistant.start()
        session.delegate = self
        browser.delegate = self
        let peerCount = session.connectedPeers.count
        // Do any additional setup after loading the view.
        myLbl.text = peerID.displayName
        if(peerCount >= 1){
            twoLabel.text = session.connectedPeers[0].displayName
        }
        if(peerCount >= 2){
            threeLbl.text = session.connectedPeers[1].displayName
        }
        if(peerCount >= 3){
            fourLbl.text = session.connectedPeers[2].displayName
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
       // popPage()
       //getJSONData()
       bigLbl.text = String(gameTime)
       readLocalJSONData()
       addQuestionLbl()
    }
    
    func addQuestionLbl() {
        let quizLength = quiz.count
        var q = quiz[questionNum-1]
        var qText = q["questionSentence"] as! String
        var options = q["options"] as! Dictionary<String, String>
        questionLbl.text! = "Question: \(questionNum)/\(quizLength)"
        timeLbl.text! = "\(qText)"
        optionA.setTitle(options["A"]!, for: .normal)
        optionB.setTitle(options["B"]!, for: .normal)
        optionC.setTitle(options["C"]!, for: .normal)
        optionD.setTitle(options["D"]!, for: .normal)
    }
     
    
    var aTap = 0
    var bTap = 0
    var cTap = 0
    var dTap = 0
    
    @IBAction func clickA(_ sender: Any) {
        aTap += 1
        if (aTap == 2) {
        disableOptions()
        myAnswer.text = "A"
        answered = true
        let start = NSKeyedArchiver.archivedData(withRootObject: "A")
        do{
            try session.send(start, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
       // aTap = 0
            let start2 = NSKeyedArchiver.archivedData(withRootObject: "answered")
            do{
                try session.send(start2, toPeers: session.connectedPeers, with: .unreliable)
            }
            catch let err {
                //print("Error in sending data \(err)")
            }
        }
    }
    
    @IBAction func clickB(_ sender: Any) {
        bTap += 1
        if (bTap == 2) {
            disableOptions()
        myAnswer.text = "B"
        answered = true
        let start = NSKeyedArchiver.archivedData(withRootObject: "B")
        do{
            try session.send(start, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        //bTap = 0
            let start2 = NSKeyedArchiver.archivedData(withRootObject: "answered")
            do{
                try session.send(start2, toPeers: session.connectedPeers, with: .unreliable)
            }
            catch let err {
                //print("Error in sending data \(err)")
            }
        }
    }
    
    
    @IBAction func clickC(_ sender: Any) {
        cTap += 1
        if (cTap == 2) {
            disableOptions()
        myAnswer.text = "C"
            answered = true
        let start = NSKeyedArchiver.archivedData(withRootObject: "C")
        do{
            try session.send(start, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        //cTap = 0
            let start2 = NSKeyedArchiver.archivedData(withRootObject: "answered")
            do{
                try session.send(start2, toPeers: session.connectedPeers, with: .unreliable)
            }
            catch let err {
                //print("Error in sending data \(err)")
            }
        }
    }
    
    
    @IBAction func clickD(_ sender: Any) {
        dTap += 1
        if dTap == 2 {
            disableOptions()
        myAnswer.text = "D"
            answered = true
        let start = NSKeyedArchiver.archivedData(withRootObject: "D")
        do{
            try session.send(start, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
       //dTap = 0
            let start2 = NSKeyedArchiver.archivedData(withRootObject: "answered")
            do{
                try session.send(start2, toPeers: session.connectedPeers, with: .unreliable)
            }
            catch let err {
                //print("Error in sending data \(err)")
            }
        }
    }
    
    @objc func onTimerFires() {
       var peers = session.connectedPeers.count
        if peers == 0 && answered {
            goNext = true
        }
        if peers == 1 && answered && answered2{
            goNext = true
        }
        if peers == 2 && answered && answered2 && answered3{
            goNext = true
        }
        if peers == 3 && answered && answered2 && answered3 && answered4{
            goNext = true
        }
        
       gameTime -= 1
       bigLbl.text = String(gameTime)
       if gameTime == 0 || goNext{
        timer?.invalidate()
        timer = nil
        myAnswer.text = String(myScore)
        self.nextBtn.isEnabled = true
        if (correct) {
            bigLbl.text = "Correct"
        }
        else {
            bigLbl.text = "Incorrect"
        }
        let start = NSKeyedArchiver.archivedData(withRootObject: myScore)
        do{
            try session.send(start, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        print(String(myScore))
        if questionNum == quiz.count {
            nextBtn.setTitle("New Game", for: .normal)
            print("MyScore \(myScore)")
            print("HiScore \(highestScore)")
            var endTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (endTImer) in
                
                if (self.p2Score > self.highestScore) {
                    self.highestScore = self.p2Score
                }
                if (self.p3Score > self.highestScore) {
                    self.highestScore = self.p3Score
                }
                if (self.p4Score > self.highestScore) {
                    self.highestScore = self.p4Score
                }
                
                if self.myScore >= self.highestScore{
                    self.bigLbl.text = "Winner"
                }
                else {
                    self.bigLbl.text = "Loser"
                }
            }
            
        }
       }
    }
    
    func popPage() {
       let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HighScores") as! PopUpVC
      // popOverVC.highScores = self.MemoryHighScores
       self.addChild(popOverVC)
       popOverVC.view.frame = self.view.frame
       self.view.addSubview(popOverVC.view)
       popOverVC.didMove(toParent: self)
    }
    
    func getJSONData() {
        
        let urlString1 = "http://api.openweathermap.org/data/2.5/find?q=NewYork&appid=881143b83f8b900d864067c69c4d96fe"
       
       let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json"
        
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        // create a data task
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            print("Made it in")
            
            if let result = data {
                
                print("inside get JSON")
                print(result)
                do{
                    let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                    
                    if let dictionary = json as? [String:Any]{
                        print(dictionary["number"]!)
                    }
                }
                catch{
                    print("Error")
                }
            }
            
        })
        
        // always call resume() to start
        task.resume()
    }
    
    func readLocalJSONData(){
        print("inside read local JSON")
        
        let url = Bundle.main.url(forResource: "data", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            
            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONData(dictionary)
            }
            
        } catch {
            // Handle Error
        }
    }
    
    
    
    func readJSONData(_ object: [String: AnyObject]) {
        if  let topic = object["topic"] as? String,
            let qNum = object["numberOfQuestions"] as? Int,
            let users = object["questions"] as? [[String: AnyObject]] {
            
            
            
            quiz.removeAll(keepingCapacity: true)
            
            quiz = users
            
            for user in quiz {
                
                print("\(user["number"]!) is \(user["questionSentence"]!) years old")
            }
            
            
        }
    }
    
    @IBAction func nextQuestion(_ sender: Any) {
        questionNum += 1
        if questionNum <= quiz.count {
            addQuestionLbl()
            updateQuiz()
            let start = NSKeyedArchiver.archivedData(withRootObject: "Next")
            do{
                try session.send(start, toPeers: session.connectedPeers, with: .unreliable)
            }
            catch let err {
                //print("Error in sending data \(err)")
            }
        }
    }
    
    func updateQuiz() {
        gameTime = 20
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        bigLbl.text = String(gameTime)
        aTap = 0
        bTap = 0
        cTap = 0
        dTap = 0
        nextBtn.isEnabled = false
        enableOptions()
        correct = false
        answered = false
        answered2 = false
        answered3 = false
        answered4 = false
        goNext = false
    }
    
    func disableOptions() {
        optionA.isEnabled = false
        optionB.isEnabled = false
        optionC.isEnabled = false
        optionD.isEnabled = false
    }
    
    func enableOptions() {
        optionA.isEnabled = true
        optionB.isEnabled = true
        optionC.isEnabled = true
        optionD.isEnabled = true
    }
    
    
    
   
    @IBAction func checkAnswer(_ sender: UIButton) {
        var q = quiz[questionNum-1]
        var correctAns = q["correctOption"] as! String
        print(sender.tag)
        print(correctAns)
        print("Btap is \(bTap)")
        if sender.tag == 0 &&  correctAns == "A" && aTap == 1{
           myScore += 1
           correct = true
        }
        if sender.tag == 1 &&  correctAns == "B" && bTap == 1{
           myScore += 1
           correct = true
        }
        if sender.tag == 2 &&  correctAns == "C" && cTap == 1{
           myScore += 1
           correct = true
        }
        if sender.tag == 3 &&  correctAns == "D" && dTap == 1{
           myScore += 1
           correct = true
        }
        if myScore > highestScore {
            highestScore = myScore
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motion ended")
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
