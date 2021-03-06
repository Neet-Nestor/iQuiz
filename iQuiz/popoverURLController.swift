//
//  popoverURLController.swift
//  iQuiz
//
//  Created by Student User on 11/16/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class popoverURLController: UIViewController {

    @IBOutlet weak var textURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let urlFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questionURL.txt")
        textURL.text = try! String(contentsOf: urlFileURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkURL(_ sender: Any) {
        let requestURL = URL(string: textURL.text!)
        NSLog(textURL.text!)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as! URL)
        let session = URLSession.shared
        let task = URLSession.shared.dataTask(with: requestURL!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if let usableData = data {
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as! [AnyObject]
                    NSLog(String(describing: json))
                    if (data != nil && json != nil) {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Get Questions", message: "You have successfully get questions from the URL!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.writeQuestionsToFile(data: String(data: data!, encoding: .utf8)!)
                        NSLog("\(requestURL)")
                        self.writeURLToFile(data: "\(requestURL)")
                        DispatchQueue.main.async {
                            NSLog(String(describing: UIApplication.shared.delegate?.window??.rootViewController))
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Get Questions", message: "Fail to get questions from the given URL.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
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
    
    func writeURLToFile(data: String) {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questionURL.txt")
        do {
            try data.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
