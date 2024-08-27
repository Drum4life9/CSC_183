import './appointment.dart';

void main() {
  Appointment a1 = Appointment(
      startTime: DateTime(2023, 3, 1), endTime: DateTime(2023, 3, 3, 4, 30));
  //Appointment a2 = Appointment( startTime: DateTime(2023, 3, 1), endTime: DateTime(2023, 2, 28)); //THIS CAUSES AN EXCEPTION

  print('Appointment1 startDate:');
  print(a1.getStartDateTime());
  print('\nAppointment1 endDate:');
  print(a1.getEndDateTime());
  print('\nDuration in hours and mins:');
  int hours = a1.getAppointmentTime().inHours;
  print('$hours hours');
  print('${a1.getAppointmentTime().inMinutes - hours * 60} minutes');

  print('\n\nCreating new object from file');
  //---------------------------------
  //todo change the year in app1.json to something after 2025
  //---------------------------------
  Appointment a2 = Appointment.fromFile(fileName: 'app1.json');
  print('\nAppointment2 startDate:');
  print(a2.getStartDateTime());
  print('\nAppointment2 endDate:');
  print(a2.getEndDateTime());
  print('\nDuration in hours and mins:');
  int hours2 = a2.getAppointmentTime().inHours;
  print('$hours2 hours');
  print('${a2.getAppointmentTime().inMinutes - hours2 * 60} minutes');
  print('Appointment2 location:');
  print(a2.getLocation());
  print('Appointment2 Description (none in the json file)');
  print(a2.getDescription());

  Appointment a3 = Appointment.defaultApp();
  print('\n\nDefault Appointment startDate:');
  print(a3.getStartDateTime());
  print('\nDefault Appointment endDate:');
  print(a3.getEndDateTime());
  print('\nDuration in hours and mins:');
  int hours3 = a3.getAppointmentTime().inHours;
  print('$hours3 hours');
  print('${a3.getAppointmentTime().inMinutes - hours3 * 60} minutes');
}
