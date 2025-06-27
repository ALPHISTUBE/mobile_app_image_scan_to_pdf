class StudentInfo {
  String name;
  String roll;
  String batch;
  String subject;

  StudentInfo({
    this.name = '',
    this.roll = '',
    this.batch = '',
    this.subject = '',
  });

  static StudentInfo current = StudentInfo();
}
