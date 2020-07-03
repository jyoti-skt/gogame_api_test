import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gogameapitest/server_strings.dart';
import 'package:http/http.dart' as http;
import 'package:top_sheet/top_sheet.dart';

import 'connection.dart';
import 'constants.dart';
import 'endpoint.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading;
  dynamic _data;
  NetworkCode _networkCode;

  final List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
    StaggeredTile.extent(1, 60),
    StaggeredTile.extent(1, 60),
    StaggeredTile.extent(1, 60),
    StaggeredTile.extent(1, 60),
    StaggeredTile.extent(2, 60),
    StaggeredTile.extent(1, 60),
    StaggeredTile.extent(1, 60),
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
                      child: _listTile(true),
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

  Widget _listTile([bool showTrailing]) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Container(
        height: ScreenUtil().setHeight(50),
        width: ScreenUtil().setWidth(50),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: CachedNetworkImage(
            imageUrl: kDemoImage,
            fit: BoxFit.fill,
          ),
        ),
      ),
      title: Text(
        kXPhantom,
        style: TextStyle(
            color: showTrailing != null && showTrailing
                ? Colors.white
                : Colors.black,
            fontFamily: kDefaultFont,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Srikanta M S',
        style: TextStyle(
          color: showTrailing != null && showTrailing
              ? Colors.white
              : Colors.black,
          fontFamily: kDefaultFont,
        ),
      ),
      trailing: showTrailing != null && showTrailing
          ? Icon(
              Icons.menu,
              color: showTrailing != null && showTrailing
                  ? Colors.white
                  : Colors.black,
            )
          : null,
    );
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
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: _listTile(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 100.h,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: SmallCardTile(
                                title: '23K',
                                subtitle: 'Light Coins',
                                onTap: null,
                                imageName: 'images/trophy.png',
                                titleColor: Colors.black,
                                alignment: Alignment.topLeft,
                                gradient: kBlueButtonGradient,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: SmallCardTile(
                                  gradient: kPurpleButtonGradient,
                                  title: '1',
                                  subtitle: 'Level',
                                  onTap: null,
                                  imageName: 'images/trophy.png',
                                  titleColor: Colors.white,
                                  alignment: Alignment.topCenter),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: SmallCardTile(
                                  gradient: kYellowButtonGradient,
                                  title: '2K',
                                  subtitle: 'Cash',
                                  onTap: null,
                                  imageName: 'images/rupees.png',
                                  titleColor: Colors.black,
                                  alignment: Alignment.topLeft),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      height: 250.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: kPurpleGradientColors,
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                      ),
                      child: PageView.builder(
//                        controller: PageController(
//                          viewportFraction: 2.0,
//                          initialPage: 0,
//                        ),
                        itemCount: _data['slider'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: CachedNetworkImage(
                              height: 200,
                              width: double.infinity,
                              imageUrl: kImageAddress +
                                  _data['slider'][index]['sliderImage'],
//                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Image(
                                image: AssetImage(kStarImage),
                                height: 22,
                                width: 22,
                              ),
                            ),
                            TextSpan(
                              text: ' ${kFeatured.toUpperCase()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: kDefaultFont,
                                  fontSize: 20.ssp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameEntry(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 300.h,
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: CachedNetworkImage(
                                      height: 220,
                                      width: double.infinity,
                                      imageUrl: kImageAddress +
                                          _data['game'][0]['gameImage'],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _data['game'][0]['gameName'],
                                      style: TextStyle(
                                          fontFamily: kDefaultFont,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20.ssp),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            'Scorching Desert with 200 levels.\n',
                                        style: TextStyle(
                                            fontSize: 14.ssp,
                                            fontFamily: kDefaultFont,
                                            color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                'Join the biggest battle ever!',
                                            style: TextStyle(
                                              fontSize: 14.ssp,
                                              fontFamily: kDefaultFont,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Image.asset(kSonicImage),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 300.h,
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: CachedNetworkImage(
                              height: 220,
                              width: double.infinity,
                              imageUrl:
                                  kImageAddress + _data['game'][1]['gameImage'],
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5.0, right: 5.0),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _data['game'][1]['gameName'],
                                      style: TextStyle(
                                          fontFamily: kDefaultFont,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20.ssp),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5.0),
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: 'Scorching Desert with 200 levels.\n',
                                style: TextStyle(
                                    fontSize: 14.ssp,
                                    fontFamily: kDefaultFont,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Join the biggest battle ever!',
                                    style: TextStyle(
                                      fontSize: 14.ssp,
                                      fontFamily: kDefaultFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StaggeredGridView.countBuilder(
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: kImageAddress +
                                      _data['game'][2]
                                          ['gameImage'] /*kGameImage*/,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 5.0),
                              child: Text(
                                _data['game'][2]['gameName'],
                                style: TextStyle(
                                    fontFamily: kDefaultFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        );
                      },
                      staggeredTileBuilder: (int index) {
                        return StaggeredTile.extent(1, 150);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class NetworkCode {}

class SmallCardTile extends StatelessWidget {
  SmallCardTile(
      {@required this.title,
      @required this.subtitle,
      @required this.onTap,
      @required this.imageName,
      @required this.titleColor,
      @required this.alignment,
      @required this.gradient});

  final Function onTap;
  final Alignment alignment;
  final Gradient gradient;
  final String title, imageName, subtitle;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: alignment,
            margin: alignment == Alignment.topCenter
                ? EdgeInsets.zero
                : EdgeInsets.only(left: 10),
            height: 18,
            width: 18,
            child: Image.asset(
              imageName,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: kDefaultFont,
                  fontSize: 22.ssp,
                  color: titleColor),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              subtitle,
              style: TextStyle(
                  fontFamily: kDefaultFont,
                  fontSize: 14.ssp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  ReusableCard(
      {@required this.onPress,
      @required this.buttonText,
      @required this.imageName});

  final Function onPress;
  final String imageName;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imageName,
              height: 24,
              width: 24,
//              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              buttonText,
              style: TextStyle(
                color: Colors.black,
                fontFamily: kDefaultFont,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(18),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
