//
//  SequenceTask.swift
//  
//
//  Created by hoseung Lee on 2022/09/03.
//

import Foundation

public final class SequenceTask: SequenceItem, TimeSetable {
  public var timeInterval: TimeInterval
  public let workItem: () -> Void

  public init(timeInterval: TimeInterval, workItem: @escaping () -> Void) {
    self.timeInterval = timeInterval
    self.workItem = workItem
  }

  public func setTime(time: TimeInterval) {
    self.timeInterval += time
  }
}
