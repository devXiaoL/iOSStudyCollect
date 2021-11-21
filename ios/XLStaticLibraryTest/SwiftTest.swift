//
//  SwiftTest.swift
//  XLStaticLibraryTest
//
//  Created by lang.li on 2021/11/21.
//  Copyright © 2021 lanbao. All rights reserved.
//

import Foundation
import UIKit

struct Animal {
    var weight: Float
    mutating func eat() {
        self.weight += 1
    }
    init(_ weight: Float) {
        self.weight = weight
    }
}

extension Animal {
    func run() {
        print("run")
    }
}

func test() {
    let a = Animal(20.0)
    a.run()
}

func test1(i: Int) -> Int {
    return i + 1;
}





