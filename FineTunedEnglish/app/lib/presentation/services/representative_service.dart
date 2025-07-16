import '../models/representative.dart';

class RepresentativeService {
  // Simula una llamada a una base de datos
  Future<Representative> getCurrentRepresentative() async {
    // await Future.delayed(const Duration(seconds: 1)); // Simula tiempo de espera
    return Representative(
      firstName: 'Cristian',
      lastName: 'Jiménez',
      email: 'cristian@example.com',
      idNumber: '1101234567',
      phone: '0987654321',
      educationLevel: 'Universitaria',
      birthDate: DateTime(1995, 8, 15),
    );
  }
}
