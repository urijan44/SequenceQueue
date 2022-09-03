//
//  SequenceItem.swift
//  
//
//  Created by hoseung Lee on 2022/09/03.
//

import Foundation

public protocol SequenceItem {
  var timeInterval: TimeInterval { get }
  var workItem: () -> Void { get }
}
