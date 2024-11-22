import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher_string.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text("""Finally your pain is over tuning a Floyd Rose Guitar... :)
        
Here is the video that explains the process.""",
                textAlign: TextAlign.center, style: textTheme.bodyLarge),
            InkWell(
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Youtube Video',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              onTap: () {}, //launchUrlString('https://www.example.com'),
            ),
            Text("""Textual Explanation:
1. You need to train the tuner for your guitar in the "Configure" page

2. After this you can tune your guitar easley in the "Floyd Rose" page. This process will ask you to play every note and then tells you what string may be tuned to what frequency.

                
                  """, textAlign: TextAlign.center, style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
