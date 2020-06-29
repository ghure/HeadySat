//
//  VariantViewController.swift
//  HeadySat
//
//  Created by Captain on 6/29/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import UIKit

extension VariantViewController {
    private enum State {
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYPosition: CGFloat = 300
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height - 300 }
    }
}

protocol PopOverViewDelegate {
    func getTableViewCount(IndexPath index:IndexPath?) -> Int
    func getCellConfigration(cell: WithLabelTableViewCell, mainIndexPath index:IndexPath?, currentIndexPath currentIndex: IndexPath) -> WithLabelTableViewCell
    func getSelectedIndex(mainIndexPath index:IndexPath?, currentIndexPath currentIndex: IndexPath)
}

class VariantViewController: UIViewController {
    
    var delegate: PopOverViewDelegate?
    private var indexPath: IndexPath?
    @IBOutlet weak var tableView: UITableView!
//    private var variants: [VariantModel] = []
    private let catCell = "variantCell"
    private let defaultCell = "cell"
    private var allowsSelection = false
    @IBAction func didCloseBtnPressed(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        self.roundViews()
        self.loadTableView()
    }
    func loadTableView() {
     self.tableView.register(UINib(nibName: WithLabelTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: self.catCell)
        self.tableView.allowsSelection = self.allowsSelection
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: {
            self.moveView(state: .partial)
        })
//        loadTableView()
    }
    
    func addIndex(indexPath index: IndexPath? = nil, tableViewSelection: Bool? = false) {
        self.indexPath = index
        self.allowsSelection = tableViewSelection!
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: State = recognizer.velocity(in: self.view).y >= 0 ? .partial : .full
                self.moveView(state: state)
            }, completion: nil)
        }
    }
    
    func roundViews() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
}

extension VariantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let delegate = self.delegate {
            return delegate.getTableViewCount(IndexPath: self.indexPath)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: WithLabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.catCell, for: indexPath) as? WithLabelTableViewCell{
            
            if let delegate = self.delegate {
                let cellUpdated = delegate.getCellConfigration(cell: cell, mainIndexPath: self.indexPath, currentIndexPath: indexPath)
            cellUpdated.visualView.backgroundColor = (indexPath.row % 2) == 0 ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1): #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cellUpdated
            }
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCell)
        cell?.textLabel?.text = "No cell to display"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.getSelectedIndex(mainIndexPath: self.indexPath, currentIndexPath: indexPath)
        }
    }
}
