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
        // change current font
        // Delegate can help, I believe
    }
    
    // MARK: - Helper methods
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        
        return layout
    }
    
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: {
            
            collectionView, indexPath, item -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IPAvailableFontCollectionViewCell.reuseIdentifier, for: indexPath) as! IPAvailableFontCollectionViewCell
            
            
            
            cell.configure(withItem: item)
            cell.layer.cornerRadius = 10
            print("Cell \(cell)")
            return cell
        })
        
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(self.availableFontsStorage.availableFonts, toSection: .main)
        
        dataSource.apply(snapshot)
    }
}
