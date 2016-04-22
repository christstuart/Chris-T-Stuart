//
//  VC_EXT_LongRunningFunctions.swift
//  GCDLecture
//
//  Created by JamieBrown on 10/1/15.
//  Copyright © 2015 JamieBrown. All rights reserved.
//

import UIKit


extension ViewController {

    func LongRunningFunction(t: Double) {
        
        //Block thread for a number of seconds
        NSThread.sleepForTimeInterval(t);
    }
}
