//
//  AddScreenViewController.swift
//  MyPersonalNotebook
//
//  Created by Tina Thomsen on 15/03/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import UIKit

class AddScreenViewController: UIViewController {
	
	//Fields
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var textView: UITextView!
	

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func saveNote(_ sender: Any) {
		//save new note here
		var head: String
		var body: String
		head = textField.text!
		body = textView.text!
		
		CloudStorage.createNote(head: head, body: body)
		
	}
	
	
	
	
	//håndterer når man adder en note
	//add til overview
	
	//håndterer visning og redigering af allerede gemte noter,
	//altså når man klikker på en cell
}
