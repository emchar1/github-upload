//
//  Constants.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/12/22.
//

import UIKit
import AVFoundation


/**
 General struct to house various shared properties across the app.
 */
struct K {
    static var carModels: [CarModel] = []
    static var selectedCarIndex = 1
    static var name: String?
    static let shouldAnimate = true
}


/**
 A struct of various fonts used throughout the app.
 */
struct MyFonts {
    static let mainFont = UIFont(name: "AvenirNextCondensed-Bold", size: 32)
    static let subFont = UIFont(name: "AvenirNextCondensed-Medium", size: 16)
    static let subFont2 = UIFont(name: "AvenirNextCondensed-Italic", size: 14)
    static let currentCarFont = UIFont(name: "AvenirNextCondensed-MediumItalic", size: 24)
    static let defaultFont = UIFont(name: "Avenir", size: 11)
}


/**
 Animates a circle path, used for the miles this month metric.
 */
class CircleView: UIView {
    let circleLayer: CAShapeLayer!
    
    init(frame: CGRect, strokeEnd: CGFloat = 0.0) {
        circleLayer = CAShapeLayer()
        
        super.init(frame: frame)

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                      radius: (frame.size.width - 10)/2,
                                      startAngle: 0,
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        let circleLayerTrack = CAShapeLayer()
        circleLayerTrack.path = circlePath.cgPath
        circleLayerTrack.fillColor = UIColor.clear.cgColor
        circleLayerTrack.strokeColor = (UIColor(named: "mileageProgressTrack") ?? UIColor.lightGray).cgColor
        circleLayerTrack.lineWidth = 8.0
        circleLayerTrack.lineCap = .round
        circleLayerTrack.strokeEnd = 1.0

        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = (UIColor(named: "mileageProgress") ?? UIColor.gray).cgColor
        circleLayer.lineWidth = 8.0
        circleLayer.lineCap = .round
        circleLayer.strokeEnd = strokeEnd
        
        layer.addSublayer(circleLayerTrack)
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: TimeInterval, fromValue: TimeInterval = 0, toValue: TimeInterval) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        circleLayer.strokeEnd = toValue
        circleLayer.add(animation, forKey: "animateCircle")
    }    
}


/**
 Converts a csv file into a 2D array of strings. This function tokenizes comma separated values. If there's a comma within the data itself, this function will most likely break; therefore it should only be used for csv files with simple data.
 - parameters:
    - file: the name of the file in the project folder
    - ext: the file extension, typically a csv
 - returns: a 2D array of Strings with the csv info
 */
func getCSVData(file: String, ext: String) -> [[String]] {
    do {
        let path = Bundle.main.path(forResource: file, ofType: ext)
        let content = try String(contentsOfFile: path ?? "")
        let parsedCSV: [String] = content.components(separatedBy: "\r\n").map { $0 }
        var parsedCSVComplete: [[String]] = []
        
        for line in parsedCSV {
            parsedCSVComplete.append(line.components(separatedBy: ",").map { $0 })
        }
        
        return parsedCSVComplete
    }
    catch {
        return []
    }
}


/**
 A simple audio player.
 */
struct AudioPlayer {
    static var player: AVAudioPlayer?
    
    static func playSound(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.volume = 0.4
            player.play()
        }
        catch {
            print("Error loading \(filename)")
        }
    }
}
