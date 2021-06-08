import 'dart:async';
import 'package:hive/hive.dart';
import 'package:practice/Bloc/Home/event.dart';
import 'package:practice/Bloc/Home/state.dart';
import 'package:practice/Module/member.dart';
import 'package:practice/Repo/repo.dart';

class SearchGithubBloc {
  // Nhan event tu UI
  final eventController = StreamController<Event>.broadcast();
  final eventControllerFavorite = StreamController<FavoriteEvent>.broadcast();

  // Truyen state den UI
  final stateController = StreamController<SearchGithubState>.broadcast();
  final stateControllerFavorite = StreamController<FavoriteState>.broadcast();

  SearchGithubBloc() {
    List<Member> members = [];
    int page = 1;
    stateController.add(SearchGithubState(members));
    eventController.stream.listen((Event event) async {
      if (event is SearchGithubEvent) {
        if(event.dataSearch.length == 0) {
          stateController.add(Error());
        } else {
          stateController.add(Loading());
          members = await NetWorkRepo().loadData(event.dataSearch, page);
          if(members.isEmpty) {
            stateController.add(Error());
          } else {
            stateController.add(SearchGithubState(members));
          }
        }
      } else if(event is LoadMore) {
        page += 1;
        List<Member> membersLoadMore = await NetWorkRepo().loadData(event.dataSearch, page);
        members.addAll(membersLoadMore);
        stateController.add(SearchGithubState(members));
      } else if(event is SetState) {
        stateController.add(SearchGithubState(members));
      }
    });

    eventControllerFavorite.stream.listen((FavoriteEvent event) async {
      Box<Member> box = Hive.box("favoriteBox");
      if (event is FavoriteEvent && event.member != null) {
        bool isAction = false;
        if (box.length == 0) {
          box.add(event.member);
        } else {
          for (int i = 0; i < box.length; i++) {
            if (box.getAt(i).login == event.member.login) {
              box.deleteAt(i);
              isAction = true;
              break;
            }
          }
          if (!isAction) {
            box.add(event.member);
          }
        }
      }
      stateControllerFavorite.add(FavoriteState(box));
    });
  }

  void dispose() {
    eventController.close();
    stateController.close();
    eventControllerFavorite.close();
    stateControllerFavorite.close();
    Hive.close();
  }
}
