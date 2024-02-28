// ignore_for_file: deprecated_member_use

import 'package:app/screens/signInScreen.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/widgets.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({a, o}) : super();

  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController? _pageController;
  int _currentIndex = 0;
  List<String> _imageUrl = [
    'assets/intro_1.png',
    'assets/intro_2.png',
    'assets/intro_3.png',
  ];

  _IntroScreenState() : super();

  @override
  Widget build(BuildContext context) {
    List<IntroSH> _titles = [
      IntroSH(
          heading: 'Discover & book local beauty professionals',
          title:
              'A convenient way to browse professionals & book appointments at a time that works for you straight from your calendar.'),
      IntroSH(
          heading: 'Professional barber specialists',
          title:
              'Ready for Your Next Haircut? When you get your hair cut with one of these barbers, it’s more than a cut, it’s an experience.'),
      IntroSH(
          heading: 'Find salons Nearby',
          title:
              'professionals can do anything! From fades to designs, this is the place you want to get your haircut!')
    ];

    return WillPopScope(
      onWillPop: () {
        return exitAppDialog(context).then((value) => value as bool);
      },
      child: Scaffold(
          body: PageView.builder(
              itemCount: _imageUrl.length,
              controller: _pageController,
              onPageChanged: (index) {
                _currentIndex = index;
                setState(() {});
              },
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        _imageUrl[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.31),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: DotsIndicator(
                          dotsCount: _titles.length,
                          position: _currentIndex,
                          onTap: (i) {
                            index = i.toInt();
                            _pageController!.animateToPage(index,
                                duration: Duration(microseconds: 1),
                                curve: Curves.easeInOut);
                          },
                          decorator: DotsDecorator(
                            activeSize: const Size(30, 10),
                            size: const Size(17, 10),
                            activeShape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0))),
                            activeColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomSheet(
                          enableDrag: false,
                          onClosing: () {},
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16, top: 10),
                                    child: Text(
                                      _titles[index].heading!,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Text(
                                      _titles[index].title!,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1,
                                    ),
                                  ),
                                  index == 0 || index == 1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 5.5.w, right: 5.5.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MaterialButton(
                                                height: 45.0,
                                                color: Colors.blue,
                                                onPressed: () {
                                                  _pageController!
                                                      .animateToPage(
                                                          _currentIndex + 1,
                                                          duration: Duration(
                                                              microseconds: 1),
                                                          curve:
                                                              Curves.easeInOut);
                                                },
                                                child: Text(
                                                  'Next',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              MaterialButton(
                                                  height: 45.0,
                                                  color: Colors.blue,
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignInScreen()),
                                                    );
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .lbl_skip,
                                                    style: Theme.of(context)
                                                        .primaryTextTheme
                                                        .subtitle2!
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ))
                                            ],
                                          ),
                                        )
                                      : MaterialButton(
                                          minWidth: 90.0.w,
                                          height: 45.0,
                                          color: Colors.blue,
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInScreen()),
                                            );
                                          },
                                          child: Text(
                                            'Get Started',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                );
              })),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }
}

class IntroSH {
  String? heading;
  String? title;

  IntroSH({this.heading, this.title});
}
