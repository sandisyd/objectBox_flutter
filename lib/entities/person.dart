import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  @Id()
  int? personId;

  @Unique()
  final String? nationalIdNumber;

  final String? name;

  final int? age;

  Person({this.personId, this.nationalIdNumber, this.name, this.age});
}
