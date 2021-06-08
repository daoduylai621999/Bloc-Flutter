import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:practice/Bloc/Home/bloc.dart';
import 'package:practice/Bloc/Home/event.dart';
import 'package:practice/Module/member.dart';
import 'package:practice/Page/Detail/detail.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key key, this.bloc}) : super(key: key);
  final SearchGithubBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Favorites"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Member>("favoriteBox").listenable(),
          builder: (context, Box<Member> box, _) {
            if(box.isEmpty) return new Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    "No has data",
                    style: TextStyle(fontSize: 18, color: Colors.green, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            );
            else return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, int index) {
                return _buildRow(box.getAt(index), index, context);
              },
            );
            },
        ),
      ),
    );
  }

  Widget _buildRow(Member member, int index, BuildContext context) {
    final _isSaved = true;
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
            )]
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
                    title: new Text("${member.login}"),
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
              child: SizedBox(
                child: new IconButton(
                  onPressed: () {
                    showAlertDialog(context, member);
                  },
                  icon: new Icon(
                    _isSaved? Icons.favorite : Icons.favorite_border_outlined,
                    color: _isSaved? Colors.redAccent.withOpacity(0.8) : Colors.black54.withOpacity(0.7),
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, Member member) {
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
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
                      child: Text("Warning", style: TextStyle(color: Colors.amber),)
                  ),
                ],
              )
          ),
          content: Text("Do you want to remove this user from favorites?"),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }
}
