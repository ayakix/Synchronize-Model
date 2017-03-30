//
//  ViewController.swift
//  Synchronize-Model
//
//  Created by Ayakix on 2017/03/29.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate let kCellIdentifier = "TableViewCell"
    fileprivate let kSegueIdentifier = "Detail"
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    var models = [Model]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        
        var sampleModels = [Model]()
        for i in 0..<3 {
            sampleModels.append(Model(id: i, isFavorite: i % 2 == 0))
        }
        models = sampleModels
        
        addDidChangeModelObserver()
    }
    
    deinit {
        removeDidChangeModelObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case kSegueIdentifier:
            guard
                let vc = segue.destination as? DetailViewController,
                let model = sender as? Model else {
                    return
            }
            vc.model = model
        default:
            break
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {}
}

extension ViewController: ModelChangeable {
    func updateModel(_ model: Model) {
        models = models.map({ $0.id == model.id ? model : $0 })
    }
    
    func deleteModel(_ model: Model) {
        models = models.filter({ $0.id != model.id })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! TableViewCell
        cell.updateView(from: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        performSegue(withIdentifier: kSegueIdentifier,sender: models[indexPath.row])
    }
}
