//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Student User on 11/8/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    // properities
    fileprivate var questionVC : QuestionViewController!
    fileprivate var finishVC : FinishViewController!
    var curr: Int = 0
    var correct: Bool = false
    var answer: String = ""
    var question: String = ""
    var score: Int = 0
    var questions = [(text: String, answer: Int, answers: [String])]()
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
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
        if (correct) {
            image.image = UIImage(named: "correct")
        } else {
            image.image = UIImage(named: "wrong")
        }
        answerLabel.text = answer
        questionLabel.text = question
    }
    
    @IBAction func back(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        if (curr + 1 < questions.count) {
            questionBuilder()
            questionVC.questions = self.questions
            questionVC.curr = self.curr + 1
            questionVC.score = self.score
            present(questionVC, animated: false, completion: nil)
        } else {
            finishBuilder()
            finishVC.count = questions.count
            finishVC.score = self.score
            present(finishVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func backToList(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        present((storyboard?.instantiateViewController(withIdentifier: "quizTable"))!, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction fileprivate func nextOrFinish(_ sender: UIButton) {
        
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
