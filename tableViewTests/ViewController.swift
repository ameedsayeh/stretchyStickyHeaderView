//
//  ViewController.swift
//  tableViewTests
//
//  Created by Ameed Sayeh on 9/6/20.
//  Copyright © 2020 Ameed Sayeh. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    var numberOfCells = 19
    
    let imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = #imageLiteral(resourceName: "44")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let tableView: UITableView = {
    
        let tableView = UITableView()
        
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .systemPink
        tableView.backgroundView = view
        tableView.bounces = true
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let topView: UIView = {
    
        let view = UIView()
        
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let headerView: UIView = {
    
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        view.backgroundColor = .systemPink
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(Cell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(Cell1.self, forCellReuseIdentifier: "cell1")
        self.tableView.tableHeaderView = self.headerView
        
        
        self.setupLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.separatorStyle = .none
    }
    
    var widthConstraint: NSLayoutConstraint?
    var initValue: CGFloat?
    
    private func setupLayout() {
        
        self.view.backgroundColor = .systemPink
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.topView)
        self.view.addSubview(self.imageView)
        
        widthConstraint = self.imageView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 46) * (2/6))
        initValue = widthConstraint?.constant
        
        let constraints = [
            
            self.topView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.topView.heightAnchor.constraint(equalToConstant: 200),
            
            self.tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 46),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 46),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor),
            widthConstraint!
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        }
        
        cell.textLabel?.text = String(Int.random(in: 0...1000))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let initVal = self.initValue else { return }
        
        var newVal = initVal - (scrollView.contentOffset.y * 0.1)
        newVal = newVal < 80 ? 80 : newVal
        
        self.imageView.layer.cornerRadius = newVal / 2
        widthConstraint?.constant = newVal
        //print(scrollView.contentOffset)
    }
}


class Cell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.backgroundColor = .clear
        self.roundCorners([.topLeft, .topRight], radius: 16)
        
    }
}

class Cell1: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
}

extension UIView {
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
