import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedService = 'Quality Checking';

  final List<Map<String, String>> _transactions = [
    {
      'service': 'Quality Checking',
      'amount': '₹199',
      'status': 'Paid',
      'date': '05 Sep 2026',
    },
    {
      'service': 'Transport Monitoring',
      'amount': '₹299',
      'status': 'Paid',
      'date': '03 Sep 2026',
    },
  ];

  double get _serviceFee {
    switch (_selectedService) {
      case 'Transport Monitoring':
        return 299;
      case 'Quality + Transport':
        return 449;
      default:
        return 199;
    }
  }

  void _makePayment() {
    final amount = _serviceFee.toStringAsFixed(0);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service: $_selectedService',
              ),
              const SizedBox(height: 10),
              Text(
                'Amount: ₹$amount',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'This is a prototype payment flow. '
                'A real payment gateway can be connected later.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
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
                Navigator.pop(dialogContext);
                _completePayment();
              },
              child: const Text(AppStrings.payNow),
            ),
          ],
        );
      },
    );
  }

  void _completePayment() {
    final amount = _serviceFee.toStringAsFixed(0);

    setState(() {
      _transactions.insert(
        0,
        {
          'service': _selectedService,
          'amount': '₹$amount',
          'status': 'Paid',
          'date': '05 Sep 2026',
        },
      );
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 60,
          ),
          title: const Text(
            AppStrings.paymentSuccessful,
          ),
          content: Text(
            'Your payment of ₹$amount for '
            '$_selectedService was successful.',
            textAlign: TextAlign.center,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.payment,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          16,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildPaymentSummary(),

            const SizedBox(height: 24),

            const Text(
              'Select Service',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            _buildServiceSelector(),

            const SizedBox(height: 20),

            _buildPaymentBreakdown(),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _makePayment,
                icon: const Icon(
                  Icons.payment_rounded,
                ),
                label: const Text(
                  AppStrings.payNow,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              AppStrings.transactionHistory,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            ..._transactions.map(
              (transaction) =>
                  Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child:
                    _buildTransactionCard(
                  transaction,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color:
                  Colors.white.withValues(
                alpha: 0.18,
              ),
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
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
                  'AgriCentre Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Securely manage your '
                  'quality and monitoring service payments.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color:
                        Colors.white.withValues(
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

  Widget _buildServiceSelector() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(18),
        child:
            DropdownButtonFormField<String>(
          value: _selectedService,
          decoration:
              const InputDecoration(
            labelText: 'Service',
            prefixIcon: Icon(
              Icons.miscellaneous_services_outlined,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'Quality Checking',
              child: Text(
                'Quality Checking',
              ),
            ),
            DropdownMenuItem(
              value: 'Transport Monitoring',
              child: Text(
                'Transport Monitoring',
              ),
            ),
            DropdownMenuItem(
              value: 'Quality + Transport',
              child: Text(
                'Quality + Transport',
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedService = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildPaymentBreakdown() {
    final amount = _serviceFee;

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 18),

            _buildAmountRow(
              'Service',
              _selectedService,
              '₹${amount.toStringAsFixed(0)}',
            ),

            const SizedBox(height: 12),

            _buildAmountRow(
              'Platform Fee',
              '',
              '₹0',
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(
                vertical: 14,
              ),
              child: Divider(),
            ),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    AppStrings.totalAmount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String title,
    String subtitle,
    String amount,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color:
                      AppColors.textPrimary,
                ),
              ),
              if (subtitle.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 3,
                  ),
                  child: Text(
                    subtitle,
                    style:
                        const TextStyle(
                      fontSize: 11,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight:
                FontWeight.w600,
            color:
                AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(
    Map<String, String>
        transaction,
  ) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFE2F7E8),
                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color:
                    AppColors.primaryGreen,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction[
                            'service'] ??
                        'Service',
                    style:
                        const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    transaction[
                            'date'] ??
                        '-',
                    style:
                        const TextStyle(
                      fontSize: 11,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  transaction['amount'] ??
                      '₹0',
                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                    color: AppColors
                        .textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  transaction['status'] ??
                      '-',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}