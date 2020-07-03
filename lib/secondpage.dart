import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gogameapitest/person.dart';
import 'package:page_transition/page_transition.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var _imagelist = [
    'https://images.unsplash.com/photo-1591250656058-f524c6281874?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjExMDk0fQ&auto=format&fit=crop&w=634&q=80',
    'https://images.unsplash.com/photo-1591253523189-21f2b7872664?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
    'https://images.unsplash.com/photo-1591225757875-f82526401ec3?ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80',
    'https://images.unsplash.com/photo-1591236305424-1908884699ff?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'
  ];

  Material MyItems(
    Image image,
    String heading,
  ) {
    return Material(
      color: Colors.yellow,
      elevation: 10,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(20),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                heading,
                style: TextStyle(color: Colors.blueAccent, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: Column(
            children: <Widget>[
              _firstcontainer(),
              Container(
                color: Colors.green,
                child: StaggeredGridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
                  children: <Widget>[
                    MyItems(
                      Image.asset('assets/coin.png'),
                      "23,009",
                    ),
                    MyItems(
                      Image.asset('assets/coin.png'),
                      "2039",
                    ),
                    MyItems(
                      Image.asset('assets/coin.png'),
                      "Setting",
                    ),
                    MyItems(
                      Image.asset('assets/coin.png'),
                      "Feedback",
                    ),
                    MyItems(
                      Image.asset('assets/coin.png'),
                      "switch to Dark Mode",
                    ),
                    MyItems(
                      Image.asset('assets/coin.png'),
                      "Helpdesk",
                    ),
                    MyItems(
                      Image.asset('assets/coin.png'),
                      "Logout",
                    ),
                  ],
                  staggeredTiles: [
                    StaggeredTile.extent(1, 70),
                    StaggeredTile.extent(1, 70),
                    StaggeredTile.extent(1, 70),
                    StaggeredTile.extent(1, 70),
                    StaggeredTile.extent(2, 70),
                    StaggeredTile.extent(1, 70),
                    StaggeredTile.extent(1, 70),
                  ],
                ),
              ),
              Container(
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
                            imageUrl: _imagelist[index],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstcontainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListTile(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.upToDown,
                      child: ProfilePage()));
            },
            icon: new Image.asset("assets/onee.png")),
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
}
