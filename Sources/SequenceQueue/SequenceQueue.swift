import Foundation

public final class SequenceQueue {
  public typealias T = TimeSetable & SequenceItem

  @resultBuilder
  public struct SerialBuilder {
    public static func buildBlock(_ components: T...) -> ContiguousArray<T> {
      var timeOffset = TimeInterval.zero
      let appliedBlocks = components.map { item in
        let divider = item.timeInterval == 0 ? 0.00000000001 : 0
        item.setTime(time: timeOffset + divider)
        timeOffset = item.timeInterval
        return item
      }
      return ContiguousArray(appliedBlocks)
    }
  }

  @resultBuilder
  public struct ParallelBuilder {
    public static func buildBlock(_ components: T...) -> ContiguousArray<T> {
      return ContiguousArray(components)
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

  public init(@SerialBuilder serial: () -> ContiguousArray<T>) {
    self.blocks = serial()
  }

  public init(@ParallelBuilder parallel: () -> ContiguousArray<T>) {
    self.blocks = parallel()
  }

  public func run() {
    blocks.forEach { block in
      queue.asyncAfter(deadline: .now() + block.timeInterval) {
        block.workItem()
      }
    }
  }
}
