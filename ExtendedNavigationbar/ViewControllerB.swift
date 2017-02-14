//
//  ViewController.swift
//  ExtendedNavigationbar
//
//  Created by David Johnson on 2/11/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit

class ViewControllerB: UIViewController {
  lazy var testLabel: UILabel = {
    let label = UILabel()
    label.text = "FE FI FO FUM"
    label.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

extension ViewControllerB: ExtendedNavigationControllerProvider {
  var extendedView: UIView? {
    return testLabel
  }
}
