import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(229, 244, 255, .1),
  100: Color.fromRGBO(179, 223, 255, .2),
  200: Color.fromRGBO(128, 202, 255, .3),
  300: Color.fromRGBO(77, 181, 255, .4),
  400: Color.fromRGBO(26, 159, 255, .5),
  500: Color.fromRGBO(0, 134, 230, .6),
  600: Color.fromRGBO(0, 104, 179, .7),
  700: Color.fromRGBO(0, 74, 128, .8),
  800: Color.fromRGBO(0, 45, 77, .9),
  900: Color.fromRGBO(0, 15, 26, 1),
};
ThemeData nativeTheme() {
  return ThemeData(
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.blue,
        selectionHandleColor: Colors.blue),
    splashFactory: NoSplash.splashFactory,
    useMaterial3: true,

    primaryColor: Colors.blue,
    primaryColorLight: Color(0xFF898A8D), // Color(0xFF66d5ff),
    primaryColorDark: Colors.blue,
    primaryIconTheme: IconThemeData(color: Colors.blue),
    cardColor: Colors.white,
    primaryTextTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.w500), // listtile title white
      displayMedium: TextStyle(
          color: Colors.white70, fontSize: 11), // listtile subtitle white
      displaySmall: TextStyle(
          fontSize: 14,
          color: Color(0xFF171D2C),
          fontWeight: FontWeight.w500), // signup / signin
      headlineMedium: TextStyle(
          fontSize: 30,
          color: Color(0xFF171D2C),
          letterSpacing: -0.5,
          fontWeight: FontWeight.bold), // signup && sign in
      headlineSmall: TextStyle(
          fontSize: 15,
          color: Colors.blue,
          fontWeight: FontWeight.w400), // - homeScreen - orange
      titleLarge: TextStyle(
          fontSize: 15,
          color: Color(0xFF171D2C),
          fontWeight: FontWeight.w600), //-  home Screen
      titleMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w400), // listtile subtitle
      titleSmall: TextStyle(
          fontSize: 14,
          color: Color(0xFF565656),
          fontWeight: FontWeight.w600), // Listtile title
      bodySmall: TextStyle(
          fontSize: 25,
          color: Color(0xFF171D2C),
          fontWeight: FontWeight.bold), // verify, reset, forgot pwd,
      labelSmall: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600), // book appoinments

      labelLarge: TextStyle(
          fontSize: 13.5,
          color: Color(0xFF565656),
          fontWeight: FontWeight.w600),

      bodyLarge: TextStyle(
        fontSize: 13,
        color: Color(0xFF171D2C),
        fontWeight: FontWeight.w500,
      ), // home screen
      bodyMedium: TextStyle(
          fontSize: 12,
          color: Color(0xFF898A8D),
          fontWeight: FontWeight.w400), // home screen
    ),
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.grey[100],
      titleTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
    ),
    fontFamily: 'Poppins',
    dividerColor: Colors.transparent,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      height: 50,
      buttonColor: Colors.blue,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      disabledColor: Colors.grey,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: EdgeInsets.all(0),
      shadowColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
    disabledColor: Colors.grey,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(8),
      alignLabelWithHint: true,
      hintStyle: TextStyle(
        fontSize: 15,
        color: Color(0xFF898A8D),
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(width: 0.2, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Color(0xFF898A8D).withOpacity(0.2)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      filled: true,
      fillColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF171D2C),
      selectedIconTheme: IconThemeData(color: Colors.blue, size: 26),
      unselectedIconTheme: IconThemeData(color: Color(0xFF898A8D), size: 26),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: Color(0xFF171D2C), size: 30),
      iconTheme: IconThemeData(color: Color(0xFF171D2C), size: 30),
      titleTextStyle: TextStyle(
          fontSize: 17,
          color: Color(0xFF171D2C),
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins'),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.blue,
        ),
        textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
      backgroundColor: MaterialStateProperty.all(Colors.blue),
      shadowColor: MaterialStateProperty.all(Colors.white),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      )),
      textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400)),
    )),
    iconTheme: IconThemeData(color: Color(0xFF898A8D)),

    tabBarTheme: TabBarTheme(
      labelPadding: EdgeInsets.only(bottom: 3),
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
          fontSize: 13.5,
          color: Color(0xFF171D2C),
          fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(
          fontSize: 13.5,
          color: Color(0xFF898A8D),
          fontWeight: FontWeight.w400),
    ),

    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF171D2C)),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF171D2C),
        contentTextStyle: TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
        behavior: SnackBarBehavior.fixed),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: MaterialColor(0xFF0195ff, color))
            .copyWith(secondary: Colors.blue),
  );
}
