class StudentInfo {
  String name;
  String registrationId;
  String program;
  String batch;
  String roll;
  String courseName;

  StudentInfo({
    this.name = '',
    this.registrationId = '',
    this.program = '',
    this.batch = '',
    this.roll = '',
    this.courseName = '',
  });

  static StudentInfo current = StudentInfo();
}
