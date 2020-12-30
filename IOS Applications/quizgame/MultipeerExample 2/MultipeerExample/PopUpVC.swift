//
//  PopUpVC.swift
//  MultipeerExample
//
//  Created by Araf Rahman on 5/1/20.
//  Copyright © 2020 Eyuphan Bulut. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {
    
    var transitionView = UIView()
    var tapGR: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        transitionView.frame = CGRect(x: 200, y: 100, width: 500, height: 500)
        transitionView.backgroundColor = UIColor.red
        self.view.addSubview(transitionView)
        
        tapGR = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc func tapped() {
        self.view.removeFromSuperview()
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
