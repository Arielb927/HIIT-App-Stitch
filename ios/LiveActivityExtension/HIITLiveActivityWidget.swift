import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct HIITLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: HIITLiveActivityAttributes.self) { context in
      ZStack {
        Color.black
        VStack(alignment: .leading, spacing: 8) {
          Text(context.attributes.workoutTitle.uppercased())
            .font(.caption)
            .foregroundColor(.white.opacity(0.8))

          Text(context.state.phaseLabel.uppercased())
            .font(.system(size: 28, weight: .black, design: .rounded))
            .foregroundColor(context.state.phaseLabel.uppercased() == "REST" ? .red : .green)

          Text(context.state.segmentName.uppercased())
            .font(.headline)
            .foregroundColor(.white)

          Text(formatSeconds(context.state.remainingSeconds))
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .foregroundColor(.white)

          ProgressView(value: context.state.progress)
            .tint(context.state.phaseLabel.uppercased() == "REST" ? .red : .green)
        }
        .padding()
      }
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.center) {
          VStack(spacing: 6) {
            Text(context.state.phaseLabel.uppercased())
              .font(.headline)
              .foregroundColor(context.state.phaseLabel.uppercased() == "REST" ? .red : .green)

            Text(formatSeconds(context.state.remainingSeconds))
              .font(.title2.bold())
              .foregroundColor(.white)
          }
        }
      } compactLeading: {
        Text(context.state.phaseLabel.prefix(1))
          .foregroundColor(.white)
      } compactTrailing: {
        Text(formatSeconds(context.state.remainingSeconds))
          .foregroundColor(.white)
      } minimal: {
        Text(context.state.phaseLabel.prefix(1))
          .foregroundColor(.white)
      }
    }
  }

  private func formatSeconds(_ value: Int) -> String {
    let minutes = value / 60
    let seconds = value % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}

@available(iOS 16.1, *)
@main
struct HIITLiveActivityBundle: WidgetBundle {
  var body: some Widget {
    HIITLiveActivityWidget()
  }
}
