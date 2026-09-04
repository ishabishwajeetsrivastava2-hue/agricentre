import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  bool _transportActive = false;
  bool _sensorConnected = true;

  String _origin = 'Farm';
  String _destination = 'Collection Centre';

  double _temperature = 24.2;
  double _humidity = 62.0;
  double _shock = 0.7;

  double _transportProgress = 0.0;

  final List<String> _alerts = [];

  bool get _temperatureNormal =>
      _temperature >= 15 && _temperature <= 27;

  bool get _humidityNormal =>
      _humidity >= 40 && _humidity <= 70;

  bool get _shockNormal => _shock <= 3;

  bool get _allConditionsNormal =>
      _temperatureNormal &&
      _humidityNormal &&
      _shockNormal &&
      _sensorConnected;

  void _startTransport() {
    setState(() {
      _transportActive = true;
      _transportProgress = 0.15;
      _alerts.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transportation monitoring started.'),
      ),
    );
  }

  void _stopTransport() {
    setState(() {
      _transportActive = false;
      _transportProgress = 1.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transportation completed.'),
      ),
    );
  }

  void _simulateLiveUpdate() {
    if (!_transportActive || !_sensorConnected) {
      return;
    }

    setState(() {
      _temperature = 18 + ((_temperature + 2.3) % 10);
      _humidity = 45 + ((_humidity + 5) % 30);
      _shock = 0.4 + ((_shock + 0.8) % 4.5);

      _transportProgress += 0.08;

      if (_transportProgress >= 1.0) {
        _transportProgress = 1.0;
        _transportActive = false;
      }

      _updateAlerts();
    });
  }

  void _updateAlerts() {
    _alerts.clear();

    if (!_sensorConnected) {
      _alerts.add('IoT sensor disconnected.');
    }

    if (!_temperatureNormal) {
      _alerts.add(
        'Temperature is outside the recommended range.',
      );
    }

    if (!_humidityNormal) {
      _alerts.add(
        'Humidity is outside the recommended range.',
      );
    }

    if (!_shockNormal) {
      _alerts.add(
        'High shock/vibration detected.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.transportMonitoring,
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
            _buildTransportStatusCard(),

            const SizedBox(height: 20),

            _buildRouteCard(),

            const SizedBox(height: 20),

            _buildSensorStatusCard(),

            const SizedBox(height: 20),

            const Text(
              'Real-Time Monitoring',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            _buildSensorGrid(),

            const SizedBox(height: 20),

            _buildTransportProgress(),

            const SizedBox(height: 20),

            _buildSafetyStatus(),

            const SizedBox(height: 20),

            if (_alerts.isNotEmpty) _buildAlerts(),

            const SizedBox(height: 20),

            _buildSimulationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _transportActive
            ? const Color(0xFFE9F8ED)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _transportActive
              ? AppColors.success
              : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _transportActive
                      ? AppColors.success
                      : AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.local_shipping_rounded,
                  color: _transportActive
                      ? Colors.white
                      : AppColors.primaryGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      _transportActive
                          ? 'Transportation Active'
                          : 'Transportation Inactive',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _transportActive
                          ? 'Your produce is being monitored in real time.'
                          : 'Start transportation to begin monitoring.',
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

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  _transportActive ? _stopTransport : _startTransport,
              icon: Icon(
                _transportActive
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outline,
              ),
              label: Text(
                _transportActive
                    ? 'Complete Transportation'
                    : AppStrings.startTransport,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _transportActive
                    ? AppColors.danger
                    : AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transportation Route',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _origin,
              decoration: const InputDecoration(
                labelText: AppStrings.origin,
                prefixIcon: Icon(
                  Icons.trip_origin_rounded,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Farm',
                  child: Text('Farm'),
                ),
                DropdownMenuItem(
                  value: 'Warehouse',
                  child: Text('Warehouse'),
                ),
                DropdownMenuItem(
                  value: 'Cold Storage',
                  child: Text('Cold Storage'),
                ),
              ],
              onChanged: _transportActive
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _origin = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 16),

            const Center(
              child: Icon(
                Icons.arrow_downward_rounded,
                color: AppColors.primaryGreen,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _destination,
              decoration: const InputDecoration(
                labelText: AppStrings.destination,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Collection Centre',
                  child: Text('Collection Centre'),
                ),
                DropdownMenuItem(
                  value: 'Warehouse',
                  child: Text('Warehouse'),
                ),
                DropdownMenuItem(
                  value: 'Cold Storage',
                  child: Text('Cold Storage'),
                ),
                DropdownMenuItem(
                  value: 'Market',
                  child: Text('Market'),
                ),
              ],
              onChanged: _transportActive
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _destination = value;
                        });
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _sensorConnected
            ? const Color(0xFFE9F8ED)
            : const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _sensorConnected
              ? AppColors.success
              : AppColors.danger,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _sensorConnected
                  ? AppColors.success
                  : AppColors.danger,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _sensorConnected
                  ? Icons.sensors_rounded
                  : Icons.sensors_off_rounded,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _sensorConnected
                      ? 'IoT Sensor Connected'
                      : 'IoT Sensor Disconnected',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _sensorConnected
                      ? 'Real-time sensor data is being received.'
                      : 'Monitoring data is currently unavailable.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: _sensorConnected,
            activeColor: AppColors.primaryGreen,
            onChanged: (value) {
              setState(() {
                _sensorConnected = value;
                _updateAlerts();
              });
            },
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
      childAspectRatio: 1.22,
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
          icon: Icons.location_on_rounded,
          title: AppStrings.location,
          value: 'Live',
          status: 'GPS Active',
          statusColor: AppColors.info,
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
      padding: const EdgeInsets.all(15),
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
            size: 27,
            color: AppColors.primaryGreen,
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 3),

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

  Widget _buildTransportProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Transport Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${(_transportProgress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            LinearProgressIndicator(
              value: _transportProgress,
              minHeight: 9,
              borderRadius:
                  BorderRadius.circular(10),
              backgroundColor:
                  AppColors.surfaceSecondary,
              color: AppColors.primaryGreen,
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _origin,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _destination,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _allConditionsNormal
            ? const Color(0xFFE9F8ED)
            : const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _allConditionsNormal
              ? AppColors.success
              : AppColors.warning,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _allConditionsNormal
                ? Icons.verified_rounded
                : Icons.warning_amber_rounded,
            color: _allConditionsNormal
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
                  _allConditionsNormal
                      ? 'Produce Safety: Good'
                      : 'Produce Safety: Attention Required',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _allConditionsNormal
                      ? 'Current transportation conditions are within safe limits.'
                      : 'One or more monitored conditions need attention.',
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

  Widget _buildAlerts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.danger,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.danger,
              ),
              const SizedBox(width: 10),
              const Text(
                'Transport Alerts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ..._alerts.map(
            (alert) => Padding(
              padding:
                  const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      alert,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed:
            _transportActive && _sensorConnected
                ? _simulateLiveUpdate
                : null,
        icon: const Icon(
          Icons.refresh_rounded,
        ),
        label: const Text(
          'Simulate Live Sensor Update',
        ),
      ),
    );
  }
}