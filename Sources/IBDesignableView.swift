//
//  IBDesignableView.swift
//  MVCSwift
//
//  Created by David Seca on 17.04.20.
//  Copyright © 2020 David Seca. All rights reserved.
//

import UIKit

/*
    Base class for all views that need to be @IBDesignable

    implementers of this class *MUST* override nibName()
*/
@IBDesignable class IBDesignableView: UIView {
    var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(self.nibName())
        self.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup(self.nibName())
        self.awakeFromNib()
    }

    func xibSetup(_ nibName: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView

        // use bounds not frame or it'll be offset
        view.frame = self.bounds

        // Make the view stretch with the containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

        // Add custom subview on top of our view
        addSubview(self.view)
    }

    func nibName() -> String {
        preconditionFailure("child classes must override nibName()")
    }
}
