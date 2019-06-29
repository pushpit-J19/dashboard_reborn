import 'dart:math';

import 'package:dashboard_reborn/pages/gradients_page.dart';
import 'package:dashboard_reborn/utils/functions.dart';
import 'package:dashboard_reborn/utils/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

List imageData = [image5, image3, image4, image2, image1];

class CardDemo extends StatefulWidget {
  @override
  CardDemoState createState() => new CardDemoState();
}

class CardDemoState extends State<CardDemo> with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  List data = imageData;
  List selectedData = [];
  void initState() {
    super.initState();

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = data.removeLast();
          data.insert(0, i);

          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(DecorationImage img) {
    setState(() {
      data.remove(img);
    });
  }

  addImg(DecorationImage img) {
    setState(() {
      data.remove(img);
      selectedData.add(img);
    });
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    double initialBottom = 15.0;
    var dataLength = data.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -10.0;
    return (new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: new Color.fromRGBO(106, 94, 175, 1.0),
        centerTitle: true,
        leading: new Container(
          margin: const EdgeInsets.all(15.0),
          child: new Icon(
            Icons.equalizer,
            color: Colors.cyan,
            size: 30.0,
          ),
        ),
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (context) => new PageMain()));
            },
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              child: new Icon(
                Icons.search,
                color: Colors.cyan,
                size: 30.0,
              ),
            ),
          ),
        ],
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "EVENTS",
              style: new TextStyle(
                  fontSize: 12.0,
                  letterSpacing: 3.5,
                  fontWeight: FontWeight.bold),
            ),
            new Container(
              width: 15.0,
              height: 15.0,
              margin: new EdgeInsets.only(bottom: 20.0),
              alignment: Alignment.center,
              child: new Text(
                dataLength.toString(),
                style: new TextStyle(fontSize: 10.0),
              ),
              decoration:
                  new BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
      body: new Container(
        color: new Color.fromRGBO(106, 94, 175, 1.0),
        alignment: Alignment.center,
        child: dataLength > 0
            ? new Stack(
                alignment: AlignmentDirectional.center,
                children: data.map((item) {
                  if (data.indexOf(item) == dataLength - 1) {
                    return cardDemo(
                        item,
                        bottom.value,
                        right.value,
                        0.0,
                        backCardWidth + 10,
                        rotate.value,
                        rotate.value < -10 ? 0.1 : 0.0,
                        context,
                        dismissImg,
                        flag,
                        addImg,
                        swipeRight,
                        swipeLeft);
                  } else {
                    backCardPosition = backCardPosition - 10;
                    backCardWidth = backCardWidth + 10;

                    return cardDemoDummy(item, backCardPosition, 0.0, 0.0,
                        backCardWidth, 0.0, 0.0, context);
                  }
                }).toList())
            : new Text("No Event Left",
                style: new TextStyle(color: Colors.white, fontSize: 50.0)),
      ),
    ));
  }
}

