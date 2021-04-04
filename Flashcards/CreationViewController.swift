//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Riya Shrivastava on 3/14/21.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    
    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var optionalAnswer1Text: UITextField!
    @IBOutlet weak var optionalAnswer2Text: UITextField!
    
    var initalQuestion: String?
    var initialAnswer: String?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        questionText.text = initalQuestion
        answerText.text = initialAnswer
        
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        // user is creating a new flashcard
        
        let question = questionText.text
        let answer = answerText.text
        
        var isExisting = false
        if initalQuestion != nil {
            isExisting = true
        }
        
        if (question == nil || answer == nil || question!.isEmpty || answer!.isEmpty) {
            
            let alert = UIAlertController(title: "Missing text", message: "You need to enter both a question and an answer", preferredStyle: .alert)
            present(alert, animated: true)
            let okAction = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(okAction)
            
        } else {
            flashcardsController.updateFlashcard(q: question!, a: answer!, optionala1: optionalAnswer1Text.text, optionala2: optionalAnswer2Text.text, isExisting: isExisting)
            dismiss(animated: true)
        }
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
