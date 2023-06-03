//
//  SettingsController.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/01.
//

import UIKit
import JGProgressHUD

private let reuserIdentifier = "SettingCell"

protocol SettingsControllerDelegate: AnyObject {
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
    func settingsControllerWantsToLogout(_ controller: SettingsController)
}

class SettingsController: UITableViewController {
    
    //MARK: - Properties
    
    private var user: User
    
    private lazy var headerView = SettingHeader(user: user)
    private let footerView = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    weak var delegate: SettingsControllerDelegate?
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confogureUI()
    }
    
    //MARK: - Actions
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Your Data"
        hud.show(in: view)
        Service.saveUserData(user: user) { [self] error in
            self.delegate?.settingsController(self, wantsToUpdate: user)
        }

    }
    
    //MARK: - API
    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Image"
        hud.show(in: view)
        
        Service.uploadImage(image:image) { imageUrl in
            self.user.imageUrls.append(imageUrl)
            hud.dismiss()
        }
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
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.delegate = self
    }

}

//MARK: - UITableViewDataSource

extension SettingsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as! SettingCell
        
        guard let section = SettingSections(rawValue: indexPath.section) else { return cell }
        let viewModel = SettingViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SettingsController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingSections(rawValue: section) else { return nil }
        return section.description
    }
    
    //높이 동적으로 설정 가능
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingSections(rawValue: indexPath.section) else { return 0 }
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
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)
        
        dismiss(animated: true)
    }
}

//MARK: - SettingsCellDelegate

extension SettingsController: SettingCellDelegate {
    func settingCell(_ cell: SettingCell, wantsToUpdateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingCell(_ cell: SettingCell, wantsToUpdateUserWith value: String, for section: SettingSections) {
        switch section {
        case .name:
            user.name = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .ageRange:
            break
        }
    }
}

//MARK: - SettingsFooterDelegate

extension SettingsController: SettingsFooterDelegate {
    func handleLogout() {
        delegate?.settingsControllerWantsToLogout(self)
    }
    
    
}
