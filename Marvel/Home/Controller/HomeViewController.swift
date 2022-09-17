//
//  HomeViewController.swift
//  Marvel
//
//  Created by Naglaa Ogabih on 14/09/2022.
//

import UIKit
import SDWebImage
import CoreData

class HomeViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var charactersApiData : [Result]?
    var characters : [Characters]?
    var secureImageLink = ""
    var imageUrl = ""
    var recordsArray : [Characters] = Array()
    var limit = 10
    var seriesArray : [Series] = []

    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        Services.getCharacters(vc: self, completionHandler: handleResponse(data:error:))
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.deleteAllData("Characters")
    }
    
    func handleResponse (data : CharactersModel?, error : String?){
        if error != nil {
            print("Error")
        }else if error == nil && data == nil {
            print("Error & Date = nil")
        }else{
            charactersApiData = data?.data?.results
                for i in (0 ..< (charactersApiData?.count ?? 0)){
                    let Character = Characters(context: PersistenceService.context)
                    let characterId = Int64(charactersApiData?[i].id ?? 0)
                    Character.id = characterId
                    Character.name = charactersApiData?[i].name
                    Character.resultDescription = charactersApiData?[i].resultDescription
                    Character.path = charactersApiData?[i].thumbnail?.path
                    Character.thumbnailExtension = charactersApiData?[i].thumbnail?.thumbnailExtension
                    PersistenceService.saveContext()
                    characters?.append(Character)
                }
            fetchRequest()
        }
    }
    func fetchRequest(){
        let fetchRequest : NSFetchRequest<Characters> = Characters.fetchRequest()
        do{
            let character = try PersistenceService.context.fetch(fetchRequest)
            self.characters = character
            var index = 0
            while index < limit{
                recordsArray.append(characters?[index] ?? Characters())
                index += 1
            }
            self.tableView.reloadData()
            
        }catch{}
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharacterTableViewCell
        cell.selectionStyle = .none
        cell.characterName.text = recordsArray[indexPath.row].name
        let imgUrl = recordsArray[indexPath.row].path ?? ""
        if let index = imgUrl.firstIndex(where: { $0 == ":" }) {
            secureImageLink = "https\(imgUrl[index...])"
        }
        imageUrl = "\(secureImageLink).\(recordsArray[indexPath.row].thumbnailExtension ?? "")"
        print("imageUrl\(imageUrl)")
        if let url:URL = URL(string: imageUrl ){
            cell.characterImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_1"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recordsArray.count - 1{
            if recordsArray.count < (characters?.count ?? 0){
                var index = recordsArray.count
                limit = index + 10
                while index < limit{
                    recordsArray.append(characters?[index] ?? Characters())
                    index += 1
                }
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.5)
            }
        }
    }
    @objc func loadTable(){
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "CharacterDetailsViewController") as! CharacterDetailsViewController
        vc.characterData = characters?[indexPath.row]
//        vc.seriesArray = seriesArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try PersistenceService.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                PersistenceService.context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }

}
