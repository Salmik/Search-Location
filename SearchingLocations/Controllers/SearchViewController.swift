//
//  SearchViewController.swift
//  SearchingLocations
//
//  Created by Zhanibek Lukpanov on 11.05.2021.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var locations = [Location]()
    
    weak var delegate: SearchViewControllerDelegate?
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "Where To?"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let textFiled: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter destination"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .tertiarySystemBackground
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .secondarySystemBackground
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        view.addSubview(textFiled)
        view.addSubview(tableView)
        
        textFiled.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 15, y: 15, width: label.frame.size.width, height: label.frame.size.height)
        
        textFiled.frame = CGRect(x: 15, y: 30+label.frame.size.height, width: view.frame.size.width-26, height: 50)
        
        let tableViewY = textFiled.frame.origin.y+textFiled.frame.size.height+10
        tableView.frame = CGRect(x: 0, y: tableViewY, width: view.frame.size.width, height: view.frame.size.height)
    }

}

// MARK:- UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFiled.resignFirstResponder()
        if let text = textFiled.text, !text.isEmpty {
            LocationManager.shared.findLocations(text) {[weak self] locations in
                guard let self = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.locations = locations
                    self.tableView.reloadData()
                }
            }
        }
        return true
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = location.title
        cell.textLabel?.numberOfLines = 0

        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.backgroundColor = .secondarySystemBackground
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinate = locations[indexPath.row].coordinate
        
        delegate?.searchViewController(self, didSelectLocationWith: coordinate)
    }
    
}
