//
//  MasterViewController.swift
//  iQuiz
//
//  Created by Student User on 11/8/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    
    // {{## BEGIN fields ##}}
    fileprivate var questionVC : QuestionViewController!
    fileprivate var answerVC : AnswerViewController!
    fileprivate var finishVC : FinishViewController!
    // {{## END fields ##}}
    
    //    @IBAction func switchViews(_ sender: UIButton) {
    //        questionBuilder()
    //        answerBuilder()
    //        finishBuilder()
    //
    //        UIView.beginAnimations("View Flip", context: nil)
    //        UIView.setAnimationDuration(0.4)
    //        UIView.setAnimationCurve(.easeInOut)
    //
    //        if questionVC != nil &&
    //            questionVC?.view.superview != nil {
    //            UIView.setAnimationTransition(.flipFromRight, for: view, cache: true)
    //            secondViewController.view.frame = view.frame
    //            switchViewController(questionVC, to: secondViewController)
    //            sender.setTitle("Back", for: .normal)
    //        }
    //        else {
    //            UIView.setAnimationTransition(.flipFromLeft, for: view, cache: true)
    //            firstViewController.view.frame = view.frame
    //            switchViewController(secondViewController, to: firstViewController)
    //            sender.setTitle("Next", for: .normal)
    //        }
    //        UIView.commitAnimations()
    //    }
    //
    
    fileprivate func questionBuilder() {
        if questionVC == nil {
            questionVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "questionVC")
                as! QuestionViewController
        }
    }
    
    fileprivate func finishBuilder() {
        if finishVC == nil {
            finishVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "finishVC")
                as! FinishViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionBuilder()
        switchViewController(nil, to: questionVC)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
