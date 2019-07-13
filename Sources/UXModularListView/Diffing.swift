//
//  Diffing.swift
//  UXModularListView
//
//  Created by Christian Schnorr on 13.07.19.
//  Copyright © 2019 Christian Schnorr. All rights reserved.
//

import Swift


private protocol DiffableContentContainer {
    func moveItem(from sourceIndexPath: IndexPath, to targetIndexPath: IndexPath)
    func deleteItem(at sourceIndexPath: IndexPath)
    func insertItem(at targetIndexPath: IndexPath)
}

extension DiffableContentContainer {
    fileprivate func difference<T>(from oldValue: [T], to newValue: [T]) -> CollectionDifference<T.ID> where T: Identifiable {
        let oldIdentifiers = oldValue.map({ $0.id })
        let newIdentifiers = newValue.map({ $0.id })

        return newIdentifiers.difference(from: oldIdentifiers)
    }

    fileprivate func modifyItems<T>(using difference: CollectionDifference<T>) where T: Hashable {
        for change in difference.inferringMoves() {
            switch change {
            case .remove(offset: let sourceIndex, element: _, associatedWith: let targetIndex):
                let sourceIndexPath = IndexPath(item: sourceIndex, section: 0)

                // If the removal is matched with an insertion, perform a move
                // instead of a removal and an insertion later.
                if let targetIndexPath = targetIndex.map({ IndexPath(item: $0, section: 0) }) {
                    self.moveItem(from: sourceIndexPath, to: targetIndexPath)
                } else {
                    self.deleteItem(at: sourceIndexPath)
                }
            case .insert(offset: let targetIndex, element: _, associatedWith: let sourceIndex):
                let targetIndexPath = IndexPath(item: targetIndex, section: 0)

                // If the insertion is matched with a removal, the move is
                // performed when processing the removal.
                if sourceIndex == nil {
                    self.insertItem(at: targetIndexPath)
                }
            }
        }
    }
}


// MARK: - UIKit Conformances

#if canImport(UIKit)
import UIKit

extension UITableView: DiffableContentContainer {
    public func animate<T>(from oldValue: [T], to newValue: [T]) where T: Identifiable {
        let difference = self.difference(from: oldValue, to: newValue)

        self.performBatchUpdates({
            self.modifyItems(using: difference)
        })
    }

    fileprivate func deleteItem(at sourceIndexPath: IndexPath) {
        self.deleteRows(at: [sourceIndexPath], with: .fade)
    }

    fileprivate func insertItem(at targetIndexPath: IndexPath) {
        self.insertRows(at: [targetIndexPath], with: .fade)
    }

    fileprivate func moveItem(from sourceIndexPath: IndexPath, to targetIndexPath: IndexPath) {
        self.moveRow(at: sourceIndexPath, to: targetIndexPath)
    }
}

extension UICollectionView: DiffableContentContainer {
    public func animate<T>(from oldValue: [T], to newValue: [T]) where T: Identifiable {
        let difference = self.difference(from: oldValue, to: newValue)

        self.performBatchUpdates({
            self.modifyItems(using: difference)
        })
    }

    fileprivate func deleteItem(at sourceIndexPath: IndexPath) {
        self.deleteItems(at: [sourceIndexPath])
    }

    fileprivate func insertItem(at targetIndexPath: IndexPath) {
        self.insertItems(at: [targetIndexPath])
    }

    fileprivate func moveItem(from sourceIndexPath: IndexPath, to targetIndexPath: IndexPath) {
        self.moveItem(at: sourceIndexPath, to: targetIndexPath)
    }
}
#endif
