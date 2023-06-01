//
//  SettingsController.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/01.
//

import UIKit

class SettingsController: UITableViewController {
    
    //MARK: - Properties
    private let headerView = SettingHeader()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confogureUI()
    }
    
    //MARK: - Actions
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleDone() {
        print("Done")
    }
    
    //MARK: - Helpers
    
    func confogureUI() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        tableView.separatorStyle = .none //테이블뷰 구분선 제거
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
    }

}
