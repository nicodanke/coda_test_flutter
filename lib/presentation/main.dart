import 'package:binder/binder.dart';
import 'package:coda_flutter_test/presentation/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodaApp extends StatelessWidget {
  const CodaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BinderScope(
      child: MaterialApp(
        initialRoute: PageRoutes.login,
        theme: ThemeData(
          // Text Style
          textTheme: GoogleFonts.dmSansTextTheme(
            Theme.of(context).textTheme,
          ),
          // TextField Styles
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            labelStyle: TextStyle(color: Colors.grey.shade800),
            contentPadding: EdgeInsets.zero,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 1,
                color: Colors.grey.shade500,
              )
            )
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.grey.shade700,
            selectionColor: Colors.grey.shade700,
            selectionHandleColor: Colors.grey.shade700,
          ),

          // ElevatedButton Styles
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(letterSpacing: 0.5),
              primary: Colors.white,
              backgroundColor: Colors.grey.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              )
            ),
          ),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
