//
//  ThreadHelper.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation


public func dispatchMainAsync(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}

public func dispatchMainAsync<TSelf: AnyObject>(weakVar: TSelf, _ closure: @escaping (TSelf) -> Void) {
    DispatchQueue.main.async { [weak weakVar = weakVar] in
        guard let strongVar = weakVar else { return }
        closure(strongVar)
    }
}

public func delay(deadline: DispatchTime, on dispatch: DispatchQueue = .main, _ closure: @escaping () -> Void) {
    dispatch.asyncAfter(deadline: deadline, execute: closure)
}

public func delay<TSelf: AnyObject>(weakVar: TSelf, deadline: DispatchTime, on dispatch: DispatchQueue = .main, _ closure: @escaping (TSelf) -> Void) {
    dispatch.asyncAfter(deadline: deadline) { [weak weakVar = weakVar] in
        guard let strongVar = weakVar else { return }
        closure(strongVar)
    }
}
