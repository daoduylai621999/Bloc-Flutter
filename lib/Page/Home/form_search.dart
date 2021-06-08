import 'package:flutter/material.dart';
import 'package:practice/Bloc/Home/bloc.dart';
import 'package:practice/Bloc/Home/event.dart';

class FormSearch extends StatefulWidget {
  const FormSearch({Key key, this.bloc, this.dataSearch}) : super(key: key);
  final SearchGithubBloc bloc;
  final String dataSearch;

  @override
  _FormSearchState createState() => _FormSearchState(bloc: bloc, dataSearch: dataSearch);
}

class _FormSearchState extends State<FormSearch> {
  _FormSearchState({this.bloc, this.dataSearch});

  final SearchGithubBloc bloc;
  String dataSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.black54,
                ))),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.only(top: 10),
        child: Container(
          margin: EdgeInsets.only(right: 30, left: 30, bottom: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Text(
                      "Search:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                      decoration: InputDecoration(
                          hintText: "Enter name",
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          )
                      ),
                      onChanged: (text) {
                        dataSearch = text;
                      },
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        bloc.eventController.sink.add(SearchGithubEvent(dataSearch));
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
}

