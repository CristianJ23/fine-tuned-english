import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String? groupValue;
  final ValueChanged<String?>? onChanged;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: groupValue == value
              ? const Color(0xFFF48FB1)
              : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => onChanged?.call(value),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color(0xFFF48FB1),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.credit_card, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
