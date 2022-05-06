//
//  CarsCell.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/11/22.
//

import UIKit

class CarsCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    class var reuseID: String { "CarsCell" }
    let cellPadding: CGFloat = 14
    
    var carSelectedIndicator = MyImageView(frame: .zero, contentMode: .scaleAspectFit, tintColor: .systemBlue, image: UIImage(systemName: "checkmark.circle.fill"))
    var vStackMakeModel = MyStack(frame: .zero, spacing: -8, distribution: .fill, alignment: .leading, axis: .vertical)
    var hStackSub = MyStack(frame: .zero, spacing: 4, distribution: .fill, alignment: .leading, axis: .horizontal)
    var carMakeLabel = MyLabel(font: MyFonts.mainFont, textColor: UIColor(named: "mainFont"))
    var carModelLabel = MyLabel(font: MyFonts.subFont, textColor: UIColor(named: "subFont"))
    var swapVehicleLabel = MyLabel(font: MyFonts.subFont2, textColor: UIColor(named: "subFont2"), text: "Swap My Vehicle For This One")
    var spacerLabel = MyLabel(font: MyFonts.defaultFont, text: " ")
    var swapVehicleImage = MyImageView(frame: .zero, contentMode: .scaleAspectFit, tintColor: UIColor(named: "subFont2"), image: UIImage(systemName: "arrow.right"))
    var carImage = MyImageView(frame: .zero, contentMode: .scaleAspectFit, tintColor: nil, image: nil)
    var mileageLabel = MyLabel(font: MyFonts.subFont, textColor: UIColor(named: "subFont2"))
    var mileageView: CircleView?

    var carModel: CarModel! {
        didSet {
            carImage.image = UIImage(named: carModel.imageName)
            carMakeLabel.text = carModel.make.uppercased()
            carModelLabel.text = "\(carModel.year) - \(carModel.model.uppercased())"
            
            if carModel.milesThisMonth >= carModel.maxMiles {
                swapVehicleLabel.text = "Unavailable"
                swapVehicleImage.alpha = 0
            }
            else {
                swapVehicleLabel.text = "Swap My Vehicle For This One"
                swapVehicleImage.alpha = 1.0
            }
        }
    }
 
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                        
        setShadow()
                
        contentView.backgroundColor = UIColor(named: "whitish")
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = false             //Need this to allow drop shadow to come through
        contentView.layer.cornerRadius = 8

        vStackMakeModel.addArrangedSubview(carMakeLabel)
        vStackMakeModel.addArrangedSubview(carModelLabel)
        hStackSub.addArrangedSubview(swapVehicleLabel)
        hStackSub.addArrangedSubview(swapVehicleImage)
        
        contentView.addSubview(carSelectedIndicator)
        contentView.addSubview(carImage)
        contentView.addSubview(vStackMakeModel)
        contentView.addSubview(hStackSub)

        carSelectedIndicator.isHidden = true
        
        NSLayoutConstraint.activate([carSelectedIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellPadding),
                                     contentView.trailingAnchor.constraint(equalTo: carSelectedIndicator.trailingAnchor, constant: cellPadding),
                                     carSelectedIndicator.widthAnchor.constraint(equalToConstant: 30),
                                     carSelectedIndicator.heightAnchor.constraint(equalToConstant: 30)])

        NSLayoutConstraint.activate([carImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellPadding),
                                     carImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellPadding),
                                     carImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.6),
                                     carImage.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.4)])
        
        NSLayoutConstraint.activate([vStackMakeModel.topAnchor.constraint(equalTo: carImage.bottomAnchor),
                                     vStackMakeModel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellPadding)])
        
        NSLayoutConstraint.activate([hStackSub.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellPadding),
                                     contentView.bottomAnchor.constraint(equalTo: hStackSub.bottomAnchor, constant: cellPadding)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    
    // MARK: - Helper Methods
    
    /**
     Sets the shadow on the cell. If the cell is pressed, add a quick animation simulating a button press, i.e. set shadow opaicty to 0 (no shadow)
     - parameter pressed: If true, show a shadow on the cell
     */
    func setShadow(pressed: Bool = false) {
        let shadowOffset: CGFloat = 2
        let shadowOpacity: Float = 0.5
        
        contentView.layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        
        if pressed {
            contentView.layer.shadowOpacity = 0
            UIView.animate(withDuration: 0.35) { self.contentView.layer.shadowOpacity = shadowOpacity }
        }
        else {
            contentView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    /**
     Determines wheter to display the carSelectedIndicator image if this particular car has been selected.
     - parameter isSelected: True if the car is selected and needs to display blue checkmark
     */
    func setSelected(_ isSelected: Bool) {
        carSelectedIndicator.isHidden = isSelected ? false : true
    }
    
    func setMileageView(carModel: CarModel) {
        let size = contentView.bounds.height * 0.4
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        mileageView = CircleView(frame: CGRect(x: 0, y: 0, width: size, height: size),
                                 strokeEnd: CGFloat(carModel.milesThisMonth) / CGFloat(carModel.maxMiles))
        mileageView?.translatesAutoresizingMaskIntoConstraints = false
        mileageLabel.text = numberFormatter.string(from: NSNumber(value: carModel.milesThisMonth))
        mileageLabel.textColor = carModel.milesThisMonth >= carModel.maxMiles ? .systemRed : UIColor(named: "subFont2")

        contentView.addSubview(mileageView!)
        contentView.addSubview(mileageLabel)
        
        NSLayoutConstraint.activate([contentView.trailingAnchor.constraint(equalTo: mileageView!.trailingAnchor, constant: size + cellPadding),
                                     contentView.bottomAnchor.constraint(equalTo: mileageView!.bottomAnchor, constant: size + cellPadding)])
        NSLayoutConstraint.activate([mileageLabel.centerXAnchor.constraint(equalTo: mileageView!.centerXAnchor, constant: size / 2),
                                     mileageLabel.centerYAnchor.constraint(equalTo: mileageView!.centerYAnchor, constant: size / 2)])
    }
}
