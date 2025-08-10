import 'package:flutter/material.dart';
import 'package:printapp/database/db_helper.dart';
import 'package:printapp/ui/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper.initDB()
      .then((_) {
        DBHelper.loadProductsIfFirstLaunch();
        print('Database initialized');
      })
      .catchError((error) {
        print('Error initializing database: $error');
      });
  runApp(const LabelPrinterApp());
}

class LabelPrinterApp extends StatelessWidget {
  const LabelPrinterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label Printer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
