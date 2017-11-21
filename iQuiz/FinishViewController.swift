//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Student User on 11/8/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    
    var score: Int = 0
    var count: Int = 0
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scoreLabel.text = "\(score)  /  \(count)"
        if (score == count) {
            commentLabel.text = "Perfect!"
        } else if (score == 0) {
            commentLabel.text = "Maybe Next Time!"
        } else {
            commentLabel.text = "Almost There!"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToList(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        present((storyboard?.instantiateViewController(withIdentifier: "quizTable"))!, animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
