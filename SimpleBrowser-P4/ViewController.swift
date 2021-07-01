//
//  ViewController.swift
//  SimpleBrowser-P4
//
//  Created by Łukasz Nycz on 01/07/2021.
//
import UIKit
import WebKit

class ViewController: UITableViewController {

    var websites = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        websites += ["google.com", "demotywatory.pl", "kwejk.pl", "hackingwithswift.com", "facebook.com"]
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
        //vc.selectedImage = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
