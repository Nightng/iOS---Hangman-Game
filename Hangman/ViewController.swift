//
//  ViewController.swift
//  Hangman
//
//  Created by Wilson Ng on 10/27/16.
//  Copyright © 2016 Wilson Ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var triesLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    var wordList = [String]()
    var word = ""
    var length = ""
    var wordText = ""
    var displayedWordLabel = ""
    var tries = 10
    var counter = 0
    var points = 0
    var letterPressed = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordList = linesFromResource(fileName: "wordList.txt")
        loadNewWord()
    }
    
    //File reader
    func linesFromResource(fileName: String) -> [String] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil)
            else {
                fatalError("Resource file for \(fileName) not found.")
        }
        do {
            let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch let error {
            fatalError("Could not load strings from \(path): \(error).")
        }
    }
    
    //Updates the word label that is displayed
    func loadWord(){
        displayedWordLabel = wordText
        for i in length.characters.indices{
            if displayedWordLabel[i] != " "{
                displayedWordLabel.insert(" ", at: displayedWordLabel.index(after: i))
            }
        }
        wordLabel.text = displayedWordLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Checks if the letter pressed is part of the word
    func checkWord(letter: Character){
        if (word.characters.contains(letter))
        {
            for i in (word.characters.indices){
                if word[i] == letter {
                    wordText.insert(letter, at: i)
                    wordText.remove(at:wordText.index(after: i))
                    if letterPressed.contains(letter) == false {counter += 1}
                }
            }
            letterPressed.append(letter)
            loadWord()
            if counter == word.characters.count{
                points += 1
                winAlert()
                if points < wordList.count/2{
                    loadNewWord()
                }
            }
        }
        else
        {
            if(tries != 0){
                tries -= 1
                triesLabel.text = String(tries)
            }
            if tries == 0 {
                loseAlert()
            }
        }
    }
    
    //Loads the new word from the string array from the file read
    func loadNewWord(){
        hintLabel.text = wordList[2*points]
        word = wordList[2*points + 1]
        wordText = String(repeating:"_", count: (word.characters.count))
        length = word+word
        counter = 0
        letterPressed.removeAll()
        loadWord()
    }
    
    //Displays that you won
    func winAlert(){
        if points >= wordList.count/2{
            let alert = UIAlertController(title: NSLocalizedString("YOU WIN!", comment: ""), message: NSLocalizedString("You have completed my Hangman game good job! Thanks for Playing!", comment: ""), preferredStyle: .actionSheet)
            alert.modalPresentationStyle = .popover
            present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: NSLocalizedString("YOU WIN!", comment: ""), message: NSLocalizedString("You solved this word! Good job! Thanks for Playing!", comment: ""), preferredStyle: .actionSheet)
            alert.modalPresentationStyle = .popover
            let cancel = UIAlertAction(title: NSLocalizedString("Keep Playing", comment: ""), style: .cancel) { action in
                
            }
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Displays that you lost
    func loseAlert(){
        let alert = UIAlertController(title: NSLocalizedString("GAME OVER!", comment: ""), message: NSLocalizedString("Sorry you ran out of tries, Thanks for Playing!", comment: ""), preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func letterCheck(_ sender: UIButton) {
        checkWord(letter: (sender.titleLabel!.text?.characters.first)!)
    }
}

