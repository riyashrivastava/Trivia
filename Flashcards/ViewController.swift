//
//  ViewController.swift
//  Flashcards
//
//  Created by Riya Shrivastava on 2/26/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var optionalAnswer1: String
    var optionalAnswer2: String
}

class ViewController: UIViewController {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    // keep track of the correct answer
    var correctButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // design
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        question.layer.cornerRadius = 20.0
        question.clipsToBounds = true
        
        answer.layer.cornerRadius = 20.0
        answer.clipsToBounds = true
        
        button1.layer.cornerRadius = 20.0
        button1.layer.borderWidth = 3.0
        button1.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        
        button2.layer.cornerRadius = 20.0
        button2.layer.borderWidth = 3.0
        button2.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        
        button3.layer.cornerRadius = 20.0
        button3.layer.borderWidth = 3.0
        button3.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        
        // gradient background screen
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [#colorLiteral(red: 0.9089609981, green: 0.7517344356, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.5730569959, green: 0.8487328291, blue: 1, alpha: 1).cgColor]
        view.layer.insertSublayer(layer, at: 0)
        
        // saved flashcard data
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(q: "What color is the sunset on Mars?", a: "Blue", optionala1: "Red", optionala2: "Purple", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // start with flashcards and buttons invisible, smaller in size
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        button1.alpha = 0.0
        button1.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        button2.alpha = 0.0
        button2.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        button3.alpha = 0.0
        button3.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // "bouncing" animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.button1.alpha = 1.0
            self.button1.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.button2.alpha = 1.0
            self.button2.transform = CGAffineTransform.identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.button3.alpha = 1.0
            self.button3.transform = CGAffineTransform.identity
        })
        
    }
    
    @IBAction func didTapFlashcard(_ sender: Any) {
        
        flipFlashcard()
    }
    
    // toggles between question and answer
    func flipFlashcard() {
        
        if (question.isHidden == false) {
            // reveal answer
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.question.isHidden = true
            })
        } else {
            // reveal question
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.question.isHidden = false
            })
        }
    }
    
    func updateFlashcard(q: String, a: String, optionala1: String?, optionala2: String?, isExisting: Bool) {
        
        let flashcard = Flashcard(question: q, answer: a, optionalAnswer1: optionala1!, optionalAnswer2: optionala2!)
        
        if isExisting {
            flashcards[currentIndex] = flashcard
        } else {
            flashcards.append(flashcard)
            currentIndex = flashcards.count - 1
        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    // for each button, check if it is the button with the correct answer
    @IBAction func didTapButton1(_ sender: Any) {
        
        if button1 == correctButton {
            question.isHidden = true
            button1.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            
        } else {
            button1.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
    }
    
    @IBAction func didTapButton2(_ sender: Any) {
        
        if button2 == correctButton {
            question.isHidden = true
            button2.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            
        } else {
            button2.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
    }
    
    @IBAction func didTapButton3(_ sender: Any) {
        
        if button3 == correctButton {
            question.isHidden = true
            button3.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            
        } else {
            button3.layer.borderColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }
    }
    
    // transtion to card creation screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
        if (segue.identifier == "EditSegue") {
            creationController.initalQuestion = question.text
            creationController.initialAnswer = answer.text
            
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        currentIndex = currentIndex - 1
        updateLabels()
        updateNextPrevButtons()
        
        button1.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        button2.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        button3.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        
        animateCardsOutPrev()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        currentIndex = currentIndex + 1
        updateNextPrevButtons()
        
        question.isHidden = false
        button1.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        button2.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        button3.layer.borderColor = #colorLiteral(red: 0.1691980958, green: 0.1244860366, blue: 1, alpha: 1)
        
        animateCardsOutNext()
    }
    
    func updateNextPrevButtons() {
        
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        
        let currentFlashcard = flashcards[currentIndex]
        question.text = currentFlashcard.question
        answer.text = currentFlashcard.answer
        
        let buttons = [button1, button2, button3].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.optionalAnswer1, currentFlashcard.optionalAnswer2].shuffled()
        
        // randomize the button with the correct answer choice
        for (button, answer) in zip(buttons, answers) {
            button?.setTitle(answer, for: .normal)
            
            // save the button with the correct answer
            if (answer == currentFlashcard.answer) {
                correctButton = button
            }
        }
    }
    
    // saving flashcard data
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String : String]] {
            
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, optionalAnswer1: dictionary["optionalanswer1"] ?? "nill", optionalAnswer2: dictionary["optionalanswer2"] ?? "nill")
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    func saveAllFlashcardsToDisk() {
        
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question" : card.question, "answer" : card.answer, "optionalanswer1" : card.optionalAnswer1, "optionalanswer2" : card.optionalAnswer2]
        }
        
        UserDefaults.standard.setValue(dictionaryArray, forKey: "flashcards")
    }
    
    // deleting flashcards
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        // meesage
        let alert = UIAlertController(title: "Delete Flashcard", message: "Are you sure you want to delete the flashcard?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in self.deleteCurrentFlashcard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert .addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard() {
        
        // deleting first card -- no
        if (flashcards.count - 1 == -1) {
            return
        } else {
            flashcards.remove(at: currentIndex)
            
            // deleting last card
            if (currentIndex > flashcards.count - 1) {
                currentIndex = flashcards.count - 1
            }
            
            updateNextPrevButtons()
            updateLabels()
            saveAllFlashcardsToDisk()
        }
    }
    
    // animate flashcards to slide in and out when the user hits the next and previous buttons
    func animateCardsInNext() {
        
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.1) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func animateCardsOutNext() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            self.updateLabels()
            self.animateCardsInNext()
        })
    }
    
    func animateCardsInPrev() {
        
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.1) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func animateCardsOutPrev() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: { finished in
            self.updateLabels()
            self.animateCardsInPrev()
        })
    }
}
