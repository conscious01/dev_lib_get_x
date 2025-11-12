import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._();

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),

      textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
    ),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(double.infinity, 50.h),
      side: BorderSide(color: Colors.grey.shade300),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,

    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100],

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),

    cardColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[600],
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedButtonTheme.style?.copyWith(
        backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
      ),
    ),
    outlinedButtonTheme: _outlinedButtonTheme,

    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900],

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      foregroundColor: Colors.white,
    ),

    cardColor: Colors.grey[800],

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      selectedItemColor: Colors.blue[300],
      unselectedItemColor: Colors.grey[400],
    ),
  );
}
