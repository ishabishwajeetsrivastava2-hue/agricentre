import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  Timer? _timer;

  bool _monitoringActive = true;
  bool _sensorConnected = true;

  double _temperature = 24.5;
  double _humidity = 61.0;
  double _shock = 0.8;

  int _updateCount = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (_monitoringActive && _sensorConnected) {
          _updateSensorData();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _temperatureNormal =>
      _temperature >= 15 && _temperature <= 27;

  bool get _humidityNormal =>
      _humidity >= 40 && _humidity <= 70;

  bool get _shockNormal => _shock <= 3;

  bool get _systemHealthy =>
      _sensorConnected &&
      _temperatureNormal &&
      _humidityNormal &&
      _shockNormal;

  void _updateSensorData() {
    setState(() {
      _temperature = 20 + ((_temperature + 1.8) % 8);
      _humidity = 45 + ((_humidity + 3.5) % 25);
      _shock = 0.4 + ((_shock + 0.7) % 3.2);

      _updateCount++;
    });
  }

  void _toggleMonitoring(bool value) {
    setState(() {
      _monitoringActive = value;
    });
  }

  void _toggleSensor(bool value) {
    setState(() {
      _sensorConnected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.liveMonitoring,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonitoringStatus(),

            const SizedBox(height: 20),

            _buildSystemHealth(),

            const SizedBox(height: 24),

            const Text(
              'Live Sensor Data',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            _buildSensorGrid(),

            const SizedBox(height: 24),

            _buildLocationCard(),

            const SizedBox(height: 24),

            _buildAlertsSection(),

            const SizedBox(height: 24),

            _buildSensorControls(),

            const SizedBox(height: 20),

            _buildUpdateInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _monitoringActive
            ? AppColors.primaryGreen
            : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _monitoringActive
              ? AppColors.primaryGreen
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _monitoringActive
                  ? Colors.white.withValues(alpha: 0.18)
                  : AppColors.surfaceSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _monitoringActive
                  ? Icons.monitor_heart_rounded
                  : Icons.monitor_heart_outlined,
              color: _monitoringActive
                  ? Colors.white
                  : AppColors.primaryGreen,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _monitoringActive
                      ? 'Live Monitoring Active'
                      : 'Monitoring Paused',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _monitoringActive
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _monitoringActive
                      ? 'Sensor data is being updated automatically.'
                      : 'Turn on monitoring to receive live data.',
                  style: TextStyle(
                    fontSize: 12,
                    color: _monitoringActive
                        ? Colors.white.withValues(alpha: 0.9)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: _monitoringActive,
            activeColor: Colors.white,
            activeTrackColor: AppColors.darkGreen,
            onChanged: _toggleMonitoring,
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealth() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _systemHealthy
            ? const Color(0xFFE9F8ED)
            : const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _systemHealthy
              ? AppColors.success
              : AppColors.warning,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _systemHealthy
                ? Icons.check_circle_rounded
                : Icons.warning_amber_rounded,
            color: _systemHealthy
                ? AppColors.success
                : AppColors.warning,
            size: 32,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _systemHealthy
                      ? 'All Systems Normal'
                      : 'Attention Required',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _systemHealthy
                      ? 'Current environmental conditions are within safe limits.'
                      : 'One or more monitored parameters are outside the safe range.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      children: [
        _buildSensorCard(
          icon: Icons.thermostat_rounded,
          title: AppStrings.temperature,
          value:
              '${_temperature.toStringAsFixed(1)} °C',
          status:
              _temperatureNormal ? 'Normal' : 'Warning',
          statusColor:
              _temperatureNormal
                  ? AppColors.success
                  : AppColors.warning,
        ),

        _buildSensorCard(
          icon: Icons.water_drop_rounded,
          title: AppStrings.humidity,
          value:
              '${_humidity.toStringAsFixed(0)} %',
          status:
              _humidityNormal ? 'Normal' : 'Warning',
          statusColor:
              _humidityNormal
                  ? AppColors.success
                  : AppColors.warning,
        ),

        _buildSensorCard(
          icon: Icons.vibration_rounded,
          title: AppStrings.shock,
          value:
              '${_shock.toStringAsFixed(1)} g',
          status:
              _shockNormal ? 'Normal' : 'High',
          statusColor:
              _shockNormal
                  ? AppColors.success
                  : AppColors.danger,
        ),

        _buildSensorCard(
          icon: Icons.sensors_rounded,
          title: 'Sensor',
          value: _sensorConnected
              ? 'Online'
              : 'Offline',
          status: _sensorConnected
              ? 'Connected'
              : 'Disconnected',
          statusColor: _sensorConnected
              ? AppColors.success
              : AppColors.danger,
        ),
      ],
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 28,
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F7E8),
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primaryGreen,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'GPS location is being monitored',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.gps_fixed_rounded,
                  color: AppColors.info,
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: AppColors.info,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Live GPS tracking enabled',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    final alerts = <String>[];

    if (!_sensorConnected) {
      alerts.add('IoT sensor connection lost.');
    }

    if (!_temperatureNormal) {
      alerts.add('Temperature is outside the safe range.');
    }

    if (!_humidityNormal) {
      alerts.add('Humidity is outside the safe range.');
    }

    if (!_shockNormal) {
      alerts.add('High shock/vibration detected.');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 10),
                const Text(
                  AppStrings.alerts,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (alerts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F8ED),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppStrings.noAlerts,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...alerts.map(
                (alert) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 20,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            alert,
                            style: const TextStyle(
                              fontSize: 13,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Monitoring Controls',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.sensors_rounded,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'IoT Sensor Connection',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Switch(
                  value: _sensorConnected,
                  activeColor:
                      AppColors.primaryGreen,
                  onChanged: _toggleSensor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateInfo() {
    return Center(
      child: Text(
        _monitoringActive && _sensorConnected
            ? 'Live updates received: $_updateCount'
            : 'Live updates paused',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}