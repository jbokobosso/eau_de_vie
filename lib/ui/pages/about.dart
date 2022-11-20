import 'package:app_version/app_version.dart';
import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/constants/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Future<void> _launchUrl() async {
    var url = Uri.parse(Globals.developerWebsite);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("A Propos")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(FileAssets.menuBanner),
          const Divider(),
          const SizedBox(height: 20.0),
          const Text(Globals.appName),
          kDebugMode ? const Text("version ${Globals.appVersion}") : const AppVersion(),
          const SizedBox(height: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Développé et designé par"),
              InkWell(
                  onTap: _launchUrl,
                  child: Text("SNOVICH", style: TextStyle(color: Theme.of(context).primaryColor),)
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}
