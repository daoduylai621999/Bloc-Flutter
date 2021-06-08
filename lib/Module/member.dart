import 'package:hive/hive.dart';
part 'member.g.dart';

@HiveType(typeId: 0)
class Member {
  @HiveField(0)
  final String login;

  @HiveField(1)
  final String avatarUrl;

  Member(this.login, this.avatarUrl);
}