// lib/models/printer.dart

class PrinterModel {
  final String name;
  final String ip;
  final bool isSelected;

  PrinterModel({required this.name, required this.ip, this.isSelected = false});

  factory PrinterModel.fromMap(Map<String, dynamic> map) {
    return PrinterModel(
      name: map['name'],
      ip: map['ip'],
      isSelected: map['isSelected'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ip': ip, 'isSelected': isSelected ? 1 : 0};
  }

  PrinterModel copyWith({String? name, String? ip, bool? isSelected}) {
    return PrinterModel(
      name: name ?? this.name,
      ip: ip ?? this.ip,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
