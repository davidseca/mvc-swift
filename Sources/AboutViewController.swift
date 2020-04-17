//
//  AboutViewController.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.title = L10n.Tabbar.about
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentLabel.text = L10n.About.content
    }

}
