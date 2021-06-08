import 'package:hive/hive.dart';
import 'package:practice/Module/member.dart';

class SearchGithubState {
  var listUser = <Member>[];

  SearchGithubState(this.listUser);
}

class FavoriteState {
  Box<Member> box;
  FavoriteState(this.box);
}

class Loading extends SearchGithubState {
  Loading({List<Member> listUser}) : super(listUser);
}

class Error extends SearchGithubState {
  Error({List<Member> listUser}) : super(listUser);

}