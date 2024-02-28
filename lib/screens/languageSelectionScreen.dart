import 'package:app/l10n/l10n.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/provider/local_provider.dart';
import 'package:app/widgets/bottomNavigationWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatefulWidget {
  ChooseLanguageScreen({a, o}) : super();

  @override
  _ChooseLanguageScreenState createState() => new _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  bool isFavourite = false;
  late int selectedLangIndex;
  var locale;

  _ChooseLanguageScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Select Language'),
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await _setLang();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Set Language'),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: L10n.languageListName.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: RadioListTile(
                      value: L10n.all[index].languageCode,
                      groupValue: global.languageCode,
                      onChanged: (dynamic val) {
                        global.languageCode = val;
                        selectedLangIndex = index;

                        setState(() {});
                      },
                      title: Text(
                        L10n.languageListName[index],
                        style: Theme.of(context).primaryTextTheme.bodyText1,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  _setLang() {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BottomNavigationWidget()),
      );
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      locale = Locale(L10n.all[selectedLangIndex].languageCode);
      provider.setLocale(locale);
      global.languageCode = locale.languageCode;
      global.sp.setString('selectedLanguage', global.languageCode!);

      if (global.rtlLanguageCodeLList.contains(locale.languageCode)) {
        global.isRTL = true;
      } else {
        global.isRTL = false;
      }
      setState(() {});
    } catch (e) {
      print("Exception - languageSelectionScreen.dart - _setLang():" +
          e.toString());
    }
  }
}
