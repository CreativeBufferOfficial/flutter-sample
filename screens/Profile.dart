import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Creativebuffer/utils/Utils.dart';
import 'package:Creativebuffer/utils/apis/Apis.dart';
import 'package:Creativebuffer/utils/modal/InfixMap.dart';
import 'package:Creativebuffer/utils/server/ProfileService.dart';
import 'package:Creativebuffer/utils/widget/AppBarWidget.dart';
import 'package:Creativebuffer/utils/widget/ProfileListRow.dart';
// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String id;
  String image;

  Profile({this.id,this.image});

  @override
  _ProfileState createState() => _ProfileState(id: id,image: image);
}

class _ProfileState extends State<Profile> {
  bool isPersonal = false;
  bool isParents = false;
  bool isTransport = false;
  bool isOthers = false;
  String section = 'personal';
  String _email;
  String _password;
  String id;
  String image;
  String schoolId;
  ProfileService profileService;


  _ProfileState({this.id,this.image});

  @override
  Widget build(BuildContext context) {
    Utils.getStringValue('email').then((value) {
      _email = value;
    });

    Utils.getStringValue('schoolId').then((value) {
      schoolId = value;
    });

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.indigo, //or set color with: Color(0xFF0000FF)
    ));

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Scaffold(
        appBar: AppBarWidget.header(context, 'Profile'),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      height: 60.0,
                      child: FutureBuilder(
                        future: Utils.getStringValue('image'),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Align(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(image == null ? snapshot.data : image),
                                backgroundColor: Colors.transparent,
                              ),
                            );
                          } else {
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                    'http://saskolhmg.com/images/studentprofile.png'),
                                backgroundColor: Colors.transparent,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(child: getProfileHeader()),
                  ],
                ),
              ),
            ),
            Container(
              height: 23.0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPersonal = true;
                            isParents = false;
                            isTransport = false;
                            isOthers = false;

                            section = 'personal';
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Personal',
                              style: Theme.of(context).textTheme.display1.copyWith(color: Color(0xFF415094),),
                            ),
                            Container(
                              height: 2.0,
                              decoration: BoxDecoration(
                                color: isPersonal
                                    ? Colors.deepPurpleAccent
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isParents = true;
                            isPersonal = false;
                            isTransport = false;
                            isOthers = false;

                            section = 'parents';
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Parents',
                              style: Theme.of(context).textTheme.display1.copyWith(color: Color(0xFF415094),),
                            ),
                            Container(
                              height: 2.0,
                              decoration: BoxDecoration(
                                color: isParents
                                    ? Colors.deepPurpleAccent
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isTransport = true;
                            isParents = false;
                            isPersonal = false;
                            isOthers = false;

                            section = 'transport';
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Transport',
                              style: Theme.of(context).textTheme.display1.copyWith(color: Color(0xFF415094),),
                            ),
                            Container(
                              height: 2.0,
                              decoration: BoxDecoration(
                                color: isTransport
                                    ? Colors.deepPurpleAccent
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isTransport = false;
                            isParents = false;
                            isPersonal = false;
                            isOthers = true;

                            section = 'others';
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Others',
                              style: Theme.of(context).textTheme.display1.copyWith(color: Color(0xFF415094),),
                            ),
                            Container(
                              height: 2.0,
                              decoration: BoxDecoration(
                                color: isOthers
                                    ? Colors.deepPurpleAccent
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 15.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xfff3e5f5).withOpacity(0.5), Colors.white]),
              ),
            ),
            Expanded(
              child: getProfileList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: Utils.getStringValue('password'),
        builder: (context, snapshot) {
          _password = snapshot.data;

          profileService = id == null ? ProfileService(email: _email,password: _password,schoolId:schoolId) : ProfileService(id: id);

          return Container(
            child: FutureBuilder(
              future: profileService.fetchPersonalServices(section),
              builder: (BuildContext context,
                  AsyncSnapshot<List<InfixMap>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProfileRowList(
                          snapshot.data[index].key, snapshot.data[index].value);
                    },
                  );
                } else {
                  return Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.headline,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget getProfileHeader() {
    return FutureBuilder(
        future: Utils.getStringValue('password'),
        builder: (context, snapshot) {
          _password = snapshot.data;
          profileService = id == null ? ProfileService(email: _email,password: _password,schoolId:schoolId) : ProfileService(id: id);

          return FutureBuilder(
            future: profileService.fetchPersonalServices('profile'),
            builder: (context, snapshot1) {
              if (snapshot1.data != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(snapshot1.data[0].value,
                        style: Theme.of(context).textTheme.headline),
                    Text(
                      'Class : ' +
                          snapshot1.data[2].value +
                          ' | Section : ' +
                          snapshot1.data[1].value,
                      style: Theme.of(context).textTheme.title.copyWith(color: Color(0xFF727FC8)),
                    ),
                    Text(
                      'Roll : ' +
                          snapshot1.data[3].value +
                          ' | Adm : ' +
                          snapshot1.data[4].value,
                      style: Theme.of(context).textTheme.title.copyWith(color: Color(0xFF727FC8)),
                    ),
                  ],
                );
              } else {
                return Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.headline,
                );
              }
            },
          );
        });
  }

  void navigateToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  Future<String> getImageUrl(String email, String password, String rule) async {
    var image = 'https://i.imgur.com/BoN9kdC.png';

    var response = await http.get(InfixApi.login(email, password));

    if (response.statusCode == 200) {
      Map<String, dynamic> user = jsonDecode(response.body) as Map;

      if (rule == '2')
        image = user['data']['userDetails']['student_photo'];
      else
        image = user['data']['userDetails']['staff_photo'];
    }
    return InfixApi.root + '$image';
  }
}
