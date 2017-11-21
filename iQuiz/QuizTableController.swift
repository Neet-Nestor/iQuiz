//
//  ViewController.swift
//  iQuiz
//
//  Created by Nestor Qin on 11/5/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class QuizTableController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    // outlets
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var settingItem: UIBarButtonItem!
    
    // properities
    var questionURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.txt")
    var quizsImages: [UIImage] = [UIImage(named: "img1")!, UIImage(named: "img2")!, UIImage(named: "img3")!, UIImage(named: "img4")!, UIImage(named: "img5")!, UIImage(named: "img6")!, UIImage(named: "img7")!, UIImage(named: "img8")!, UIImage(named: "img9")!,UIImage(named: "img10")!]
    var quizs: [(title: String, description: String, image: UIImage)] = [(title: String, description: String, image: UIImage)]()
    var questions = [[(text: String, answer: Int, answers: [String])]]()
    fileprivate var questionVC: QuestionViewController?
    
    fileprivate func questionBuilder() {
        if questionVC == nil {
            questionVC =
                storyboard?
                    .instantiateViewController(withIdentifier: "questionVC")
                as? QuestionViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromFile()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.addSubview(self.refreshControl)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        checkURL()
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        readFromFile()
        self.table.reloadData()
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuizTableController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        checkURL()
        readFromFile()
        self.table.reloadData()
        refreshControl.endRefreshing()
    }
    
    func readFromFile() {
        do {
            let text = try String(contentsOf: questionURL, encoding: .utf8)
            let data = text.data(using: String.Encoding.utf8)!
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            var imageIndex: Int = 0
            questions.removeAll()
            quizs.removeAll()
            for quiz in json! {
                NSLog(String(describing: quiz))
                let quizDict = quiz as! [String: AnyObject]
                quizs.append((title: quizDict["title"] as! String, description: quizDict["desc"] as! String, image: quizsImages[imageIndex]))
                var quizQuestions = [(text: String, answer: Int, answers: [String])]()
                for single in quizDict["questions"] as! [Any] {
                    let singleQuestion = single as! [String: Any]
                    quizQuestions.append((text: singleQuestion["text"] as! String, answer: Int(singleQuestion["answer"] as! String)!, answers: singleQuestion["answers"] as! [String]))
                }
                questions.append(quizQuestions)
                // repeatedly choose icon for quizs
                if (imageIndex >= 9) {
                    imageIndex = 0
                } else {
                    imageIndex = imageIndex + 1
                }
            }
        }
        catch {
            let alert = UIAlertController(title: "Error", message: "Fail to get questions.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "theQuizCell", for: indexPath) as? QuizCell else {
            fatalError("The dequeued cell is not an instance of QuizCell.")
        }
        cell.title?.text = quizs[indexPath.row].title
        cell.descrip?.text = quizs[indexPath.row].description
        cell.photoImage?.image = quizs[indexPath.row].image
        return cell //4.
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do view switch when the user choose one cell
        questionBuilder()
        questionVC?.questions = self.questions[indexPath.row]
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(questionVC!, animated: false, completion: nil)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    func checkURL() {
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questionURL.txt")
//        if try String(contentsOf: fileUrl) == nil {
//            try "http:/tednewardsandbox.site44.com/questions.json".write(to: fileUrl, atomically: true, encoding: .utf8)
//        }
        do {
            let testURL = try String(contentsOf: fileUrl)
        }
        catch {
            // if the file not exist, uses the default URL
            do {
                try "http:/tednewardsandbox.site44.com/questions.json".write(to: fileUrl, atomically: true, encoding: .utf8)
            }
            catch {
                // Error
            }
        }
        let URLOfQuestions = try! URL(string: String(contentsOf: fileUrl))
        let task = URLSession.shared.dataTask(with: URLOfQuestions!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if let usableData = data {
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! [AnyObject]
                    NSLog(String(describing: json))
                    if (data != nil && json != nil) {
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Questions Updated", message: "You have successfully updated quiz questions from the server!", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default))
//                            self.present(alert, animated: true, completion: nil)
//                        }
                        self.writeQuestionsToFile(data: String(data: data!, encoding: .utf8)!)
                    } else {
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Get Questions", message: "Fail to update questions from server.", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default))
//                            self.present(alert, animated: true, completion: nil)
//                        }
                    }
                }
            }
        }
        task.resume()
    }

    func writeQuestionsToFile(data: String) {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.txt")
        do {
            try data.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToMaster" && segue.destination is MasterViewController
//        {
//            let vc = segue.destination as? MasterViewController
//
//        }
//    }
//
//    private func loadSampleQuizs() {
//        let image1 = UIImage(named: "img1")
//        let image2 = UIImage(named: "img2")
//        let image3 = UIImage(named: "img3")
//        guard let quiz1 = QuizCell(quizTitle: quizsName[0], quizDescription: descriptions[0], image: image1!) else {
//            fatalError("Unable to instantiate meal1")
//        }
//        guard let quiz2 = QuizCell(quizTitle: quizsName[1], quizDescription: descriptions[1], image: image2!) else {
//            fatalError("Unable to instantiate meal1")
//        }
//        guard let quiz3 = QuizCell(quizTitle: quizsName[2], quizDescription: descriptions[2], image: image3!) else {
//            fatalError("Unable to instantiate meal1")
//        }
//        quizs += [quiz1, quiz2, quiz3]
//    }
}

