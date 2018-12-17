//
//  ViewController.swift
//  AlamofireAPIWithTableView
//
//  Created by Vattanac on 12/15/18.
//  Copyright © 2018 vattanac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var articleList = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
//        print("*****\(articleList[indexPath.row].Id)")
        cell.titleArticle.text =  articleList[indexPath.row].title ?? "no title"
        cell.authorArticle.text = "Tom Johnasy"
        
        
            if articleList[indexPath.row].description == nil || articleList[indexPath.row].description == "" {
                articleList[indexPath.row].description = "no description"
            }
        
        cell.hidenlabel.text = String(articleList[indexPath.row].Id)
        cell.desArticle.text = articleList[indexPath.row].description //?? "No description"
    
        let imageString = articleList[indexPath.row].imageUrl ?? "http://www.markweb.in/primehouseware/images/noimage.png"
        let url = URL(string: imageString)
        let data = try! Data(contentsOf: url!)
        let image = UIImage(data: data)
        cell.ImageArticle.image = image
        print(imageString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func postData(){
     
    }
    
    //MARK: SwapeRowToDelete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        if editingStyle == .delete{
              print("Delete on ID:\(articleList[indexPath.row].Id!)")
            //let deletid = Int(cell.hidenlabel.text!)
            let t =  articleList[indexPath.row].Id
            deleteData(id: t!)
             articleList.remove(at: indexPath.row)
            
         
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    func deleteData(id:Int){
         let url = "http://api-ams.me/v1/api/articles/" + String(id)
         let header = ["Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="]
        
        Alamofire.request(url, method: .delete, headers: header).responseJSON { (response) in
           
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling DELETE on /todos/1")
                if let error = response.result.error {
                    print("Error: \(error)")
                }
                return
            }
            print("DELETE ok")

        }
        
    }
    
    func getData() -> [Article] {
        
        //var myArray = [Article]()
        let url = "http://api-ams.me/v1/api/articles"
        let header = ["Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="]
        
        Alamofire.request(url, method: .get
            , parameters: nil , headers: header).responseJSON { (response) in
                
                guard response.result.isSuccess else{
                    print("error")
                    return
                }
                let json = response.result.value as! [String:Any]
                let jsondata = json["DATA"] as! [[String:Any]]
                //print(jsondata)
                
                for article in jsondata{
                    self.articleList.append(Article(JSON: article)!)
                    self.tableView.reloadData()
                }
                for i in self.articleList{
                    print("%%%%\(i.Id!)")
//
//                    print("Title:\(i.title ?? "No_Title")")
//                    print("Description:\(i.description ?? "No_Description")")
//                    print("Image:\(i.imageUrl ?? "No_Image_URL")")
                    
                }
        }
        return  self.articleList
    }
    
    
    
}

