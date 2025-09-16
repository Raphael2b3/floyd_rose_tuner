
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return SizedBox.expand(

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: textTheme.titleLarge,
                //textAlign: TextAlign.center,
              ),
              Text("""This app is designed to tune your Floyd-Rose-Guitar as fast as possible.""",
                  //textAlign: TextAlign.center,
                  style: textTheme.bodyLarge),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Tutorial Video',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () async {
                  var result = await launchUrl(Uri.parse("https://www.youtube.com/watch?v=xvFZjo5PgG0"));
                    if (!result) {
                      throw 'Could not launch ';
                    }
                    else{
                      print("Launched");
                    }
                  }, //,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
