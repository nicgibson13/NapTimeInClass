//
//  MyTimer.swift
//  NapTimeInClass
//
//  Created by Nic Gibson on 6/18/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import Foundation

protocol MyTimerDelegate: class {
    func timerCompleted()
    func timerStopped()
    func timerSecondTicked()
}

class MyTimer: NSObject {
    
    // How many seconds are remaining in our nap? Hopefully 0
    var timeRemaining: TimeInterval?
    
    // The timer object we are hiding behind our wrapper (MyTimer)
    var timer: Timer?
    
    // Create a weak variable delegate on the object class
    weak var delegate: MyTimerDelegate?
    
    var isOn: Bool {
        if timeRemaining != nil {
            return true
        } else {
            return false
        }
    }
    
    private func secondTicked() {
        guard let timeRemaining = timeRemaining else {return}
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            delegate?.timerSecondTicked()
            print(timeRemaining)
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            delegate?.timerCompleted()
        }
    }
    
    func startTimer(_ time: TimeInterval) {
        if isOn == false {
            self.timeRemaining = time
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                self.secondTicked()
            })
        }
    }
    
    func stopTimer() {
        if isOn {
            self.timeRemaining = nil
            timer?.invalidate()
            delegate?.timerStopped()
        }
    }
}
