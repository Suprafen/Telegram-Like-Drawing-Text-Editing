//
//  IPAvailableFontsCollectionViewController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 20.11.22.
//

import Foundation
import UIKit

class IPAvailableFontsCollectionViewController: UICollectionViewController {
        
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, IPFont>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, IPFont>
    
    var delegate: IPAvailableFontsCollectionViewControllerDelegate?
    
    var dataSource: DataSource!
    
    var availableFontsStorage = IPAvailableFontsStorage()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        configureDataSource()
        
        collectionView.register(IPAvailableFontCollectionViewCell.self,
                                forCellWithReuseIdentifier: IPAvailableFontCollectionViewCell.reuseIdentifier)
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)!
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        
        let index = indexPath.item
        
        if index < availableFontsStorage.availableFonts.count {
            
            let chosenFont = availableFontsStorage.availableFonts[index]
            
            delegate?.availableFontsCollectionViewController(chooseFont: chosenFont)
            
        }
        
    }
    
    // MARK: - Helper methods
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    

    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: {
            
            collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IPAvailableFontCollectionViewCell.reuseIdentifier, for: indexPath) as! IPAvailableFontCollectionViewCell
            
            cell.configure(withItem: item)
            cell.layer.cornerRadius = 10
            
            return cell
        })
        
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(self.availableFontsStorage.availableFonts, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}
