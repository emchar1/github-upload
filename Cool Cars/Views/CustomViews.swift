//
//  CustomViews.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/12/22.
//

import UIKit


/**
 A custom UIStackView initialized with specific parameters.
 */
class MyStack: UIStackView {
    
    init(frame: CGRect = .zero, spacing: CGFloat = 0, distribution: Distribution, alignment: Alignment, axis: NSLayoutConstraint.Axis) {
        super.init(frame: frame)
        
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.axis = axis
        
        //Assumes layout constraints will be applied
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/**
 A custom UILabel initialized to a specified font and text.
 */
class MyLabel: UILabel {
    var uppercased = false

    init(frame: CGRect = .zero, font: UIFont?, textColor: UIColor? = .black, text: String = "", uppercased: Bool = false) {
        super.init(frame: frame)
        
        self.font = font ?? UIFont(name: "Avenir", size: 12)!
        self.text = uppercased ? text.uppercased() : text
        self.textColor = textColor ?? .black
        
        //Assumes layout constraints will be applied
        if frame == .zero {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/**
 A custom UIImageView initialized to a specificied contentMode, tintColor, and/or image.
 */
class MyImageView: UIImageView {
    init(frame: CGRect = .zero, contentMode: ContentMode, tintColor: UIColor? = nil, image: UIImage? = nil) {
        super.init(frame: frame)
        
        self.contentMode = contentMode
        self.tintColor = tintColor
        self.image = image
        
        if frame == .zero {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
