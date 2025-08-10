import 'package:flutter/material.dart';

class PrinterStatusWidget extends StatelessWidget {
  final String status;

  const PrinterStatusWidget({super.key, required this.status});

  Color _getColor(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return Colors.green;
      case 'printing':
        return Colors.orange;
      case 'idle':
        return Colors.blueGrey;
      case 'error':
      case 'disconnected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return Icons.check_circle;
      case 'printing':
        return Icons.print;
      case 'idle':
        return Icons.pause_circle;
      case 'error':
      case 'disconnected':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getColor(status).withOpacity(0.1),
        border: Border.all(color: _getColor(status), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_getIcon(status), color: _getColor(status)),
          const SizedBox(width: 10),
          Text(
            'Printer Status: ${status.toUpperCase()}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getColor(status),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
