import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class QualityScreen extends StatefulWidget {
  const QualityScreen({super.key});

  @override
  State<QualityScreen> createState() => _QualityScreenState();
}

class _QualityScreenState extends State<QualityScreen> {
  String _selectedProduce = 'Tomato';

  bool _sensorConnected = true;
  bool _cameraChecked = false;
  bool _qualityGenerated = false;

  double _temperature = 24.5;
  double _humidity = 61.0;
  double _shock = 0.8;

  double get _qualityScore {
    double score = 100;

    // Temperature
    if (_temperature < 10 || _temperature > 30) {
      score -= 20;
    } else if (_temperature < 15 || _temperature > 27) {
      score -= 8;
    }

    // Humidity
    if (_humidity < 30 || _humidity > 80) {
      score -= 20;
    } else if (_humidity < 40 || _humidity > 70) {
      score -= 8;
    }

    // Shock / vibration
    if (_shock > 5) {
      score -= 20;
    } else if (_shock > 3) {
      score -= 10;
    }

    // Camera inspection
    if (!_cameraChecked) {
      score -= 5;
    }

    return score.clamp(0, 100);
  }

  String get _qualityStatus {
    if (_qualityScore >= 90) {
      return 'Excellent Quality';
    }

    if (_qualityScore >= 75) {
      return 'Good Quality';
    }

    if (_qualityScore >= 50) {
      return 'Needs Attention';
    }

    return 'Poor Quality';
  }

  Color get _qualityColor {
    if (_qualityScore >= 75) {
      return AppColors.success;
    }

    if (_qualityScore >= 50) {
      return AppColors.warning;
    }

    return AppColors.danger;
  }

  void _generateQualityReport() {
    setState(() {
      _qualityGenerated = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Quality report generated successfully.',
        ),
      ),
    );
  }

  void _simulateSensorUpdate() {
    setState(() {
      _temperature = 20 + (_temperature + 1.7) % 9;
      _humidity = 45 + (_humidity + 4) % 28;
      _shock = 0.5 + (_shock + 0.6) % 3.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.qualityChecking,
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
            _buildProduceSelector(),

            const SizedBox(height: 20),

            _buildSensorConnectionCard(),

            const SizedBox(height: 20),

            const Text(
              'Real-Time Sensor Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            _buildSensorGrid(),

            const SizedBox(height: 20),

            _buildCameraInspectionCard(),

            const SizedBox(height: 24),

            _buildQualityScoreCard(),

            const SizedBox(height: 20),

            if (_qualityGenerated) _buildQualityReport(),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateQualityReport,
                icon: const Icon(Icons.assessment_outlined),
                label: const Text(
                  'Generate Quality Report',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduceSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Produce',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedProduce,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Tomato',
                  child: Text('Tomato'),
                ),
                DropdownMenuItem(
                  value: 'Potato',
                  child: Text('Potato'),
                ),
                DropdownMenuItem(
                  value: 'Rice',
                  child: Text('Rice'),
                ),
                DropdownMenuItem(
                  value: 'Wheat',
                  child: Text('Wheat'),
                ),
                DropdownMenuItem(
                  value: 'Vegetables',
                  child: Text('Vegetables'),
                ),
                DropdownMenuItem(
                  value: 'Fruits',
                  child: Text('Fruits'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedProduce = value;
                    _qualityGenerated = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorConnectionCard() {
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      ? 'Receiving real-time environmental data'
                      : 'Connect a sensor to continue monitoring',
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
      childAspectRatio: 1.25,
      children: [
        _buildSensorCard(
          icon: Icons.thermostat_rounded,
          title: AppStrings.temperature,
          value: '${_temperature.toStringAsFixed(1)} °C',
          status: _temperature >= 15 && _temperature <= 27
              ? 'Normal'
              : 'Warning',
          statusColor: _temperature >= 15 && _temperature <= 27
              ? AppColors.success
              : AppColors.warning,
        ),
        _buildSensorCard(
          icon: Icons.water_drop_rounded,
          title: AppStrings.humidity,
          value: '${_humidity.toStringAsFixed(0)} %',
          status: _humidity >= 40 && _humidity <= 70
              ? 'Normal'
              : 'Warning',
          statusColor: _humidity >= 40 && _humidity <= 70
              ? AppColors.success
              : AppColors.warning,
        ),
        _buildSensorCard(
          icon: Icons.vibration_rounded,
          title: AppStrings.shock,
          value: '${_shock.toStringAsFixed(1)} g',
          status: _shock <= 3 ? 'Normal' : 'High',
          statusColor:
              _shock <= 3 ? AppColors.success : AppColors.danger,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 26,
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

  Widget _buildCameraInspectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F7E8),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Camera Inspection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Inspect visible defects and appearance',
                        style: TextStyle(
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
            Container(
              width: double.infinity,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: _cameraChecked
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Visual inspection completed',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_search_rounded,
                          color: AppColors.textSecondary,
                          size: 38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No image inspected yet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _cameraChecked = true;
                    _qualityGenerated = false;
                  });
                },
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(
                  _cameraChecked
                      ? 'Inspect Another Image'
                      : 'Start Camera Inspection',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityScoreCard() {
    final score = _qualityScore;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Text(
            AppStrings.qualityScore,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: AppColors.surfaceSecondary,
                    color: _qualityColor,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      score.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: _qualityColor,
                      ),
                    ),
                    const Text(
                      '/ 100',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _qualityStatus,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: _qualityColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Based on current sensor readings and inspection data',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _sensorConnected
                ? _simulateSensorUpdate
                : null,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Simulate Sensor Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityReport() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F8ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                color: AppColors.success,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Quality Report Ready',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Produce: $_selectedProduce',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Quality Score: ${_qualityScore.toStringAsFixed(0)}/100',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Status: $_qualityStatus',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}