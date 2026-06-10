class Employee {
  final int? id;
  final String fac;
  final String msnv;
  final String name;
  final String groupName;
  final String position;

  const Employee({
    this.id,
    required this.fac,
    required this.msnv,
    required this.name,
    required this.groupName,
    required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fac: json['fac'] ?? '',
      msnv: json['msnv'] ?? '',
      name: json['name'] ?? '',
      groupName: json['groupName'] ?? '',
      position: json['position'] ?? '',
    );
  }
}
