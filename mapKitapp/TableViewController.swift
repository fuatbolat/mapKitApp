//
//  TableViewController.swift
//  mapKitapp
//
//  Created by Fuat Bolat on 11.12.2024.
//

import UIKit
import CoreData

class TableViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var nameArr = [String]()
    var idArr = [UUID]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addItemPressed))
        
        takeData()

        // Do any additional setup after loading the view.
    }
    
   /* override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDta), name: NSNotification.Name(rawValue:"alertforrealoaddata"), object: nil)
    }
    @objc func reloadDta(){
        tableView.reloadData()
    }
    */
    func takeData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Area")
        request.returnsObjectsAsFaults = false
        
        nameArr.removeAll(keepingCapacity: false)
        idArr.removeAll(keepingCapacity: false)
        do{
            let sonuclar = try context.fetch(request)
            for sonuc in sonuclar as! [NSManagedObject]{
                if let sonuc = sonuc.value(forKey: "name") as? String{
                    nameArr.append(sonuc)
                    
                }
                if let sonuc = sonuc.value(forKey: "id") as? UUID{
                    idArr.append(sonuc)
                }
            }
        }
        catch{
            print("errror")
        }
        tableView.reloadData()
    }
    
    
    @objc func addItemPressed(){
        performSegue(withIdentifier: "gotToMaps", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArr[indexPath.row]
        return cell
    }
    

    

   

}