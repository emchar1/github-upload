//
//  CarsDetailController.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/12/22.
//

import UIKit

protocol CarsDetailControllerDelegate {
    func didSelectCar(_ car: CarModel)
}


class CarsDetailController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var selectButton: UIBarButtonItem?
    
    var carModel: CarModel! {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            carImage.image = UIImage(named: carModel.imageName)
            carMakeLabel.text = carModel.make.uppercased()
            carModelLabel.text = "\(carModel.year) - \(carModel.model.uppercased())"
            mpgLabel.text = "\(carModel.mpgCity)/\(carModel.mpgHighway)"
            hpLabel.text = "\(carModel.hp)"
            zeroToSixtyLabel.text = "\(carModel.zeroToSixty)"
            milesThisMonthLabel.text = K.shouldAnimate ? "0" : "\(carModel.milesThisMonth)"

            if carModel.milesThisMonth >= carModel.maxMiles, let selectButton = selectButton {
                selectButton.isEnabled = false
                selectButton.title = "Unavailable"
            }
        }
    }
    
    var circleToValue: CGFloat {
        CGFloat(carModel.milesThisMonth) / CGFloat(carModel.maxMiles)
    }

    let cellPadding: CGFloat = 20
    var carImageLeadingAnchor: NSLayoutConstraint!
    var carImageTrailingAnchor: NSLayoutConstraint!
    var mileageView: CircleView!
    var isCurrentCar = false
    var delegate: CarsDetailControllerDelegate?
    
    //UI Properties
    let carImage = MyImageView(frame: .zero, contentMode: .scaleAspectFit, tintColor: nil, image: nil)
    let currentCarLabel = MyLabel(frame: .zero, font: MyFonts.currentCarFont, textColor: .white, text: "  Current Car  ")
    let vStackMakeModel = MyStack(frame: .zero, spacing: -8, distribution: .fill, alignment: .leading, axis: .vertical)
    let carMakeLabel = MyLabel(font: MyFonts.mainFont, textColor: UIColor(named: "mainFont"))
    let carModelLabel = MyLabel(font: MyFonts.subFont, textColor: UIColor(named: "subFont"))
    let vStackStats = MyStack(frame: .zero, spacing: 0, distribution: .fill, alignment: .leading, axis: .vertical)
    let hStacks = [MyStack(frame: .zero, spacing: 0, distribution: .fill, alignment: .center, axis: .horizontal),
                   MyStack(frame: .zero, spacing: 0, distribution: .fill, alignment: .center, axis: .horizontal),
                   MyStack(frame: .zero, spacing: 0, distribution: .fill, alignment: .center, axis: .horizontal)]
    let mpgSpacer = MyLabel(frame: .zero, font: MyFonts.subFont, textColor: UIColor(named: "subFont"), text: " ")
    let mpgImage = MyImageView(frame: .zero, contentMode: .scaleAspectFit, tintColor: UIColor(named: "subFont"), image: UIImage(systemName: "fuelpump.circle.fill"))
    let mpgHeaderLabel = MyLabel(frame: .zero, font: MyFonts.subFont, textColor: UIColor(named: "subFont"), text: "MPG")
    let mpgLabel = MyLabel(frame: .zero, font: MyFonts.mainFont, textColor: UIColor(named: "mainFont"))
    let hpSpacer = MyLabel(frame: .zero, font: MyFonts.subFont, textColor: UIColor(named: "subFont"), text: " ")
    let hpImage = MyImageView(frame: .zero, contentMode: .scaleAspectFit, tintColor: UIColor(named: "subFont"), image: UIImage(systemName: "chart.bar.fill"))
    let hpHeaderLabel = MyLabel(frame: .zero, font: MyFonts.subFont, textColor: UIColor(named: "subFont"), text: "HP")
    let hpLabel = MyLabel(frame: .zero, font: MyFonts.mainFont, textColor: UIColor(named: "mainFont"))
    let zeroToSixtySpacer = MyLabel(frame: .zero, font: MyFonts.subFont, textColor: UIColor(named: "subFont"), text: " ")
    let zeroToSixtyImage = MyImageView(frame: .zero, contentMode: .scaleAspectFit, tintColor: UIColor(named: "subFont"), image: UIImage(systemName: "speedometer"))
    let zeroToSixtyHeaderLabel = MyLabel(frame: .zero, font: MyFonts.subFont, textColor: UIColor(named: "subFont"), text: "0-60")
    let zeroToSixtyLabel = MyLabel(frame: .zero, font: MyFonts.mainFont, textColor: UIColor(named: "mainFont"))
    let milesThisMonthLabel = MyLabel(frame: .zero, font: MyFonts.mainFont, textColor: UIColor(named: "subFont2"))
    let milesMaxLabel = MyLabel(frame: .zero, font: MyFonts.subFont, textColor: UIColor(named: "subFont2"), text: "of 2,000 miles")


    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectTapped(_ sender: UIBarButtonItem) {
        delegate?.didSelectCar(carModel)
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if carModel == nil {
            carModel = K.carModels[K.selectedCarIndex]
        }


        //Set up views
        view.backgroundColor = UIColor(named: "whitish")
        currentCarLabel.backgroundColor = .systemBlue
        currentCarLabel.layer.cornerRadius = 4
        currentCarLabel.clipsToBounds = true
        currentCarLabel.alpha = 0
        vStackMakeModel.alpha = K.shouldAnimate ? 0 : 1

        vStackMakeModel.addArrangedSubview(carMakeLabel)
        vStackMakeModel.addArrangedSubview(carModelLabel)
        
        mileageView = CircleView(frame: CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.width / 2),
                                 strokeEnd: K.shouldAnimate ? 0 : circleToValue)
        mileageView.translatesAutoresizingMaskIntoConstraints = false

        hStacks[0].addArrangedSubview(mpgSpacer)
        hStacks[0].addArrangedSubview(mpgImage)
        hStacks[0].addArrangedSubview(mpgHeaderLabel)
        hStacks[0].addArrangedSubview(mpgLabel)
        hStacks[1].addArrangedSubview(hpSpacer)
        hStacks[1].addArrangedSubview(hpImage)
        hStacks[1].addArrangedSubview(hpHeaderLabel)
        hStacks[1].addArrangedSubview(hpLabel)
        hStacks[2].addArrangedSubview(zeroToSixtySpacer)
        hStacks[2].addArrangedSubview(zeroToSixtyImage)
        hStacks[2].addArrangedSubview(zeroToSixtyHeaderLabel)
        hStacks[2].addArrangedSubview(zeroToSixtyLabel)
        vStackStats.addArrangedSubview(hStacks[0])
        vStackStats.addArrangedSubview(hStacks[1])
        vStackStats.addArrangedSubview(hStacks[2])
        
        view.addSubview(carImage)
        view.addSubview(currentCarLabel)
        view.addSubview(vStackMakeModel)
        view.addSubview(mileageView)
        view.addSubview(milesThisMonthLabel)
        view.addSubview(milesMaxLabel)
        view.addSubview(vStackStats)
        
        //Set up constraints
        if K.shouldAnimate {
            if carModel.imageFacing == .left {
                carImageLeadingAnchor = carImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width)
                carImageTrailingAnchor = view.trailingAnchor.constraint(equalTo: carImage.trailingAnchor, constant: cellPadding)
                NSLayoutConstraint.activate([carImageLeadingAnchor])
            }
            else {
                carImageLeadingAnchor = carImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: cellPadding)
                carImageTrailingAnchor = view.trailingAnchor.constraint(equalTo: carImage.trailingAnchor, constant: view.bounds.width)
                NSLayoutConstraint.activate([carImageTrailingAnchor])
            }
        }
        else {
            NSLayoutConstraint.activate([carImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: cellPadding),
                                         view.trailingAnchor.constraint(equalTo: carImage.trailingAnchor, constant: cellPadding)])
        }
        
        NSLayoutConstraint.activate([carImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     carImage.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.22)])
        
        NSLayoutConstraint.activate([currentCarLabel.centerXAnchor.constraint(equalTo: carImage.centerXAnchor),
                                     currentCarLabel.centerYAnchor.constraint(equalTo: carImage.centerYAnchor)])

        NSLayoutConstraint.activate([vStackMakeModel.topAnchor.constraint(equalTo: carImage.bottomAnchor),
                                     vStackMakeModel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: cellPadding)])
        
        NSLayoutConstraint.activate([mileageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(view.frame.width / 4)),
                                     mileageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.frame.width / 8)),
                                     milesThisMonthLabel.centerXAnchor.constraint(equalTo: mileageView.centerXAnchor, constant: (view.frame.width / 4)),
                                     milesThisMonthLabel.centerYAnchor.constraint(equalTo: mileageView.centerYAnchor, constant: (view.frame.width / 4)),
                                     milesMaxLabel.centerXAnchor.constraint(equalTo: mileageView.centerXAnchor, constant: (view.frame.width / 4)),
                                     milesMaxLabel.centerYAnchor.constraint(equalTo: mileageView.centerYAnchor, constant: (view.frame.width / 4) + 24)])
        
        hStacks[0].setCustomSpacing(0, after: mpgSpacer)
        hStacks[1].setCustomSpacing(0, after: hpSpacer)
        hStacks[2].setCustomSpacing(0, after: zeroToSixtySpacer)

        hStacks[0].setCustomSpacing(view.bounds.width, after: mpgHeaderLabel)
        hStacks[1].setCustomSpacing(view.bounds.width, after: hpHeaderLabel)
        hStacks[2].setCustomSpacing(view.bounds.width, after: zeroToSixtyHeaderLabel)
        
        NSLayoutConstraint.activate([vStackStats.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -60),
                                     view.trailingAnchor.constraint(equalTo: vStackStats.trailingAnchor, constant: -100),
                                     view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: vStackStats.bottomAnchor, constant: cellPadding)])
                        
        NSLayoutConstraint.activate([mpgImage.heightAnchor.constraint(equalToConstant: 30),
                                     mpgImage.widthAnchor.constraint(equalToConstant: 30),
                                     mpgHeaderLabel.widthAnchor.constraint(equalToConstant: 60)])
        
        NSLayoutConstraint.activate([hpImage.heightAnchor.constraint(equalToConstant: 30),
                                     hpImage.widthAnchor.constraint(equalToConstant: 30),
                                     hpHeaderLabel.widthAnchor.constraint(equalToConstant: 60)])

        NSLayoutConstraint.activate([zeroToSixtyImage.heightAnchor.constraint(equalToConstant: 30),
                                     zeroToSixtyImage.widthAnchor.constraint(equalToConstant: 30),
                                     zeroToSixtyHeaderLabel.widthAnchor.constraint(equalToConstant: 60)])
        
        //I don't like this!
        if !K.shouldAnimate {
            UIView.animate(withDuration: 0.0, delay: 0) {
                self.hStacks[0].setCustomSpacing(60 + self.cellPadding, after: self.mpgSpacer)
                self.hStacks[0].setCustomSpacing(0, after: self.mpgHeaderLabel)
            }
            UIView.animate(withDuration: 0.0, delay: 0) {
                self.hStacks[1].setCustomSpacing(60 + self.cellPadding, after: self.hpSpacer)
                self.hStacks[1].setCustomSpacing(0, after: self.hpHeaderLabel)
            }
            UIView.animate(withDuration: 0.0, delay: 0) {
                self.hStacks[2].setCustomSpacing(60 + self.cellPadding, after: self.zeroToSixtySpacer)
                self.hStacks[2].setCustomSpacing(0, after: self.zeroToSixtyHeaderLabel)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if K.shouldAnimate {
            //Animate the car
            if carModel.imageFacing == .left {
                carImageLeadingAnchor.constant = cellPadding
                NSLayoutConstraint.deactivate([carImageLeadingAnchor])
            }
            else {
                carImageTrailingAnchor.constant = cellPadding
                NSLayoutConstraint.deactivate([carImageTrailingAnchor])
            }
            
            NSLayoutConstraint.activate([carImageLeadingAnchor, carImageTrailingAnchor])
            
            //Animate the make and model
            UIView.animateKeyframes(withDuration: 1.0, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                    self.vStackMakeModel.alpha = 1
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    if self.isCurrentCar {
                        self.currentCarLabel.alpha = 0.85
                    }
                }
            }, completion: nil)
            
            //Animate the stats
            UIView.animate(withDuration: 0.25, delay: 0) {
                self.hStacks[0].setCustomSpacing(60 + self.cellPadding, after: self.mpgSpacer)
                self.hStacks[0].setCustomSpacing(0, after: self.mpgHeaderLabel)
            }
            UIView.animate(withDuration: 0.25, delay: 0.1) {
                self.hStacks[1].setCustomSpacing(60 + self.cellPadding, after: self.hpSpacer)
                self.hStacks[1].setCustomSpacing(0, after: self.hpHeaderLabel)
            }
            UIView.animate(withDuration: 0.25, delay: 0.2) {
                self.hStacks[2].setCustomSpacing(60 + self.cellPadding, after: self.zeroToSixtySpacer)
                self.hStacks[2].setCustomSpacing(0, after: self.zeroToSixtyHeaderLabel)
            }
            
            //Animate miles this month.
            mileageView.animateCircle(duration: 1.0, toValue: circleToValue)
            animateNumbers()
        }
    }
    

    /**
    Helper function to animate the incrementation of milesThisMonth from 0.
    */
    private func animateNumbers() {
        var numberToAnimate: Int = 0 {
            didSet {
                if numberToAnimate > carModel.milesThisMonth {
                    numberToAnimate = carModel.milesThisMonth
                }
            }
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if numberToAnimate < self.carModel.milesThisMonth {
                numberToAnimate += max(Int(Double(self.carModel.milesThisMonth) * 0.01), 1)
                self.milesThisMonthLabel.text = numberFormatter.string(from: NSNumber(value: numberToAnimate))
            }
            else {
                timer.invalidate()
                
                self.milesThisMonthLabel.textColor = numberToAnimate >= self.carModel.maxMiles ? .systemRed : UIColor(named: "subFont2")
            }
        }
    }
    
    
}

