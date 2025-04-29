import 'package:flutter/material.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Center(
                child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 12.0, end: 30.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.bounceOut,
                    builder: (BuildContext context, dynamic value, Widget? child) {
                        return Text("Halaman tidak ditemukan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: value));
                      }
                    )

                ),
              ),
          ],
        ),
      ),
    );
  }
}