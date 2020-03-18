import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	//Fields
	var startNote = "..."
	var currentRow = -1 //no edit
	let db = Firestore.firestore()
	var listHeadlines = [String : String]()
	var headlineArray = [String]()
	
	//Outlets
	@IBOutlet var notesoverview: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		notesoverview.reloadData()
		
		//Generate the headlines
		db.collection("Notes").getDocuments(){ (snap, error) in
			if let error = error{
				print("error fetching docs: \(error)")
			}else{
				for note in snap!.documents{
					let noteID = note.documentID
					let noteHead = note.data().index(forKey: "head")
					let noteHeadContent = note.data()[noteHead!].value as! String
					self.listHeadlines[noteID] = (noteHeadContent)
					self.headlineArray.append(noteHeadContent)
				}
			}
			print("This is the dict in vc: \(self.listHeadlines)")
				print(" and the list \(self.headlineArray)")
			print("This is the list of notes in CS: \(CloudStorage.list),")
				print("And its list of headlines: \(CloudStorage.listOfHeadlines)")
			
			self.notesoverview.dataSource = self
			self.notesoverview.delegate = self
			CloudStorage.startListener()
			DispatchQueue.main.async{self.notesoverview.reloadData()}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		DispatchQueue.main.async {
			self.notesoverview.reloadData()
		}
	}
	
	//TABLE VIEW FUNCTIONS
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return headlineArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = notesoverview.dequeueReusableCell(withIdentifier: "Cell"){
			cell.textLabel?.text = headlineArray[indexPath.row]
			return cell
		}else {
			return UITableViewCell()
		}
	}
	
	
}

//___________________TO IMPLEMENT______________________________
/*
func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
	for key in listHeadlines.keys{
		headlineArray.append(key)
	}
	let movedObjTemp = headlineArray[sourceIndexPath.item]
	headlineArray.remove(at: sourceIndexPath.item)
	headlineArray.insert(movedObjTemp, at:destinationIndexPath.item)
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
	if editingStyle == .delete{
		headlineArray.remove(at: indexPath.item)
		notesoverview.deleteRows(at: [indexPath], with: .automatic)
		
		//delete in db and listHeadlines too
		for id in headlineArray{
			for key in listHeadlines.keys{
				if listHeadlines.index(forKey: id) == nil{
					listHeadlines.removeValue(forKey: id)
					CloudStorage.deleteNote(id: id)
				}
			}
		}
	}
}*/

//  @IBAction func addNoteBt(_ sender: Any) {
//		//To note page...
//		let navig = storyboard?.instantiateViewController(identifier: "Navig") as! Navig
//		present(navig, animated: true, completion: nil)
//	}
//
//	@IBAction func editNotesOverview(_ sender: UIBarButtonItem) {
//		self.notesoverview.isEditing = !self.notesoverview.isEditing
//		sender.title = (self.notesoverview.isEditing) ? "Done" : "Edit"
//	}
