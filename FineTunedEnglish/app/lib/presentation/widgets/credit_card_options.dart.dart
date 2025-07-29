import 'package:flutter/material.dart';

class CreditCardOption {
  final String title;
  final String subtitle;
  final String iconPath;
  final double minAmount;
  final double maxAmount;
  final String processingTime;
  final String value;

  CreditCardOption({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.minAmount,
    required this.maxAmount,
    required this.processingTime,
    required this.value,
  });
}

class CreditCardOptionsWidget extends StatefulWidget {
  final double totalAmount;
  final Function(String) onPaymentSelected;
  final Function() onCancel;

  const CreditCardOptionsWidget({
    Key? key,
    required this.totalAmount,
    required this.onPaymentSelected,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<CreditCardOptionsWidget> createState() => _CreditCardOptionsWidgetState();
}

class _CreditCardOptionsWidgetState extends State<CreditCardOptionsWidget> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedPaymentOption;

  final List<CreditCardOption> _paymentOptions = [
    CreditCardOption(
      title: 'Visa - Tarjetas Crédito y Débito',
      subtitle: 'Procesamiento seguro',
      iconPath: 'assets/icons/visa.png', // Necesitarás agregar estos iconos
      minAmount: 10,
      maxAmount: 5000,
      processingTime: 'Inmediato',
      value: 'visa',
    ),
    CreditCardOption(
      title: 'Mastercard - Tarjetas Crédito y Débito',
      subtitle: 'Procesamiento seguro',
      iconPath: 'assets/icons/mastercard.png',
      minAmount: 10,
      maxAmount: 5000,
      processingTime: 'Inmediato',
      value: 'mastercard',
    ),
    CreditCardOption(
      title: 'American Express',
      subtitle: 'Tarjetas de crédito',
      iconPath: 'assets/icons/amex.png',
      minAmount: 50,
      maxAmount: 10000,
      processingTime: 'Inmediato',
      value: 'amex',
    ),
    CreditCardOption(
      title: 'PayPhone - Tarjeta débito y crédito',
      subtitle: 'Sistema nacional',
      iconPath: 'assets/icons/payphone.png',
      minAmount: 1,
      maxAmount: 2500,
      processingTime: 'Inmediato',
      value: 'payphone',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.totalAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seleccionar método de pago',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Payment options list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentOptions.length,
              itemBuilder: (context, index) {
                final option = _paymentOptions[index];
                return _buildPaymentOptionCard(option);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionCard(CreditCardOption option) {
    final isSelected = _selectedPaymentOption == option.value;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Icon placeholder (reemplaza con Image.asset cuando tengas los iconos)
                Container(
                  width: 50,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getIconColor(option.value),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconData(option.value),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Min: \$${option.minAmount.toInt()} Max: \$${option.maxAmount.toInt()}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Tiempo de procesamiento: ${option.processingTime}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      enabled: false, // El monto está fijo para la inscripción
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        prefixText: '\$ ',
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPaymentOption = option.value;
                    });
                    widget.onPaymentSelected(option.value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28a745),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'PAGAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(String value) {
    switch (value) {
      case 'visa':
        return const Color(0xFF1A1F71);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return const Color(0xFF006FCF);
      case 'payphone':
        return const Color(0xFF00A651);
      default:
        return Colors.blue;
    }
  }

  IconData _getIconData(String value) {
    switch (value) {
      case 'visa':
      case 'mastercard':
      case 'amex':
        return Icons.credit_card;
      case 'payphone':
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }
}