//
//  SettingsController.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/01.
//

import UIKit

private let reuserIdentifier = "SettingCell"

class SettingsController: UITableViewController {
    
    //MARK: - Properties
    private let headerView = SettingHeader()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
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
    
    func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func confogureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        tableView.separatorStyle = .none //테이블뷰 구분선 제거
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(SettingCell.self, forCellReuseIdentifier: reuserIdentifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
    }

}

//MARK: - UITableViewDataSource

extension SettingsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as! SettingCell
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SettingsController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("DEBUG: Section is \(section)")
        guard let section = SettingSection(rawValue: section) else { return nil }
        return section.description
    }
    
    //높이 동적으로 설정 가능
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingSection(rawValue: indexPath.section) else { return 0 }
        return section == .ageRange ? 96 : 44
    }
}

//MARK: - SettingHeaderDelegate

extension SettingsController: SettingHeaderDelegate {
    func settingHeader(_ header: SettingHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        
        setHeaderImage(selectedImage)
        
        dismiss(animated: true)
    }
}
