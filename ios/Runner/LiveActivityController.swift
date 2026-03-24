import ActivityKit
import Foundation

@available(iOS 16.1, *)
struct HIITLiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var phaseLabel: String
    var segmentName: String
    var remainingSeconds: Int
    var progress: Double
    var isPaused: Bool
  }

  var workoutTitle: String
}

@available(iOS 16.1, *)
enum HIITLiveActivityController {
  static func start(
    workoutTitle: String,
    phaseLabel: String,
    segmentName: String,
    remainingSeconds: Int,
    progress: Double
  ) async throws -> String {
    let attributes = HIITLiveActivityAttributes(workoutTitle: workoutTitle)
    let state = HIITLiveActivityAttributes.ContentState(
      phaseLabel: phaseLabel,
      segmentName: segmentName,
      remainingSeconds: remainingSeconds,
      progress: progress,
      isPaused: false
    )

    let activity = try Activity.request(
      attributes: attributes,
      content: .init(state: state, staleDate: nil),
      pushType: nil
    )

    return activity.id
  }

  static func update(
    activityId: String,
    phaseLabel: String,
    segmentName: String,
    remainingSeconds: Int,
    progress: Double,
    isPaused: Bool
  ) async {
    guard let activity = Activity<HIITLiveActivityAttributes>.activities.first(where: { $0.id == activityId }) else {
      return
    }

    let updatedState = HIITLiveActivityAttributes.ContentState(
      phaseLabel: phaseLabel,
      segmentName: segmentName,
      remainingSeconds: remainingSeconds,
      progress: progress,
      isPaused: isPaused
    )

    await activity.update(.init(state: updatedState, staleDate: nil))
  }

  static func end(activityId: String) async {
    guard let activity = Activity<HIITLiveActivityAttributes>.activities.first(where: { $0.id == activityId }) else {
      return
    }

    await activity.end(nil, dismissalPolicy: .immediate)
  }
}
