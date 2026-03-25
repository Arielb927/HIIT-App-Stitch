class HealthKitService {
  /// Placeholder implementation for CI/no-device environments.
  ///
  /// This keeps session-stop flow non-blocking while iOS Health API
  /// integration is finalized against the exact package version in use.
  Future<bool> saveWorkoutSession({
    required DateTime startTime,
    required DateTime endTime,
    required int caloriesBurned,
  }) async {
    return false;
  }
}