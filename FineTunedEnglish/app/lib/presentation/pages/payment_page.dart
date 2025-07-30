import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // <-- IMPORT
import 'credit_card_form_page.dart';
import 'schedule_page.dart';
import 'representative_est_info.dart';
import 'confirmation_page.dart';
import 'transfer_code_page.dart';
import '../models/usuarios.dart';
import '../services/auth_service.dart';
import '../services/inscription_service.dart';
import '../widgets/shared_footer.dart';

enum FormCompletion { schedule, representative }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final InscriptionService _inscriptionService = InscriptionService();
  String? _selectedPaymentMethod;
  Map<String, dynamic>? _selectedScheduleData;
  bool _isLoading = false;
  bool _cardDetailsProvided = false; 
  bool _transferCodeConfirmed = false;

  final ValueNotifier<Set<FormCompletion>> _completionState = ValueNotifier({});

  void _navigateToSchedulePage() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const SchedulePage()),
    );
    if (result != null && mounted) {
      _selectedScheduleData = result;
      final newState = Set<FormCompletion>.from(_completionState.value);
      newState.add(FormCompletion.schedule);
      _completionState.value = newState;
      setState(() {});
    }
  }

  void _navigateToRepresentativePage() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const RepresentativeFormPage()),
    );
    if (result == true && mounted) {
      final newState = Set<FormCompletion>.from(_completionState.value);
      newState.add(FormCompletion.representative);
      _completionState.value = newState;
      setState(() {}); 
    }
  }
  
  void _navigateToCreditCardForm() async {
    final bool prerequisitesMet = _completionState.value.contains(FormCompletion.schedule) &&
                                 _completionState.value.contains(FormCompletion.representative);

    if (prerequisitesMet) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => CreditCardFormPage(scheduleData: _selectedScheduleData!)),
      );

      if (result == true && mounted) {
        setState(() {
          _cardDetailsProvided = true; 
          _selectedPaymentMethod = 'card';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          // <-- CORRECCIÓN
          SnackBar(content: Text("pages.creditCard.cardInfoSaved".tr()), backgroundColor: Colors.blueAccent)
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        // <-- CORRECCIÓN
        SnackBar(
          content: Text("pages.payment.completePrerequisites".tr()),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }
  
  void _navigateToTransferCodePage() async {
    final bool prerequisitesMet = _completionState.value.contains(FormCompletion.schedule) &&
                                 _completionState.value.contains(FormCompletion.representative);

    if (prerequisitesMet) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => const TransferCodePage()),
      );

      if (result == true && mounted) {
        setState(() {
          _transferCodeConfirmed = true;
          _selectedPaymentMethod = 'transfer';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          // <-- CORRECCIÓN
          SnackBar(
            content: Text("pages.payment.transferCodeConfirmed".tr()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        // <-- CORRECCIÓN
        SnackBar(
          content: Text("pages.payment.completePrerequisites".tr()),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }
  
  Future<void> _processPaymentAndInscription() async {
    if (_isLoading) return;
    setState(() { _isLoading = true; });

    final Usuarios currentUser = AuthService.currentUser!;
    
    final error = await _inscriptionService.createInscription(
      studentId: currentUser.id,
      subLevelId: _selectedScheduleData!['id'],
      levelId: _selectedScheduleData!['levelId'],
      costPaid: _selectedScheduleData!['cost'],
    );
    
    if (mounted) {
      if (error == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConfirmationPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
      }
    }
    
    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _completionState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF213354),
        // <-- CORRECCIÓN
        title: Text('pages.payment.title'.tr(), style: const TextStyle(color: Colors.white, fontSize: 24)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [ IconButton(icon: const Icon(Icons.home_outlined, size: 28), onPressed: () => Navigator.of(context).pop()) ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRepresentativeButton(),
            const SizedBox(height: 20),
            if (_selectedScheduleData == null) _buildCourseSelectionCard() else _buildSelectedScheduleInfo(),
            const SizedBox(height: 20),
            
            if (_selectedScheduleData != null) ...[
              _buildTotalCostCard(),
              const SizedBox(height: 30),
              // <-- CORRECCIÓN
              Text('pages.payment.paymentMethod'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // <-- CORRECCIÓN
              _buildPaymentOption(title: 'pages.payment.creditDebitCard'.tr(), subtitle: 'Visa, Mastercard', value: 'card'),
              const SizedBox(height: 12),
              _buildPaymentOption(title: 'pages.payment.bankTransfer'.tr(), subtitle: 'Pichincha, Banco de Loja', value: 'transfer'),
            ]
            else ...[
              const SizedBox(height: 40),
              // <-- CORRECCIÓN
              Center(child: Text("pages.payment.chooseScheduleToSeeMethods".tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildPaymentFooter(),
    );
  }
  
  Widget _buildPaymentOption({required String title, required String subtitle, required String value}) {
    return GestureDetector(
      onTap: () {
        if (value == 'card') {
          _navigateToCreditCardForm();
        } else if (value == 'transfer') {
          _navigateToTransferCodePage();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _selectedPaymentMethod == value ? Colors.blue.withOpacity(0.1) : Colors.white, 
          borderRadius: BorderRadius.circular(12), 
          border: Border.all(
            color: _selectedPaymentMethod == value ? Colors.blue : Colors.grey.shade300, 
            width: 1.5
          )
        ),
        child: Row(children: [
          Radio<String>(
            value: value, 
            groupValue: _selectedPaymentMethod, 
            onChanged: (String? newValue) {
              if (newValue != null) {
                if (newValue == 'card') {
                  _navigateToCreditCardForm();
                } else if (newValue == 'transfer') {
                  _navigateToTransferCodePage();
                }
              }
            }
          ),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
            Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          ])),
          const SizedBox(width: 12),
          if (value == 'card' && _cardDetailsProvided)
            const Icon(Icons.check_circle, color: Colors.blueAccent)
          else if (value == 'transfer' && _transferCodeConfirmed)
            const Icon(Icons.check_circle, color: Colors.green)
          else if (value == 'card')
            Icon(Icons.credit_card, color: Colors.grey[400])
          else if (value == 'transfer')
            Icon(Icons.account_balance, color: Colors.grey[400]),
        ]),
      ),
    );
  }
  
  Widget _buildPaymentFooter() {
    final bool prerequisitesMet = _completionState.value.contains(FormCompletion.schedule) &&
                                _completionState.value.contains(FormCompletion.representative);

    bool canPay = false;
    if (prerequisitesMet) {
      if (_selectedPaymentMethod == 'transfer' && _transferCodeConfirmed) {
        canPay = true;
      }
      else if (_selectedPaymentMethod == 'card' && _cardDetailsProvided) {
        canPay = true;
      }
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
           color: Colors.grey[100],
           child: ElevatedButton(
            onPressed: canPay && !_isLoading ? _processPaymentAndInscription : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canPay ? Colors.pink : Colors.grey,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 55),
            ),
            child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white) 
              // <-- CORRECCIÓN
              : Text('pages.payment.makePaymentWithAmount'.tr(namedArgs: {'amount': _selectedScheduleData?['cost']?.toStringAsFixed(2) ?? '0.00'}), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SharedFooter(),
      ],
    );
  }

  Widget _buildRepresentativeButton() {
    return ValueListenableBuilder<Set<FormCompletion>>(
      valueListenable: _completionState,
      builder: (context, completedForms, child) => Column(
        children: [
          ElevatedButton(
            onPressed: _navigateToRepresentativePage,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24)),
            // <-- CORRECCIÓN
            child: Text('pages.payment.representativeData'.tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          if (completedForms.contains(FormCompletion.representative))
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 4),
                // <-- CORRECCIÓN
                Text("pages.payment.dataSavedSuccessfully".tr(), style: const TextStyle(color: Colors.green)),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseSelectionCard() {
    return GestureDetector(
      onTap: _navigateToSchedulePage,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.withOpacity(0.5))),
        child: Column(children: [
          Row(children: [
            Icon(Icons.info, color: Colors.amber[800], size: 30),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // <-- CORRECCIÓN
              Text('pages.payment.selectCourseTitle'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.amber[900])),
              const SizedBox(height: 4),
              // <-- CORRECCIÓN
              Text('pages.payment.selectScheduleForInscription'.tr(), style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ])),
          ]),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _navigateToSchedulePage,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), minimumSize: const Size(double.infinity, 50)),
            // <-- CORRECCIÓN
            child: Text('pages.payment.chooseSchedule'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          )
        ]),
      ),
    );
  }
  
  Widget _buildSelectedScheduleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          // <-- CORRECCIÓN
          Text('pages.payment.scheduleSelected'.tr(), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)
        ]),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF213354), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_selectedScheduleData!['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('${_selectedScheduleData!['days']!} - ${_selectedScheduleData!['hours']!}', style: TextStyle(color: Colors.white.withOpacity(0.8))),
              ]),
            ),
            OutlinedButton(
              onPressed: _navigateToSchedulePage, 
              style: OutlinedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              // <-- CORRECCIÓN 
              child: Text('common.change'.tr(), style: const TextStyle(color: Colors.black))
            )
          ]),
        ),
      ],
    );
  }
  
  Widget _buildTotalCostCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // <-- CORRECCIÓN
            Text('pages.payment.totalCost'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('\$${_selectedScheduleData!['cost']?.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: '5-months', 
          items: [
            // <-- CORRECCIÓN
            DropdownMenuItem(value: '5-months', child: Text('pages.payment.deferred5Months'.tr()))
          ], 
          onChanged: (v){}, 
          decoration: InputDecoration(
            filled: true, 
            fillColor: Colors.white, 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), 
            contentPadding: const EdgeInsets.symmetric(horizontal: 12)
          )
        )
      ]),
    );
  }
}