//
//  FPSMonitor.swift
//
//  Created by Cong Sun on 3/31/17.
//  Copyright © 2017 Cong Sun. All rights reserved.
//

import Foundation
import UIKit

class FPSMonitor: NSObject {
    
    static let shared = FPSMonitor()
    
    private let kDisplayWidth: CGFloat = 60
    private let kDisplayHeight: CGFloat = 20

    private let displayLabel: UILabel
    private var displayLink: CADisplayLink?
    private var fpsCount: Int = 0
    private var lastTime: TimeInterval = 0
    
    private override init() {
        //Setup Label
        self.displayLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width - kDisplayWidth) / 2, y: 15, width: kDisplayWidth, height: kDisplayHeight))
        self.displayLabel.layer.cornerRadius = 5
        self.displayLabel.clipsToBounds = true
        self.displayLabel.textAlignment = .center
        self.displayLabel.isUserInteractionEnabled = false
        self.displayLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.displayLabel.textColor = UIColor.green
        self.displayLabel.font = UIFont.systemFont(ofSize: 12)
        super.init()
    }
    
    public func start() {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            print("ERROR: Unable to work when keyWindow is nil")
            return
        }
        
        if self.displayLink == nil {
            //Setup displayLink
            self.displayLink = CADisplayLink(target: self, selector: #selector(update(link:)))
            self.displayLink?.add(to: RunLoop.main, forMode: .commonModes)
        }
        
        guard !keyWindow.subviews.contains(self.displayLabel) else { return }
        
        keyWindow.addSubview(self.displayLabel)
    }
    
    public func stop() {
        guard let keyWindow = UIApplication.shared.keyWindow, keyWindow.subviews.contains(self.displayLabel) else { return }
        self.displayLabel.removeFromSuperview()
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    @objc private func update(link: CADisplayLink) {
        
        guard self.lastTime != 0 else {
            self.lastTime = link.timestamp
            return
        }
        
        self.fpsCount += 1
        let delta = link.timestamp - self.lastTime
        if delta >= 0.5 {
            self.lastTime = link.timestamp
            let fps = Int(Double(self.fpsCount) / delta)
            self.fpsCount = 0
            self.displayLabel.text = "\(fps) FPS"
        }
    }
    
    deinit {
        self.stop()
    }
}
