class StudentInfo {
  static StudentInfo current = StudentInfo.empty();

  String name;
  String roll;
  String batch;
  String subject;

  StudentInfo({required this.name, required this.roll, required this.batch, required this.subject});

  factory StudentInfo.empty() => StudentInfo(name: '', roll: '', batch: '', subject: '');
}