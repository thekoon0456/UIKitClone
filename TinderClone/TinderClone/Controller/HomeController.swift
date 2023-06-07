//
//  HomeController.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/28.
//

import UIKit
import Firebase

final class HomeController: UIViewController {
    
    //MARK: - Properties
    
    private var user: User?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureUI()
        fetchCurrentUserAndCards()

    }
    
    //MARK: - API
    
    func fetchUsers(forCurretUser user: User) {
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map { CardViewModel(user: $0) }
        }
    }
    
    func fetchCurrentUserAndCards() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.fetchUsers(forCurretUser: user)
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("DEBUG: 유저 로그인 함")
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: 로그아웃 실패")
        }
    }
    
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Service.saveSwipe(forUser: user, isLike: didLike) { error in
            self.topCardView = self.cardViews.last
            
            //true일때만 아래 매칭코드 실행
            guard didLike == true else { return }
            
            Service.checkIfMatchExists(forUser: user) { didMatch in
                self.presentMatchView(forUser: user)
                
                guard let currentUser = self.user else { return }
                Service.uploadMatch(currentUser: currentUser, matchedUser: user)
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
//            cardViews.append(cardView)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.compactMap { $0 as? CardView }
        topCardView = cardViews.last
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        topStack.delegate = self
        bottomStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    // Auth.auth().signOut()로 API 호출한 뒤에 비동기 함수로 실행
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func presentMatchView(forUser user: User) {
        guard let currentUser = self.user else { return }
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1) {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: self.topCardView?.frame.width ?? 300,
                                             height: self.topCardView?.frame.height ?? 400)
        } completion: { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
}

//MARK: - HomeNavigationStackViewDelegate

extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        guard let user = self.user else { return }
        let controller = SettingsController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func showMessages() {
        guard let user = user else { return }
        let controller = MessageController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

//MARK: - SettingControllerDelegate

extension HomeController: SettingsControllerDelegate {
    func settingsControllerWantsToLogout(_ controller: SettingsController) {
        controller.dismiss(animated: true)
        logOut()
    }
    
    func settingsController(_ constoller: SettingsController, wantsToUpdate user: User) {
        constoller.dismiss(animated: true)
        self.user = user
    }
}

//MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll(where: { view == $0} )
        
        guard let user = topCardView?.viewModel.user else { return }
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
        
        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
        
    }
}

//MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        guard let user = self.user else { return }
        
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map { CardViewModel(user: $0) }
        }
    }
}

//MARK: - ProfileControllerDelegate

extension HomeController: ProfileControllerDelegate {
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        //profileController가 dismiss된 뒤 애니메이션 작동하도록 complition으로 구현
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            Service.saveSwipe(forUser: user, isLike: false, completion: nil)
        }
    }
}

//MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true)
        fetchCurrentUserAndCards()
    }
}

//MARK: - MatchViewDelegate

extension HomeController: MatchViewDelegate {
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User) {
        print("DEBUG: Startconversation with \(user.name)")
    }
    
    
}
