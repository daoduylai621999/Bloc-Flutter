import 'package:flutter/material.dart';
import 'package:practice/Bloc/Home/bloc.dart';
import 'package:practice/Bloc/Home/event.dart';
import 'package:practice/Bloc/Home/state.dart';
import 'package:practice/Page/Detail/detail.dart';
import 'package:practice/Page/Home/form_search.dart';
import 'package:practice/Page/favorite.dart';
import 'package:practice/Module/member.dart';
import '../../Module/member.dart';

class Practice extends StatefulWidget {
  @override
  createState() => PracticeState();
}


class PracticeState extends State<Practice> with TickerProviderStateMixin{
  final _biggerFont = const TextStyle(fontSize: 18.0);
  String dataSearch = "";
  final bloc = SearchGithubBloc();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Users Github"),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 30),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.redAccent.withOpacity(0.8),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Favorite(bloc: bloc)));
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          FormSearch(bloc: bloc, dataSearch: dataSearch,),
          listDataView(),
        ],
      ),
    );
  }

  Widget listDataView() {
    return Expanded(
      child: StreamBuilder<SearchGithubState>(
        stream: bloc.stateController.stream,
        builder: (BuildContext context, AsyncSnapshot<SearchGithubState> snapshot) {
          List<Member> members = snapshot.data?.listUser ?? [];
          if(snapshot.data is Loading) {
            return SizedBox(
              height: 70,
              width: 70,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          else if(snapshot.data is Error) return new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Container(
                margin: const EdgeInsets.only(top: 20),
                child: new Text(
                  "No has data",
                  style: TextStyle(fontSize: 18, color: Colors.green, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          );
          else return ListView.builder(
                itemCount: members.length,
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return _buildRow(members[index], index);
                });
        },
      ),
    );
  }

  //Build Row of List View
  Widget _buildRow(Member member, int index) {
    bloc.eventControllerFavorite.add(FavoriteEvent());
    var _isSaved = false;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 13),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 5),
          )
        ]
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: GestureDetector(
              child: new Container(
                padding: const EdgeInsets.all(8.0),
                child: new ListTile(
                  subtitle: new Text("Index: $index"),
                  title: new Text("${member.login}", style: _biggerFont),
                  leading: new CircleAvatar(backgroundImage: new NetworkImage(member.avatarUrl)),
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(member: member, index: index, bloc: bloc,)));
              },
            ),
            ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  )
                ),
              ),
              child: StreamBuilder<FavoriteState>(
                stream: bloc.stateControllerFavorite.stream,
                builder: (BuildContext context, AsyncSnapshot<FavoriteState> snapshot) {
                  if(snapshot.data != null) {
                    for(int i = 0; i < snapshot.data.box.length; i++) {
                      if(snapshot.data.box.getAt(i).login == member.login) {
                        _isSaved = true;
                        break;
                      }
                    }
                  }
                  return new IconButton(
                    onPressed: () {
                      showAlertDialog(context, member, _isSaved);
                    },
                    icon: new Icon(
                      _isSaved? Icons.favorite : Icons.favorite_border_outlined,
                      color: _isSaved? Colors.redAccent.withOpacity(0.8) : Colors.black54.withOpacity(0.7),
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _scrollListener() async{
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      bloc.eventController.sink.add(LoadMore(dataSearch));
    }
  }

  showAlertDialog(BuildContext context, Member member, bool isSaved) {
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: TextStyle(color: Colors.black54),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text(
          "Confirm",
        style: TextStyle(
          color: isSaved? Colors.amber : null,
        ),
      ),
      onPressed:  () {
        bloc.eventControllerFavorite.add(FavoriteEvent(member));
        bloc.eventController.add(SetState());
        Navigator.pop(context);
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
              padding: EdgeInsets.only(bottom: 10),
              margin: EdgeInsets.only(right: 50),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Colors.black54,
                      ))),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        isSaved? "Warning" : "Note",
                        style: TextStyle(
                          color: isSaved? Colors.amber : Colors.blue,
                      ),)
                  ),
                ],
              )
          ),
          content: Text(
              isSaved? "Do you want to remove this user from favorites?" : "Do you want to add this user from favorites?",
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }

}
