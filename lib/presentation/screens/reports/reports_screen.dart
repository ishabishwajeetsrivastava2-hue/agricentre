import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<Map<String, String>> _reports = [
    {
      'title': 'Tomato Quality Report',
      'type': 'Quality',
      'score': '92/100',
      'status': 'Excellent',
      'date': '05 Sep 2026',
    },
    {
      'title': 'Transport Monitoring Report',
      'type': 'Transportation',
      'score': '88/100',
      'status': 'Good',
      'date': '04 Sep 2026',
    },
  ];

  void _generateReport() {
    setState(() {
      _reports.insert(
        0,
        {
          'title': 'New Produce Quality Report',
          'type': 'Quality',
          'score': '90/100',
          'status': 'Excellent',
          'date': '05 Sep 2026',
        },
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report generated successfully.'),
      ),
    );
  }

  void _showReportDetails(Map<String, String> report) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(report['title'] ?? 'Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                'Type',
                report['type'] ?? '-',
              ),
              _buildDetailRow(
                'Quality Score',
                report['score'] ?? '-',
              ),
              _buildDetailRow(
                'Status',
                report['status'] ?? '-',
              ),
              _buildDetailRow(
                'Date',
                report['date'] ?? '-',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(AppStrings.close),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.reports,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _reports.isEmpty
          ? _buildEmptyState()
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                100,
              ),
              children: [
                _buildSummaryCard(),

                const SizedBox(height: 24),

                const Text(
                  AppStrings.reportHistory,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 14),

                ..._reports.map(
                  (report) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: _buildReportCard(report),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateReport,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_chart_rounded),
        label: const Text(
          AppStrings.generateReport,
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.18,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.assessment_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agriculture Reports',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Review quality and transportation '
                  'monitoring records.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colors.white.withValues(
                      alpha: 0.9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    Map<String, String> report,
  ) {
    final status = report['status'] ?? '';

    final Color statusColor =
        status == 'Excellent' || status == 'Good'
            ? AppColors.success
            : AppColors.warning;

    return Card(
      child: InkWell(
        onTap: () => _showReportDetails(report),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F7E8),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: AppColors.primaryGreen,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          report['title'] ?? 'Report',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          report['date'] ?? '-',
                          style: const TextStyle(
                            fontSize: 12,
                            color:
                                AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () =>
                        _showReportDetails(report),
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 17,
                    ),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildReportInfo(
                      'Type',
                      report['type'] ?? '-',
                    ),
                  ),
                  Expanded(
                    child: _buildReportInfo(
                      'Score',
                      report['score'] ?? '-',
                    ),
                  ),
                  Expanded(
                    child: _buildReportInfo(
                      'Status',
                      status,
                      valueColor: statusColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Report download will be '
                              'available when storage is connected.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.download_outlined,
                      ),
                      label: const Text(
                        AppStrings.downloadReport,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Report sharing will be '
                            'available soon.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                    ),
                    tooltip: AppStrings.shareReport,
                    color: AppColors.primaryGreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportInfo(
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color:
                valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE2F7E8),
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.assessment_outlined,
                size: 48,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No reports available',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Generate a quality or transportation '
              'report to see it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateReport,
              icon: const Icon(
                Icons.add_chart_rounded,
              ),
              label: const Text(
                AppStrings.generateReport,
              ),
            ),
          ],
        ),
      ),
    );
  }
}