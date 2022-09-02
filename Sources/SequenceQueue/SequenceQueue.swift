import Foundation

public protocol SequenceItem {
  var timeInterval: TimeInterval { get }
  var workItem: () -> Void { get }
}

public protocol TimeSetable {
  func setTime(time: TimeInterval)
}

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

public final class SequenceQueue<T> where T: TimeSetable, T: SequenceItem {

  @resultBuilder
  public struct BlockBuilder<T> where T: TimeSetable, T: SequenceItem {
    public static func buildBlock(_ components: T...) -> ContiguousArray<T> {
      var start = TimeInterval.zero
      let new = components.map { item in
        item.setTime(time: start)
        start += item.timeInterval
        return item
      }
      return ContiguousArray(new)
    }
  }

  private let queue = DispatchQueue(
    label: "SequenceMain"
    , qos: .default,
    attributes: .concurrent,
    autoreleaseFrequency: .inherit,
    target: nil
  )

  private var blocks: ContiguousArray<T>

  private var count: Int {
    blocks.count
  }

  private var passedTime: TimeInterval = .zero

  public init(@BlockBuilder<T> content: () -> ContiguousArray<T>) {
    self.blocks = content()
  }

  public func run() {
    blocks.forEach { block in
      queue.asyncAfter(deadline: .now() + block.timeInterval) {
        block.workItem()
      }
    }
  }
}
