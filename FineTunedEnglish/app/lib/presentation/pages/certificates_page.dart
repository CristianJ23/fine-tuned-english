import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  bool isLoading = false;
  String studentName = "Juan Pérez";

  Future<void> _generateAndPrintPdf() async {
    setState(() => isLoading = true);

    try {
      // Cargar imagen de fondo del certificado
      final imageBytes = await rootBundle.load('assets/certificates/img.png'); // Usa una imagen del certificado
      final background = pw.MemoryImage(imageBytes.buffer.asUint8List());

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Stack(
              children: [
                pw.Positioned.fill(
                  child: pw.Image(background, fit: pw.BoxFit.cover),
                ),
                pw.Positioned(
                  left: 150,
                  top: 400,
                  child: pw.Text(
                    studentName,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (_) => pdf.save());
    } catch (e) {
      debugPrint('Error generando el PDF: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificado')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _generateAndPrintPdf,
          child: const Text('Generar PDF con nombre'),
        ),
      ),
    );
  }
}
