import 'package:health/health.dart';

class HealthKitService {
  final HealthFactory _health = HealthFactory();

  /// Requests permissions and saves the completed HIIT session.
  Future<bool> saveWorkoutSession({
    required DateTime startTime,
    required DateTime endTime,
    required int caloriesBurned,
  }) async {
    final types = [
      HealthDataType.WORKOUT,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    final permissions = [
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
      HealthDataAccess.WRITE,
    ];

    final requested = await _health.requestAuthorization(
      types,
      permissions: permissions,
    );

    if (!requested) return false;

    return _health.writeWorkoutData(
      HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING,
      startTime,
      endTime,
      totalEnergyBurned: caloriesBurned,
      totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
    );
  }
}