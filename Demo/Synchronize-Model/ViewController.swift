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
    
    var someModels = [SomeModel]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        
        var sampleModels = [SomeModel]()
        for i in 0..<20 {
            sampleModels.append(SomeModel(id: i, isFavorite: i % 2 == 0))
        }
        someModels = sampleModels
        
        NotificationCenter.default.addObserver(self, selector: #selector(onModelChanged(_:)), name: .changedModel, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .changedModel, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case kSegueIdentifier:
            guard
                let vc = segue.destination as? DetailViewController,
                let someModel = sender as? SomeModel else {
                    return
            }
            vc.someModel = someModel
        default:
            break
        }
    }
    
    func onModelChanged(_ notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let someModel = userInfo[NotificationInfoKey.model.rawValue] as? SomeModel,
            let eventType = userInfo[NotificationInfoKey.eventType.rawValue] as? NotificationEventType else {
                return
        }
        switch eventType {
        case .update:
            someModels = someModels.map({ $0.id == someModel.id ? someModel : $0 })
        case .delete:
            someModels = someModels.filter({ $0.id != someModel.id })
        default:
            break
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! TableViewCell
        cell.updateView(with: someModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        performSegue(withIdentifier: kSegueIdentifier,sender: someModels[indexPath.row])
    }
}
