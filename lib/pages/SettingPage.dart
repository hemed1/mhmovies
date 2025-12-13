

import 'package:flutter/material.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataProvider.dart';
import '../models/Movie.dart';
import 'package:provider/src/provider.dart';
// import '../data/MoviesProvider.dart';
// import '../models/Note.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetLabel.dart';
import '../utils/Globals.dart';


enum SingingCharacter { purple, orange, green }


class SettingPage extends StatefulWidget
{
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}



class _SettingPageState extends State<SettingPage>
{

  //#region Variables
  TextEditingController controllerEarlyAlarm = TextEditingController();
  TextEditingController controllerBuzzerMinutes = TextEditingController();
  TextEditingController controllerMainDBUrl = TextEditingController();
  TextEditingController controllerLastDatabaseID = TextEditingController();
  bool isDatabaseListOpened = false;
  SingingCharacter _character = SingingCharacter.purple;
  late BuildContext _context;
  bool isFirstTime = true;
  //#endregion Variables

  @override
  void initState()
  {
    super.initState();
    // setControlsToObjects();
  }


  @override
  Widget build(BuildContext context)
  {
    _context = context;
    MainGlobals.context = context;

    if (isFirstTime)
    {
      isFirstTime = false;
      setControlsToObjects();
    }


    return

      Scaffold(
        appBar: AppBar(title: const Center(child: Text('מסך הגדרות',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          actions:
          [
            // Top Buttons
            SizedBox(width: 350.0, height: 40.0,
                child:
                Center(
                    child:
                    // Top Buttons
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children:
                        [
                          // Exit button
                          SizedBox(width: 120.0, //height: 30.0,
                            child:
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith(MainGlobals.getColorForButtons),
                                  elevation: MaterialStateProperty.resolveWith(MainGlobals.getElevationForButtons)),
                              icon: const Icon(Icons.delete, color: Colors.red,
                                  size: 28.0,
                                  fill: 1.0,
                                  textDirection: TextDirection.rtl),
                              label: const Text('ביטול', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16.0)),
                              onPressed: () async
                              {
                                Navigator.pop(context, null);
                              },
                            ),
                          ),


                          // Save button
                          SizedBox(width: 120.0, //, height: 40.0,
                            child:
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith(MainGlobals.getColorForButtons),
                                  elevation: MaterialStateProperty.resolveWith(MainGlobals.getElevationForButtons)),
                              icon: const Icon(Icons.save, color: Colors.green,
                                  size: 28.0,
                                  fill: 1.0,
                                  textDirection: TextDirection.rtl),
                              label: const Text('שמור', style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16.0)),
                              onPressed: () async
                              {
                                await saveItems();
                              },
                            ),
                          ),
                        ]
                    ))),
          ],
        ),

        // backgroundColor: Colors.white60,   //Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),

        body:
        Directionality(
          textDirection: TextDirection.rtl,
          child:
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            child:
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                textDirection: TextDirection.rtl,
                children:
                [
                  // התראה מוקדמת
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
                        WidgetLabel(caption: 'דקות למוקדמת', inputType:TextInputType.number, width: 120.0, maxLength: null, controller: controllerEarlyAlarm),
                      ]),

                  const SizedBox(height: 10.0),

                  // דקות לנודניק'
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
                        WidgetLabel(caption: 'דקות לנודניק', inputType:TextInputType.number, width: 120.0, maxLength: null, controller: controllerBuzzerMinutes),
                      ]),

                  const SizedBox(height: 10.0),

                  // מסד-נתונים אחרון
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                    [
                      WidgetLabel(caption: 'מסד-נתונים אחרון', inputType:TextInputType.number, width: 120.0, maxLength: null, controller: controllerLastDatabaseID,
                          onTop: ()
                          {
                            isDatabaseListOpened = !isDatabaseListOpened;
                            setState(() {});
                          }),
                    ],
                  ),

                  const SizedBox(height: 10.0),

                  // כתובת מסד-נתונים
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                    [
                      WidgetLabel(caption: 'כתובת מסד-נתונים', inputType:TextInputType.text, width: 350.0, maxLength: null, controller: controllerMainDBUrl),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  Text('צבע מערכת', style: TextStyle(color: Theme.of(context).colorScheme.primary),),

                  // Color
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                    [
                      SizedBox(width: 200.0, height: 130.0,
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>
                            [
                              SizedBox(height: 40.0,
                                  child:
                                  ListTile(
                                      title: const Text('סגול'),
                                      trailing: const ColoredBox(color: Colors.deepPurple,child: Text('     ')),
                                      leading: Radio<SingingCharacter>(
                                          value: SingingCharacter.purple,
                                          groupValue: _character,
                                          onChanged: (SingingCharacter? value)
                                          {
                                            setState(()
                                            {
                                              _character = value!;
                                            });
                                          }))),

                              SizedBox(height: 40.0,
                                  child:
                                  ListTile(
                                      title: const Text('כחול'),
                                      trailing: ColoredBox(color: Globals.g_mainMediumColor, child: Text('     ')),
                                      leading: Radio<SingingCharacter>(
                                          value: SingingCharacter.orange,
                                          groupValue: _character,
                                          onChanged: (SingingCharacter? value)
                                          {
                                            setState(()
                                            {
                                              _character = value!;
                                            });
                                          }))),

                              SizedBox(height: 40.0,
                                  child:
                                  ListTile(
                                      title: const Text('ירוק'),
                                      trailing: const ColoredBox(color: Colors.green,child: Text('     ')),
                                      leading: Radio<SingingCharacter>(
                                          value: SingingCharacter.green,
                                          groupValue: _character,
                                          onChanged: (SingingCharacter? value)
                                          {
                                            setState(()
                                            {
                                              _character = value!;
                                            });
                                          }))),
                            ]
                        ),
                      ),
                    ],
                  ),


                  // מסד-נתונים אחרון
                  (isDatabaseListOpened)
                      ? SizedBox(width: 300.0,
                      child:
                      Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                        margin:  const EdgeInsets.only(left: 0.0, right: 0.0, top:0.0, bottom: 0.0),
                        // width: (this.width + 120.0),
                        // height: this.height,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
                            //border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(7.0))),
                        child:
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: TextDirection.rtl,
                          children:
                          [
                            const Text('מסד-נתונים אחרון', textAlign: TextAlign.left, textDirection: TextDirection.ltr),

                            ListView.builder(
                                itemCount: Globals.g_databasesList.length,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index)
                                {
                                  return
                                    ListTile(
                                      title: Globals.g_databasesList[index],
                                      onTap: ()
                                      {
                                        controllerLastDatabaseID.text = index.toString();
                                        isDatabaseListOpened = false;
                                        // setState(() {
                                        //
                                        // });
                                      },
                                    );
                                }
                            ),
                          ],
                        ),
                      ))

                      : const SizedBox()

                ]
            ),
          ),
        ),

      );
  }

  void setControlsToObjects()
  {
    // /*await */this.DataProvider.readSettings();

    controllerEarlyAlarm.text = Globals.g_earlyAlarmMinutes.toString();
    controllerBuzzerMinutes.text = Globals.g_buzzerMinutes.toString();
    controllerMainDBUrl.text = Globals.g_mainDatabaseUrl;
    controllerLastDatabaseID.text = (Globals.g_defaultDatabaseID!=null) ? Globals.g_defaultDatabaseID!.toString() : '';

    if (Globals.g_colorsPattern==0)
    {
      _character = SingingCharacter.purple;
    }
    else if (Globals.g_colorsPattern==1)
    {
      _character = SingingCharacter.orange;
    }
    else
    {
      _character = SingingCharacter.green;
    }
  }

  Future<void> setObjectsToControls() async
  {
    Globals.g_earlyAlarmMinutes = int.parse(controllerEarlyAlarm.text);
    Globals.g_buzzerMinutes = int.parse(controllerBuzzerMinutes.text);
    Globals.g_mainDatabaseUrl = controllerMainDBUrl.text;
    Globals.g_defaultDatabaseID = (controllerLastDatabaseID.text.isNotEmpty) ? int.parse(controllerLastDatabaseID.text) : null;
    Globals.g_colorsPattern = _character.index;
  }

  Future<void> saveItems() async
  {
    bool result = false;
    Map<String, Object?> values = {};

    // Just to check if there is any record
    List<Map<String, Object?>>? table = await this.dataProvider.DatabaseHelper.readTable('TBL_Settings');

    await setObjectsToControls();

    if (table.isNotEmpty)
    {
      result = await this.dataProvider.saveSettings(2);
    }
    else
    {
      result = await this.dataProvider.saveSettings(1);
    }


    if (result)
    {
      MainGlobals.showSnackBar(_context, 'הנתונים נשמרו בהצלחה');
    }
    else
    {
      MainGlobals.showSnackBar(_context, 'הנתונים לא נשמרו');
    }

    Navigator.pop(_context, true);
  }

  /// Property of Provider
  DataProvider get dataProvider
  {
    DataProvider<Movie> notesProvider = Provider.of<DataProvider<Movie>>(_context, listen: false);
    notesProvider.context = _context;
    // notesProvider.onNotificationActionReceived = this.onNotificationActionReceived;
    // notesProvider.onNotificationDisplayed = this.onNotificationDisplayed;
    //notesProvider.onShowMessage = ShowMessage;
    return notesProvider;
  }
}