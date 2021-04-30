import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactButton extends StatelessWidget {
  ContactButton({
    @required this.phoneNumber,
  });

  final phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.phone),
          color: Colors.indigo[900],
          onPressed: () async {
            String url = 'tel:' + phoneNumber;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.whatsapp),
          color: Colors.indigo[900],
          onPressed: () async {
            String url = 'https://api.whatsapp.com/send?phone=' + phoneNumber;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.sms),
          color: Colors.indigo[900],
          onPressed: () async {
            String url = 'sms:' + phoneNumber;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
      ],
    );
  }
}
