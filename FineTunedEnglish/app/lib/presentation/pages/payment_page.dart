import 'package:flutter/material.dart';
import '../models/inscription.dart';
import '../widgets/shared_footer.dart';
import 'representative_est_info.dart';
// Import the EnglishLevelDetailScreen and SubLevel model
import '../pages/EnglishLevelDetailScreen.dart'; // Make sure this path is correct
import '../models/sub_level.dart'; // Make sure this path is correct
import '../pages/confirmation_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  // Change _selectedSchedule to hold a SubLevel object
  SubLevel? _selectedSubLevel;

  // Modify this to navigate to EnglishLevelDetailScreen
  void _navigateToEnglishLevelDetailScreen() async {
    // You need a way to get the 'levelId' to show details of a specific English level.
    // For demonstration, I'll use a placeholder ID.
    // In a real app, you might pass this ID from a previous screen,
    // or fetch a list of English levels first.
    final String placeholderLevelId = 'gAAJZq7aO0AQFa2hhoXD'; // This ID comes from your image (Beginner a1)

    final result = await Navigator.push<SubLevel>( // Expecting a SubLevel object back
      context,
      MaterialPageRoute(
        builder: (context) => EnglishLevelDetailScreen(levelId: placeholderLevelId),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedSubLevel = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF213354),
        title: const Text('Pago', style: TextStyle(color: Colors.white, fontSize: 24)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, size: 28),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRepresentativeButton(),
            const SizedBox(height: 20),
            // Check for _selectedSubLevel instead of _selectedSchedule
            if (_selectedSubLevel == null)
              _buildCourseSelectionCard()
            else
              _buildSelectedScheduleInfo(),
            const SizedBox(height: 20),
            // Check for _selectedSubLevel
            if (_selectedSubLevel != null) ...[
              _buildTotalCostCard(),
              const SizedBox(height: 30),
            ],
            const Text('Método de Pago', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPaymentOption(
              title: 'Tarjeta de Crédito/Débito',
              subtitle: 'Visa, Mastercard',
              value: 'card',
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              title: 'Transferencia Bancaria',
              subtitle: 'Pichincha, Banco de Loja',
              value: 'transfer',
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildPaymentFooter(),
    );
  }

  Widget _buildRepresentativeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RepresentativeFormPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          child: const Text('Datos del Representante', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildCourseSelectionCard() {
    return GestureDetector(
      // Change onTap to the new navigation method
      onTap: _navigateToEnglishLevelDetailScreen,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.amber[800], size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¡Selecciona un Curso!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.amber[900])),
                      const SizedBox(height: 4),
                      const Text('Debe seleccionar un horario para la inscripción.', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // Change onPressed to the new navigation method
              onPressed: _navigateToEnglishLevelDetailScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Elegir un Horario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedScheduleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.grey),
            SizedBox(width: 8),
            Text('Horario Seleccionado', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF213354),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.red.shade400, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Access properties directly from _selectedSubLevel
                    Text(_selectedSubLevel!.name, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('${_selectedSubLevel!.dias} - ${_selectedSubLevel!.horas}', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  ],
                ),
              ),
              OutlinedButton(
                // Change onPressed to the new navigation method
                onPressed: _navigateToEnglishLevelDetailScreen,
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Cambiar', style: TextStyle(color: Colors.black)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCostCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Costo Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Access cost directly from _selectedSubLevel
              Text('\$${_selectedSubLevel!.costo.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: '5-months',
            items: const [DropdownMenuItem(value: '5-months', child: Text('Diferido 5 meses - \$50.00/mes'))],
            onChanged: (value) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          color: Colors.grey[100],
          child: ElevatedButton(
            // Use _selectedSubLevel to determine if button is enabled
            onPressed: _selectedSubLevel == null ? null : () {
              // Create Inscription using data from _selectedSubLevel
              final inscription = Inscription(
                id: 'tmp_${DateTime.now().millisecondsSinceEpoch}',
                estudianteId: 'est123',    // <- Pass the real student ID
                subNivelId: _selectedSubLevel!.id,       // <- Use the sub-level ID
                nivelInglesId: 'gAAJZq7aO0AQFa2hhoXD',    // <- Assuming this is the parent English level ID
                fechaInscripcion: DateTime.now(),
                estado: 'pendiente',
                notaFinal: null,
                costoPagado: _selectedSubLevel!.costo,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmationPage(inscription: inscription),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 55),
            ),
            // Display cost from _selectedSubLevel
            child: Text('Realizar Pago - \$${_selectedSubLevel?.costo.toStringAsFixed(2) ?? '0.00'}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SharedFooter(),
      ],
    );
  }

  Widget _buildHeaderText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estas a un solo paso de ser parte de nosotros',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          'Completa el siguiente paso:',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({required String title, required String subtitle, required String value}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.credit_card, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}