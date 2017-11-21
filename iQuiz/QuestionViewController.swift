//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Student User on 11/8/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // properities
    fileprivate var answerVC : AnswerViewController!
    var curr: Int = 0
    var count: Int = 0
    var questions = [(text: String, answer: Int, answers: [String])]()
    var score: Int = 0
    var answerChose = -1

    // outlets
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var a4: UIButton!
    @IBOutlet weak var questionIndex: UILabel!
    var btns = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        questionText.text = questions[curr].text
        questionIndex.text = "Question \(curr + 1)"
        if (questions[curr].answers.count >= 4) {
            a1.setTitle(questions[curr].answers[0], for: .normal)
            a2.setTitle(questions[curr].answers[1], for: .normal)
            a3.setTitle(questions[curr].answers[2], for: .normal)
            a4.setTitle(questions[curr].answers[3], for: .normal)
        }
        btns = [a1, a2, a3, a4]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func answerBuilder() {
        if answerVC == nil {
            answerVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "answerVC")
                as! AnswerViewController
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

    @IBAction func chooseAnswer(_ sender: UIButton) {
        for button in btns {
            button.backgroundColor = UIColor.white
        }
        sender.backgroundColor = UIColor.lightGray
        answerChose = btns.startIndex.distance(to: btns.index(of: sender)!)
    }
    
    @IBAction fileprivate func questionToAnswer(_ sender: Any) {
        if (answerChose != -1) {
            answerBuilder()
            answerVC.correct = answerChose + 1 == questions[curr].answer
            answerVC.answer = questions[curr].answers[questions[curr].answer - 1]
            answerVC.questions = self.questions
            answerVC.curr = self.curr
            answerVC.question = questions[curr].text
            if (answerChose + 1 == questions[curr].answer) {
                answerVC.score = self.score + 1
            } else {
                answerVC.score = self.score
            }
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            present(answerVC, animated: false, completion: nil)
        }
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
