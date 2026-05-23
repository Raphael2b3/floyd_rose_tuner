import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/guitar_state_view.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Welcome",
          style: textTheme.titleLarge,
          //textAlign: TextAlign.center,
        ),
        Text(
          """This app is designed to tune your Floyd-Rose-Guitar as fast as possible.""",
          //textAlign: TextAlign.center,
          style: textTheme.bodyLarge,
        ),
        Divider(),
        GuitarStateView(
          GuitarState(values: [88.32, 112.3, 155.3, 222.3, 280.3, 330.2]),
        ),
        Divider(),
        Text("What are these numbers?", style: textTheme.titleMedium),

        Text(
          "Every string on your guitar vibrates at a specific speed when plucked — that's its frequency. "
          "The numbers you see are just that: how fast your string is vibrating right now. "
          "The vibration is measured in Hertz (Hz).",
        ),
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
            bool result = await launchUrl(
              Uri.parse("https://www.youtube.com/watch?v=xvFZjo5PgG0"),
            );
            if (!result) {
              throw 'Could not launch ';
            } else {
              print("Launched");
            }
          }, //,
        ),
      ],
    );
  }
}
