import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mi_calendario_lunar/pages/calendar_grid.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
        ),
        body: Center(
          child: Container(
            height: 311,
            width: 211,
            decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(12)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarGrid(),
                  ),
                );
              },
              child: SvgPicture.asset(
                "assets/svgs/haircut-svgrepo-com.svg",
                height: 33,
                width: 33,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
