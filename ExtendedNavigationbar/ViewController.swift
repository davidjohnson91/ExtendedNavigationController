//
//  ViewController.swift
//  ExtendedNavigationbar
//
//  Created by David Johnson on 2/11/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  lazy var testLabel: UILabel = {
    let label = UILabel()
    label.text = "FOO BAR BAZ"
    label.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
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

extension ViewController: ExtendedNavigationControllerProvider {
  var extendedView: UIView? {
    return testLabel
  }
}
