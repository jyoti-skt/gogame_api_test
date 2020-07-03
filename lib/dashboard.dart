import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gogameapitest/person.dart';
import 'package:gogameapitest/secondpage.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:top_sheet/top_sheet.dart';

import 'connection.dart';
import 'constants.dart';
import 'dashboardPage.dart';
import 'endpoint.dart';
import 'staggeredContainer.dart';

class Dashboard extends StatefulWidget {
  @override
  _dashState createState() => _dashState();
}

class _dashState extends State<Dashboard> {
  bool _isLoading;
  dynamic _data;
  NetworkCode _networkCode;

  var _imagelist = [
    'https://images.unsplash.com/photo-1591250656058-f524c6281874?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjExMDk0fQ&auto=format&fit=crop&w=634&q=80',
    'https://images.unsplash.com/photo-1591253523189-21f2b7872664?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
    'https://images.unsplash.com/photo-1591225757875-f82526401ec3?ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80',
    'https://images.unsplash.com/photo-1591236305424-1908884699ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'
  ];

  final List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
    StaggeredTile.extent(1, 150),
    StaggeredTile.extent(1, 150),
    StaggeredTile.extent(1, 200),
    StaggeredTile.extent(1, 200),
  ];

  @override
  void initState() {
    _connectServer();
    super.initState();
  }

  Future<void> _connectServer() async {
    setState(() {
      _networkCode = NetworkCode.loading;
      _isLoading = true;
    });

    Connection connection = Connection();
    http.Response response = await connection.postRequest(
        body: '', endpoint: EndpointDashboard.kDashboard);

    switch (response.statusCode) {
      case 101:
        setState(() {
          _networkCode = NetworkCode.noInternet;
        });
        break;
      case 200:
        _data = jsonDecode(response.body);
        if (_data['status'] == 1) {
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _networkCode = NetworkCode.serverError;
          });
        }
        break;
      case 204:
      default:
        setState(() {
          _networkCode = NetworkCode.serverError;
        });
        break;
    }
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Text('GOGAME'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            TopSheet.show(
              direction: SheetDirection.TOP,
              context: context,
              child: Container(
                height: ScreenUtil().setHeight(400),
                decoration: BoxDecoration(
                  gradient: kTopSheetGradient,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: _firstcontainer(true),
                    ),
                    Divider(
                      color: Colors.white,
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StaggeredGridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      children: <Widget>[
                        ReusableCard(
                            onPress: null,
                            buttonText: '23,000',
                            imageName: 'images/rupees.png'),
                        ReusableCard(
                            onPress: null,
                            buttonText: '2039',
                            imageName: 'images/light_coin.png'),
                        ReusableCard(
                            onPress: null,
                            buttonText: kSettings,
                            imageName: 'images/knob.png'),
                        ReusableCard(
                            onPress: null,
                            buttonText: kFeedback,
                            imageName: 'images/feedback.png'),
                        ReusableCard(
                            onPress: null,
                            buttonText: kSwitchToDarkMode,
                            imageName: 'images/themeSwitch.png'),
                        ReusableCard(
                            onPress: null,
                            buttonText: kHelpDesk,
                            imageName: 'images/helpdesk.png'),
                        ReusableCard(
                            onPress: null,
                            buttonText: kLogout,
                            imageName: 'images/rupees.png'),
                      ],
                      staggeredTiles: _staggeredTiles,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _firstcontainer([bool showTrailing]) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  curve: Curves.linear,
                  type: PageTransitionType.upToDown,
                  child: ProfilePage()));
        },
        leading: Container(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset('assets/two.jpg'),
          ),
        ),
        title: Text('gogame'),
        subtitle: Text('gaming is fun'),
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            // icon-1
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        curve: Curves.linear,
                        type: PageTransitionType.upToDown,
                        child: SecondPage()));
              },
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ), // icon-2
          ],
        ),
      ),
    );
  }

  Widget _secondcontainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.blueAccent],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.notifications,
                        color: Colors.orangeAccent,
                      )),
                  Container(
                    child: Text(
                      "23K",
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Light Coins",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.notifications,
                        color: Colors.orange,
                      )),
                  Container(
                    child: Text(
                      "1",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Level",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.orangeAccent],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.notifications,
                        color: Colors.orange,
                      )),
                  Container(
                    child: Text(
                      "2K",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Cash",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thirdcontainer() {
    return Container(
      color: Colors.purple,
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.3,
      child: PageView.builder(
          itemCount: _imagelist.length,
          itemBuilder: (context, index) {
            return Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      kImageAddress + _data['slider'][index]['sliderImage'],
                ),
              ),
            );
          }),
    );
  }

  Widget _fourthcontainer() {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(10),
          // height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.star,
                          size: 35,
                          color: Colors.yellow,
                        ),
                      ),
                      TextSpan(
                          text: "FEATURED",
                          style: TextStyle(fontSize: 20, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    child: Image.asset(
                      'assets/two.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      width: 220,
                      padding: EdgeInsets.all(10),
                      color: Colors.orangeAccent,
                      child: Text(
                        "Gogame app",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.schedule),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Duration'),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.work),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Work')
                      ],
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                          text: "Earth Knight",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                          text: "Scorching Desert with 200 Levels.",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                          text: "join the biggest battle ever!",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fifthcontainer() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      // height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                'assets/onee.png',
                fit: BoxFit.cover,
              ),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      text: "Earth Knight",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sixthcontaoiner() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    ScreenUtil.init(width: width, height: height, allowFontScaling: false);

    return Scaffold(
      appBar: _isLoading ? AppBar() : _appBar(),
      body: SafeArea(
        child: _isLoading
            ? NetworkWidget(
                networkCode: _networkCode,
                onPressed: () {
                  _connectServer();
                })
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _firstcontainer(),
                    _secondcontainer(),
                    _thirdcontainer(),
                    _fourthcontainer(),
                    _fifthcontainer(),
                    _sixthcontaoiner(),
                    _appBar(),
                    StaggeredGridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 30.0,
                      mainAxisSpacing: 30.0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 25.0),
                      children: <Widget>[
                        StaggeredContainer(
                          title: kRows,
                          onTap: () {},
                          imagename: _imagelist[3],
                        ),
                        StaggeredContainer(
                          title: kRows,
                          onTap: () {},
                          imagename: _imagelist[0],
                        ),
                        StaggeredContainer(
                          title: kRows,
                          onTap: () {},
                          imagename: _imagelist[1],
                        ),
                        StaggeredContainer(
                          title: kRows,
                          onTap: () {},
                          imagename: _imagelist[2],
                        ),
                      ],
                      staggeredTiles: _staggeredTiles,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
