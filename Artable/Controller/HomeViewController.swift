//
//  ViewController.swift
//  Artable
//
//  Created by Brendon Bitencourt Braga on 2019-10-08.
//  Copyright © 2019 Brendon Bitencourt Braga. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loginOutBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories = [Category]()
    var selectedCategory: Category?
    var db: Firestore?
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupCollectionView()
        setupInitialAnonymousUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBarButton.title = "Logout"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        } else {
            loginOutBarButton.title = "Login"
        }
        
        setCategoriesListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCollectionViewCell)
    }
    
    func setupInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleError(error: error, viewController: self)
                }
            }
        }
    }
    
    func fetchDocument() {
        let documentRef = db?.collection("categories").document("uqaLsbaYFRdxWmMEvvOX")
        documentRef?.getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else { return }
            let newCategory = Category.init(data: data)
            self.categories.append(newCategory)
            self.collectionView.reloadData()
        }
    }
    
    func fetchDocumentListener() {
        let documentRef = db?.collection("categories").document("uqaLsbaYFRdxWmMEvvOX")
        listener = documentRef?.addSnapshotListener({ (snapshot, error) in
            guard let data = snapshot?.data() else { return }
            let newCategory = Category.init(data: data)
            if self.categories.count > 0 {
                let index = self.categories.firstIndex { (category) -> Bool in
                    return category.id == newCategory.id
                }
                if let index = index, index >= 0 {
                    self.categories[index] = newCategory
                }
            } else {
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
        })
    }
    
    func fetchCollection() {
        let collectionRef = db?.collection("categories")
        collectionRef?.getDocuments(completion: { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
        })
    }
    
    func fetchCollectionListener() {
        let collectionRef = db?.collection("categories")
        listener = collectionRef?.addSnapshotListener({ (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            self.categories.removeAll()
            for document in documents {
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
        })
    }
    
    func setCategoriesListener() {
        listener = db?.categories.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                    case .added:
                        self.onDocumentAdded(change, category)
                    case .modified:
                        self.onDocumentModified(change, category)
                    case .removed:
                        self.onDocumentRemoved(change)
                    @unknown default:
                        fatalError()
                }
            })
            
        })
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginNavigationController)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func loginOutClicked(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleError(error: error, viewController: self)
                    }
                    self.presentLoginController()
                }
            } catch {
                Auth.auth().handleError(error: error, viewController: self)
            }
        }
    }
     
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCollectionViewCell, for: indexPath) as? CategoryCollectionViewCell {
            cell.setupCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsViewController {
                destination.category = selectedCategory
            }
        } else if segue.identifier == Segues.ToFavorites {
            if let destination = segue.destination as? ProductsViewController {
                destination.category = selectedCategory
                destination.showFavoritesOnly = true
            }
        }
    }
    
    fileprivate func onDocumentAdded(_ change: DocumentChange, _ category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    fileprivate func onDocumentModified(_ change: DocumentChange, _ category: Category) {
        let oldIndex = Int(change.oldIndex)
        let newIndex = Int(change.newIndex)
        
        if change.oldIndex == change.newIndex {
            categories[newIndex] = category
            collectionView.reloadItems(at: [IndexPath(item: newIndex, section: 0)])
        } else {
            let oldIndexPath = IndexPath(item: oldIndex, section: 0)
            let newIndexPath = IndexPath(item: newIndex, section: 0)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
        }
    }
    
    fileprivate func onDocumentRemoved(_ change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
}

