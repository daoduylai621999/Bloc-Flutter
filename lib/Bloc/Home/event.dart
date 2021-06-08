import 'package:practice/Module/member.dart';

class Event {
  String dataSearch;
  
  Event(this.dataSearch);
}

class SearchGithubEvent extends Event {
  SearchGithubEvent(String dataSearch) : super(dataSearch);
}

class FavoriteEvent  extends Event{
  Member member;
  FavoriteEvent([this.member]) : super("");
}

class LoadMore extends Event {
  LoadMore(String dataSearch) : super(dataSearch);
}

class SetState extends Event {
  SetState({String dataSearch}) : super(dataSearch);
}