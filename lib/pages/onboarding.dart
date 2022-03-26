import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_fins/pages/home.dart';
import 'package:hive/hive.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage({Key? key}) : super(key: key);
  final box = Hive.box("box");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Text("Get started to analyze your finances"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (bc) {
                      String name = "";
                      return Dialog(
                        backgroundColor: Color(0xff252832),
                        insetPadding: EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Enter your name to continue"),
                              TextField(
                                onChanged: ((value) {
                                  name = value;
                                }),
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Enter your name",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.4)),
                                  label: Text(
                                    "Name",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (name == "") {
                                    return;
                                  }

                                  final box = Hive.box("box");
                                  box.put("name", name);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (bc) => HomePage()));
                                },
                                child: Text("Continue"),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
              child: Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}
