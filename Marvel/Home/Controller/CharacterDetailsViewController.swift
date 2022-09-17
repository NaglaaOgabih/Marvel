//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by Naglaa Ogabih on 16/09/2022.
//

import UIKit
import SDWebImage

class CharacterDetailsViewController: UIViewController {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var characterData : Characters?
    var characterApiData : Result?
    var seriesData : [Series] = []
//    var seriesData : NSSet?
    var secureImageLink = ""

    override func viewDidLoad(){
        super.viewDidLoad()
        setCharacterData()
    }
    
   func setCharacterData(){
       characterName.text = characterData?.name ?? ""
       characterDescription.text = characterData?.resultDescription ?? ""
       let imgUrl = characterData?.path ?? ""
       if let index = imgUrl.firstIndex(where: { $0 == ":" }) {
           secureImageLink = "https\(imgUrl[index...])"
       }
       let imageUrl = "\(secureImageLink).\(characterData?.thumbnailExtension ?? "")"
       print("imageUrl\(imageUrl)")
       if let url:URL = URL(string: imageUrl ){
           characterImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_1"))
       }
//       seriesData = characterData?.series
       collectionView.reloadData()
    }
}

extension CharacterDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seriesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesCell", for: indexPath) as! SeriesCollectionViewCell
//        cell.seriesName.text = seriesData?[indexPath.row].name
        let seriesImageUrl = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
        if let url:URL = URL(string: seriesImageUrl ){
            cell.seriesImage.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_1"))
        }
        return cell
    }
}
