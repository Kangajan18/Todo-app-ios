//
//  CategoryTableViewController.swift
//  TodoApplication
//
//  Created by kangajan kuganathan on 2023-04-21.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //category list
    var categories:[`CategoryEntity`] = []
    
    //coredata contex
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    private func saveCategory() {
        do{
            try context.save()
        }catch {
            print("Error rice while Save context , \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadCategory(request:NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()) {
        do{
            categories = try context.fetch(request)
        }catch {
            print("Error occur while load data , \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var categoryTextField = UITextField()
        
        let addCategoryAlert = UIAlertController(title: "Enter New Category", message: "", preferredStyle: .alert)
        addCategoryAlert.addTextField(){ uITextField in
            categoryTextField = uITextField
        }
        let categoryAction = UIAlertAction(title: "Add", style: .default) { UIAlertAction in
            let newCategory = CategoryEntity(context: self.context)
            
            if let newCategoryText = categoryTextField.text{
                newCategory.name = newCategoryText
                self.categories.append(newCategory)
                self.saveCategory()
            }
        }
        addCategoryAlert.addAction(categoryAction)
        present(addCategoryAlert, animated: true)
    }
}

//MARK: - tableview data Source
extension CategoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}
//MARK: - tableview delegates
extension CategoryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTask" {
            let destinationVc = segue.destination as! ViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVc.selectedCategory = categories[indexPath.row]
            }
        }
    }
    
}
