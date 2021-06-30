//
//  ViewController.swift
//  SwiftConcurrency
//
//  Created by andres jaramillo on 30/06/21.
//

import UIKit

class ViewController: UIViewController {

    let tableview: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.rowHeight = UITableView.automaticDimension
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    var heros = [Hero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
        fetchData()
    }
    
    func createTableView(){
        
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        
        NSLayoutConstraint.activate([
            tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableview.topAnchor.constraint(equalTo: view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchData(){
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/all.json#") else {
            return
        }
        //Esta tarea por defecto se ejecuta en el global queue (background)
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                self?.heros = try JSONDecoder().decode([Hero].self, from: data)
                self?.updateTableView()
            }
            catch{
                print(error)
            }
        }
        
        task.resume()
    }
    
    func updateTableView(){
        //El tableview se actualiza en el main queue
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        cell?.textLabel?.text = heros[indexPath.row].name
        return cell!
    }
}

