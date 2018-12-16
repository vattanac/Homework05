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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            articleList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.titleArticle.text =  articleList[indexPath.row].title
        cell.authorArticle.text = "Tom Johnasy"
        
        
            if articleList[indexPath.row].description == nil || articleList[indexPath.row].description == "" {
                articleList[indexPath.row].description = "no description"
            }
        
//       if articleList[indexPath.row].imageUrl == "string" || articleList[indexPath.row].imageUrl == ""{
//            articleList[indexPath.row].imageUrl = "http://www.markweb.in/primehouseware/images/noimage.png"
//            //print("yyeeee")
//        }
        
        cell.desArticle.text = articleList[indexPath.row].description //?? "No description"
        let arch = "https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method"
        var imageString = articleList[indexPath.row].imageUrl ?? "http://www.markweb.in/primehouseware/images/noimage.png"
        if imageString == "string" || imageString == nil || imageString == arch  {
            imageString = "http://www.markweb.in/primehouseware/images/noimage.png"
        }
        print(imageString)
        //tableView.reloadData()
        // let imageUrl = URL(string: imageString)
        
      //  cell.ImageArticle.image =  UIImage(data:try! Data(contentsOf: imageUrl!))
        //print(articleList)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func postData(){
     
    }
    func deleteData(){
         let url = "http://api-ams.me/v1/api/articles"
         let header = ["Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="]
        
        Alamofire.request(url, method: .delete, headers: header).responseData { (<#DataResponse<Data>#>) in
            <#code#>
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
//
//                    print("Title:\(i.title ?? "No_Title")")
//                    print("Description:\(i.description ?? "No_Description")")
//                    print("Image:\(i.imageUrl ?? "No_Image_URL")")
                    
                }
        }
        return  self.articleList
    }
    
    
    
}