Positioned cardDemoDummy(
    DecorationImage img,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  // Size screenSize=(500.0,200.0);
  // print("dummyCard");
  return new Positioned(
    bottom: 100.0 + bottom,
    // right: flag == 0 ? right != 0.0 ? right : null : null,
    //left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Card(
      color: Colors.transparent,
      elevation: 4.0,
      child: new Container(
        alignment: Alignment.center,
        width: screenSize.width / 1.2 + cardWidth,
        height: screenSize.height / 1.7,
        decoration: new BoxDecoration(
          color: new Color.fromRGBO(121, 114, 173, 1.0),
          borderRadius: new BorderRadius.circular(8.0),
        ),
        child: new Column(
          children: <Widget>[
            new Container(
              width: screenSize.width / 1.2 + cardWidth,
              height: screenSize.height / 2.2,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(8.0),
                    topRight: new Radius.circular(8.0)),
                image: img,
              ),
            ),
            new Container(
              width: screenSize.width / 1.2 + cardWidth,
              height: screenSize.height / 1.7 - screenSize.height / 2.2,
              alignment: Alignment.center,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {},
                    child: new Container(
                      height: 60.0,
                      width: 130.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: new BorderRadius.circular(60.0),
                      ),
                      child: new Text(
                        "DON'T",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  new FlatButton(
                    padding: new EdgeInsets.all(0.0),
                    onPressed: () {},
                    child: new Container(
                      height: 60.0,
                      width: 130.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: new BorderRadius.circular(60.0),
                      ),
                      child: new Text(
                        "I'M IN",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Positioned cardDemo(
    DecorationImage img,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft) {
  Size screenSize = MediaQuery.of(context).size;
  // print("Card");
  return new Positioned(
    bottom: 100.0 + bottom,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Dismissible(
      key: new Key(new Random().toString()),
      crossAxisEndOffset: -0.3,
      onResize: () {
        //print("here");
        // setState(() {
        //   var i = data.removeLast();

        //   data.insert(0, i);
        // });
      },
      onDismissed: (DismissDirection direction) {
//          _swipeAnimation();
        if (direction == DismissDirection.endToStart)
          dismissImg(img);
        else
          addImg(img);
      },
      child: new Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        //transform: null,
        transform: new Matrix4.skewX(skew),
        //..rotateX(-math.pi / rotation),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
          child: new Hero(
            tag: "img",
            child: new GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => new DetailPage(type: img)));
                Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new DetailPage(type: img),
                ));
              },
              child: new Card(
                color: Colors.transparent,
                elevation: 4.0,
                child: new Container(
                  alignment: Alignment.center,
                  width: screenSize.width / 1.2 + cardWidth,
                  height: screenSize.height / 1.7,
                  decoration: new BoxDecoration(
                    color: new Color.fromRGBO(121, 114, 173, 1.0),
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        width: screenSize.width / 1.2 + cardWidth,
                        height: screenSize.height / 2.2,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                              topLeft: new Radius.circular(8.0),
                              topRight: new Radius.circular(8.0)),
                          image: img,
                        ),
                      ),
                      new Container(
                        width: screenSize.width / 1.2 + cardWidth,
                        height:
                            screenSize.height / 1.7 - screenSize.height / 2.2,
                        alignment: Alignment.center,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new FlatButton(
                                padding: new EdgeInsets.all(0.0),
                                onPressed: () {
                                  swipeLeft();
                                },
                                child: new Container(
                                  height: 60.0,
                                  width: 130.0,
                                  alignment: Alignment.center,
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        new BorderRadius.circular(60.0),
                                  ),
                                  child: new Text(
                                    "DON'T",
                                    style: new TextStyle(color: Colors.white),
                                  ),
                                )),
                            new FlatButton(
                              padding: new EdgeInsets.all(0.0),
                              onPressed: () {
                                swipeRight();
                              },
                              child: new Container(
                                height: 60.0,
                                width: 130.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: new BorderRadius.circular(60.0),
                                ),
                                child: new Text(
                                  "I'M IN",
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class DetailPage extends StatefulWidget {
  final DecorationImage type;
  const DetailPage({Key key, this.type}) : super(key: key);
  @override
  _DetailPageState createState() => new _DetailPageState(type: type);
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;
  DecorationImage type;
  _DetailPageState({this.type});
  List data = imageData;
  double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  void initState() {
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 200.0,
      end: 220.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 400.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.7;
    int img = data.indexOf(type);
    //print("detail");
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromRGBO(106, 94, 175, 1.0),
        platform: Theme.of(context).platform,
      ),
      child: new Container(
        width: width.value,
        height: heigth.value,
        color: const Color.fromRGBO(106, 94, 175, 1.0),
        child: new Hero(
          tag: "img",
          child: new Card(
            color: Colors.transparent,
            child: new Container(
              alignment: Alignment.center,
              width: width.value,
              height: heigth.value,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new CustomScrollView(
                    shrinkWrap: false,
                    slivers: <Widget>[
                      new SliverAppBar(
                        elevation: 0.0,
                        forceElevated: true,
                        leading: new IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: new Icon(
                            Icons.arrow_back,
                            color: Colors.cyan,
                            size: 30.0,
                          ),
                        ),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating ||
                            _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        flexibleSpace: new FlexibleSpaceBar(
                          title: new Text("Party"),
                          background: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              new Container(
                                width: width.value,
                                height: _appBarHeight,
                                decoration: new BoxDecoration(
                                  image: data[img],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            new Container(
                              color: Colors.white,
                              child: new Padding(
                                padding: const EdgeInsets.all(35.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      padding:
                                          new EdgeInsets.only(bottom: 20.0),
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          border: new Border(
                                              bottom: new BorderSide(
                                                  color: Colors.black12))),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Row(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.access_time,
                                                color: Colors.cyan,
                                              ),
                                              new Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text("10:00  AM"),
                                              )
                                            ],
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              new Icon(
                                                Icons.map,
                                                color: Colors.cyan,
                                              ),
                                              new Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Text("15 MILES"),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 8.0),
                                      child: new Text(
                                        "ABOUT",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    new Text(
                                        "It's party, party, party like a nigga just got out of jail Flyin' in my 'Rari like a bat that just flew outta hell I'm from the east of ATL, but ballin' in the Cali hills Lil mama booty boomin', that bitch movin' and she standin' still I know these bitches choosin' me, but I got 80 on me still. host for the purposes of socializing, conversation, recreation, or as part of a festival or other commemoration of a special occasion. A party will typically feature food and beverages, and often music and dancing or other forms of entertainment.  "),
                                    new Container(
                                      margin: new EdgeInsets.only(top: 25.0),
                                      padding: new EdgeInsets.only(
                                          top: 5.0, bottom: 10.0),
                                      height: 120.0,
                                      decoration: new BoxDecoration(
                                          color: Colors.white,
                                          border: new Border(
                                              top: new BorderSide(
                                                  color: Colors.black12))),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            "ATTENDEES",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new CircleAvatar(
                                                  backgroundImage: avatar1),
                                              new CircleAvatar(
                                                backgroundImage: avatar2,
                                              ),
                                              new CircleAvatar(
                                                backgroundImage: avatar3,
                                              ),
                                              new CircleAvatar(
                                                backgroundImage: avatar4,
                                              ),
                                              new CircleAvatar(
                                                backgroundImage: avatar5,
                                              ),
                                              new CircleAvatar(
                                                backgroundImage: avatar6,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      height: 100.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  new Container(
                    width: 600.0,
                    height: 80.0,
                    decoration: new BoxDecoration(
                      color: new Color.fromRGBO(121, 114, 173, 1.0),
                    ),
                    alignment: Alignment.center,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new FlatButton(
                          padding: new EdgeInsets.all(0.0),
                          onPressed: () {},
                          child: new Container(
                            height: 60.0,
                            width: 130.0,
                            alignment: Alignment.center,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: new BorderRadius.circular(60.0),
                            ),
                            child: new Text(
                              "DON'T",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        new FlatButton(
                          padding: new EdgeInsets.all(0.0),
                          onPressed: () {},
                          child: new Container(
                            height: 60.0,
                            width: 130.0,
                            alignment: Alignment.center,
                            decoration: new BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: new BorderRadius.circular(60.0),
                            ),
                            child: new Text(
                              "I'M IN",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

DecorationImage image1 = new DecorationImage(
  image: new ExactAssetImage('assets/img1.jpg'),
  fit: BoxFit.cover,
);
DecorationImage image2 = new DecorationImage(
  image: new ExactAssetImage('assets/img2.jpg'),
  fit: BoxFit.cover,
);

DecorationImage image3 = new DecorationImage(
  image: new ExactAssetImage('assets/img3.jpg'),
  fit: BoxFit.cover,
);
DecorationImage image4 = new DecorationImage(
  image: new ExactAssetImage('assets/img4.jpg'),
  fit: BoxFit.cover,
);
DecorationImage image5 = new DecorationImage(
  image: new ExactAssetImage('assets/img5.jpg'),
  fit: BoxFit.cover,
);

ImageProvider avatar1 = new ExactAssetImage('assets/avatars/avatar-1.jpg');
ImageProvider avatar2 = new ExactAssetImage('assets/avatars/avatar-2.jpg');
ImageProvider avatar3 = new ExactAssetImage('assets/avatars/avatar-3.jpg');
ImageProvider avatar4 = new ExactAssetImage('assets/avatars/avatar-4.jpg');
ImageProvider avatar5 = new ExactAssetImage('assets/avatars/avatar-5.jpg');
ImageProvider avatar6 = new ExactAssetImage('assets/avatars/avatar-6.jpg');

class PageDragger extends StatefulWidget {
  final canDragRightToLeft;
  final canDragLeftToRight;
  final StreamController<SlideUpdate> slideUpdateSytream;

  PageDragger(
      {this.canDragLeftToRight,
      this.canDragRightToLeft,
      this.slideUpdateSytream});

  @override
  _PageDraggerState createState() => new _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;
  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateSytream.add(
          new SlideUpdate(UpdateType.dragging, slidePercent, slideDirection));
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateSytream.add(
        new SlideUpdate(UpdateType.doneDragging, 0.0, SlideDirection.none));

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

class AnimatedPagedragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPagedragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    var startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;

      final slideRemaining = 1.0 - slidePercent;
      duration = new Duration(
          milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round());
    } else {
      endSlidePercent = 0.0;
      duration = new Duration(
          milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }

    completionAnimationController =
        new AnimationController(vsync: vsync, duration: duration)
          ..addListener(() {
            final slidePercent = lerpDouble(startSlidePercent, endSlidePercent,
                completionAnimationController.value);
            slideUpdateStream.add(new SlideUpdate(
                UpdateType.animating, slidePercent, slideDirection));
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              slideUpdateStream.add(new SlideUpdate(
                  UpdateType.doneAnimating, endSlidePercent, slideDirection));
            }
          });
  }
  run() {
    completionAnimationController.forward(from: 0.0);
  }

  dispose() {
    completionAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final updateType;
  final direction;
  final slidePercent;

  SlideUpdate(this.updateType, this.slidePercent, this.direction);
}

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;
  PagerIndicator({this.viewModel});

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];

    for (var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];
      var percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(new PageBubble(
        viewModel: new PageBubbleViewModel(
            page.color, percentActive, page.iconAssetIcon, isHollow),
      ));
    }

    final BUBBLE_WIDTH = 55.0;
    final baseTranslation =
        ((viewModel.pages.length * BUBBLE_WIDTH) / 2) - (BUBBLE_WIDTH / 2);
    var translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDTH);

    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += BUBBLE_WIDTH * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= BUBBLE_WIDTH * viewModel.slidePercent;
    }

    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        new Transform(
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
      ],
    );
  }
}

enum SlideDirection { leftToRight, rightToLeft, none }

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
      this.slideDirection, this.activeIndex, this.pages, this.slidePercent);
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 55.0,
      height: 65.0,
      child: new Center(
        child: new Container(
          width: lerpDouble(25.0, 45.0, viewModel.activePercent),
          height: lerpDouble(25.0, 45.0, viewModel.activePercent),
          decoration: new BoxDecoration(
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF)
                      .withAlpha((0x88 * viewModel.activePercent).round())
                  : const Color(0x88FFFFFF),
              shape: BoxShape.circle,
              border: new Border.all(
                  color: viewModel.isHollow
                      ? const Color(0x88FFFFFF).withAlpha(
                          (0x88 * (1.0 - viewModel.activePercent)).round())
                      : Colors.transparent)),
          child: new Opacity(
              opacity: viewModel.activePercent,
              child: new Icon(
                viewModel.iconPath,
                color: viewModel.color,
              )),
        ),
      ),
    );
  }
}

class PageBubbleViewModel {
  final IconData iconPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
      this.color, this.activePercent, this.iconPath, this.isHollow);
}

class PageMain extends StatefulWidget {
  @override
  PageMainState createState() => new PageMainState();
}

class PageMainState extends State<PageMain> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPagedragger animatedPagedragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  PageMainState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }

//         nextPageIndex=slideDirection==SlideDirection.leftToRight ? activeIndex-1 : activeIndex+1;
//
//         nextPageIndex.clamp(0.0, pages.length-1);
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPagedragger = new AnimatedPagedragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

//           activeIndex=slideDirection==SlideDirection.leftToRight ? activeIndex-1 : activeIndex+1;
//           activeIndex.clamp(0.0, pages.length-1);
          } else {
            animatedPagedragger = new AnimatedPagedragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
            nextPageIndex = activeIndex;
          }
          animatedPagedragger.run();

//         slideDirection=SlideDirection.none;
//       slidePercent=0.0;

        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;
          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
          animatedPagedragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(slidePercent);
    return (new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0,
          ),
          new PageReveal(
            revealPercent: slidePercent,
            child: new Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          new PagerIndicator(
            viewModel: new PagerIndicatorViewModel(
                slideDirection, activeIndex, pages, slidePercent),
          ),
          new PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
            slideUpdateSytream: this.slideUpdateStream,
          )
        ],
      ),
    ));
  }
}

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;
  PageReveal({this.child, this.revealPercent});

  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      clipper: new CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {
    final epicenter = new Offset(size.width / 2, size.height * 0.9);

    double theta = atan(epicenter.dy / epicenter.dx);

    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return new Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

final pages = [
  new PageViewModel(
      Colors.blue, Icons.phone, Icons.contacts, "This is subtitle", "Contact"),
  new PageViewModel(
      Colors.red, Icons.chat_bubble, Icons.chat, "This is subtitle", "Chat"),
  new PageViewModel(
      Colors.green, Icons.hotel, Icons.home, "This is subtitle", "Home"),
];

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;
  Page({this.viewModel, this.percentVisible = 1.0});

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      color: viewModel.color,
      child: new Opacity(
        opacity: percentVisible,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Transform(
              child: new Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: new Icon(
                  viewModel.iconName,
                  size: 150.0,
                  color: Colors.white,
                ),
              ),
              transform: new Matrix4.translationValues(
                  0.0, 50.0 * (1.0 - percentVisible), 0.0),
            ),
            new Transform(
              transform: new Matrix4.translationValues(
                  0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: new Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: new Text(
                  viewModel.title,
                  style: new TextStyle(
                      fontSize: 34.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            new Transform(
              transform: new Matrix4.translationValues(
                  0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: new Padding(
                padding: const EdgeInsets.only(bottom: 75.0),
                child: new Text(
                  viewModel.subtitle,
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final IconData iconName;
  final String title;
  final String subtitle;
  final IconData iconAssetIcon;
  PageViewModel(
      this.color, this.iconAssetIcon, this.iconName, this.subtitle, this.title);
}
