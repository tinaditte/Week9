//
//  CloudStorage.swift
//  MyPersonalNotebook
//
//  Created by Tina Thomsen on 15/03/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CloudStorage{
	
	static var list = [ Note ]()
	static var listOfHeadlines = [ String ]()
	static var count = Int.self
	static let db = Firestore.firestore()
	private static let notes = "Notes"
	
	static func startListener(){
		print("Listening has begun")
		db.collection(notes).addSnapshotListener{ (snap, error) in
			if error == nil {
				self.list.removeAll() //empty array or duplicates will happen
				for note in snap!.documents{
					let map = note.data()
					let head = map["head"] as! String
					let body = map["body"] as! String
					let newNote = Note(id: note.documentID, head:head, body:body)
					self.list.append(newNote)
					listOfHeadlines.append(head)
				}
			}
		}
	}

	static func deleteNote(id:String){
		let docRef = db.collection(notes).document(id)
		docRef.delete()
	}
	
	static func createNote(head: String, body: String) {
		let docRef = db.collection(notes).addDocument(data: [
			"head": head,
			"body": body
		]){
			err in
			if let err = err{
				print("Error when adding document: \(err)")
			}else {
				print("doc was added")
			}
		}
		let newNote = Note(id: docRef.documentID, head:head, body:body)
		list.append(newNote)
		startListener()
	}
	
	static func updateNote(index: Int, head: String, body:String){
		let note = list[index]
		let docRef = db.collection(notes).document(note.id)
		var map = [String:String]()
		map["head"] = head
		map["body"] = body
		docRef.setData(map)
	}
}
