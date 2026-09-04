import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  final List<Map<String, String>> _farms = [];

  void _showAddFarmDialog() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final areaController = TextEditingController();

    String selectedCrop = 'Rice';
    String selectedStage = 'Growing';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(AppStrings.addFarm),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.farmName,
                        hintText: 'e.g. Green Valley Farm',
                        prefixIcon: Icon(Icons.agriculture_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.farmLocation,
                        hintText: 'e.g. Kolkata, West Bengal',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: areaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: AppStrings.farmArea,
                        hintText: 'Area in acres',
                        prefixIcon: Icon(Icons.square_foot_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCrop,
                      decoration: const InputDecoration(
                        labelText: AppStrings.cropType,
                        prefixIcon: Icon(Icons.grass_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Rice',
                          child: Text('Rice'),
                        ),
                        DropdownMenuItem(
                          value: 'Wheat',
                          child: Text('Wheat'),
                        ),
                        DropdownMenuItem(
                          value: 'Potato',
                          child: Text('Potato'),
                        ),
                        DropdownMenuItem(
                          value: 'Tomato',
                          child: Text('Tomato'),
                        ),
                        DropdownMenuItem(
                          value: 'Vegetables',
                          child: Text('Vegetables'),
                        ),
                        DropdownMenuItem(
                          value: 'Other',
                          child: Text('Other'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedCrop = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedStage,
                      decoration: const InputDecoration(
                        labelText: AppStrings.cropStage,
                        prefixIcon: Icon(Icons.timeline_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Seedling',
                          child: Text('Seedling'),
                        ),
                        DropdownMenuItem(
                          value: 'Growing',
                          child: Text('Growing'),
                        ),
                        DropdownMenuItem(
                          value: 'Flowering',
                          child: Text('Flowering'),
                        ),
                        DropdownMenuItem(
                          value: 'Harvest Ready',
                          child: Text('Harvest Ready'),
                        ),
                        DropdownMenuItem(
                          value: 'Harvested',
                          child: Text('Harvested'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedStage = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(AppStrings.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        locationController.text.trim().isEmpty ||
                        areaController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all farm details.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _farms.add({
                        'name': nameController.text.trim(),
                        'location': locationController.text.trim(),
                        'area': areaController.text.trim(),
                        'crop': selectedCrop,
                        'stage': selectedStage,
                      });
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Farm added successfully.',
                        ),
                      ),
                    );
                  },
                  child: const Text(AppStrings.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.farms,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAddFarmDialog,
            icon: const Icon(Icons.add_rounded),
            tooltip: AppStrings.addFarm,
          ),
        ],
      ),
      body: _farms.isEmpty
          ? _buildEmptyState()
          : _buildFarmList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFarmDialog,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addFarm),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE2F7E8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.agriculture_rounded,
                size: 48,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No farms added yet',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add your first farm to start managing '
              'crops and monitoring agricultural activities.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showAddFarmDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text(AppStrings.addFarm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        Text(
          '${_farms.length} ${_farms.length == 1 ? 'Farm' : 'Farms'}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ..._farms.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final farm = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildFarmCard(
                farm,
                index,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFarmCard(
    Map<String, String> farm,
    int index,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F7E8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.agriculture_rounded,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farm['name'] ?? 'Farm',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              farm['location'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      setState(() {
                        _farms.removeAt(index);
                      });
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: AppColors.danger,
                          ),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildFarmInfo(
                    Icons.grass_outlined,
                    'Crop',
                    farm['crop'] ?? '-',
                  ),
                ),
                Expanded(
                  child: _buildFarmInfo(
                    Icons.square_foot_outlined,
                    'Area',
                    '${farm['area'] ?? '-'} acres',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildFarmInfo(
              Icons.timeline_outlined,
              'Crop Stage',
              farm['stage'] ?? '-',
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.quality,
                  arguments: farm,
                );
              },
              icon: const Icon(Icons.verified_outlined),
              label: const Text(
                AppStrings.startQualityCheck,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryGreen,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}