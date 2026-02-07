

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/Movie.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteChild.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteImage.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/ValueItemGlobal.dart';
import '../enums/Enums.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/Imh_Object.dart';
//import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/Utils.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';





class Globals
{

  // static late Directory directoryTemp; // (Android) /data/user/0/com.example.mhmovies/cache          (ISO) /var/mobile/Containers/Data/Application/262B246A-9C57-4A29-8D07-FCD537DA000C/Library/Caches
  // static late Directory directoryAppDocuments; // (Android) /data/user/0/com.example.mhmovies/app_flutter    (ISO) /var/mobile/Containers/Data/Application/262B246A-9C57-4A29-8D07-FCD537DA000C/Documents
  // static late Directory directoryDownloads; // (Android) /storage/emulated/0/Android/data/com.example.mhmovies/files/downloads,  (ISO) /var/mobile/Containers/Data/Application/E31BC894-C1B6-4BFA-B9A6-CFE832816675/Downloads
  // static late Directory directoryLibrary; // (Android) /data/user/0/com.example.mhmovies/files          (ISO) /var/mobile/Containers/Data/Application/262B246A-9C57-4A29-8D07-FCD537DA000C/Library/Application Support
  // static late Directory directoryExternalStorageDirectory; // /storage/emulated/0/Android/data/com.example.mhmovies/files/
  // static late String    mainApplicationDirectory;    // (Android) /data/user/0/com.meirhemed.mhnotes/databases

  //#region Properties
  static List<Map<String, dynamic>> tableStatuses = [];
  static List<Map<String, dynamic>> tableFilmTypes = [];
  static List<Map<String, dynamic>> tableActors = [];
  static List<Map<String, dynamic>> tableGenres = [];
  static List<Map<String, dynamic>> tableDirectors = [];
  static List<Map<String, dynamic>> tableWriters = [];
  static List<Map<String, dynamic>> tableEditors = [];
  static List<Map<String, dynamic>> tableMusicians = [];

  // Just to show Dialog message/ Snack
  static BuildContext?    context ;
  static List<NoteImage>  keepNoteImagesForCompare = [];
  static List<NoteChild>  keepChildesForCompare = [];
  static List<Widget>     g_databasesList = [];
  static String           g_settingID = '1';
  static int              g_earlyAlarmMinutes = 60;
  static int              g_buzzerMinutes = 20;
  static int              g_colorsPattern = 1;   // Colors.deepPurple
  static int              keepOld = 1;
  static String           g_mainDatabaseUrl = "mhnotes-mainsettingdb-default-rtdb.firebaseio.com";
  static String           g_mainDataName    = "mhnotes-mainsetting";
  static int?             g_defaultDatabaseID = null;
  static String           g_userEmail = "";                   // = "hemedmeir@gmail.com";          //"ronenhemed2@gmail.com"
  static String           g_userPassword = "";
  static bool             isWithDatabasesChange = true;
  static Color            g_mainMediumColor = const Color.fromRGBO(13, 39, 158, 1.0);
  static const String     setHtmlInitString = '<p dir="rtl" lang="he" style="text-align: right; font-size: 19px">';    //
  static bool             isLoading = true;

  //static bool             isRefreshFromOutside = false;
  //#endregion Properties



  static Future<void> init() async
  {
    //await initApplication();

    //Utils.MAIN_PATH = directoryAppDocuments.path;
  }

  static Future<void> setNotification(Object note, [Future<void> Function(Object receivedAction)? onNotificationActionReceived,
                                      Future<void> Function(Object receivedNotification)? onNotificationDisplayed,
                                      bool isCancelOldBefore = true]) async
  {

  }

  static Future<void> cancelNotification(Object object) async
  {

  }

  /// Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
  static List<ValueItemGlobal> getMultiSelectedItemsSeparatedStringToValueItemGlobals(CodeTableEn tableName, String selectedSeparatedValues)
  {
    List<ValueItemGlobal> selectedItems = [];

    if (selectedSeparatedValues.isEmpty)
    {
      return selectedItems;
    }

    List<Map<String, Object?>> mainTable = getCodeTableByName(tableName);

    List<String> items = selectedSeparatedValues.split(', ');

    for (String item in items)
    {
      try
      {
        if (item.isNotEmpty)
        {
          final List<Map<String, Object?>> foundValue = mainTable.where((e) => ((e['Description'] as String) == item)).toList();
          if (foundValue.isNotEmpty)
          {
            Map<String, Object?> chosen = foundValue.first;
            ValueItemGlobal valueItemGlobal = ValueItemGlobal(label: (chosen['Description'] as String), value: (chosen['ID'] as int).toString());

            selectedItems.add(valueItemGlobal);
          }
        }
      }
      catch (e)
      {
        print("Error in 'getSelectedItemsToMultiDropdown': \n $e");
      }
    }

    //controllerGenre.setSelectedOptions(selectedGenresOption);

    return selectedItems;
  }

  static List<ValueItemGlobal> getSingleSelectedItemToValueItemGlobal(Map<String, dynamic> items, int selectedValue)
  {
    List<ValueItemGlobal> selectedItems = [];


    List<MapEntry<String, Object?>> foundValue = items.entries.where((e) => int.parse(e.key) == selectedValue).toList();
    if (foundValue.isNotEmpty)
    {
      selectedItems.add(ValueItemGlobal(label: foundValue[0].value as String, value: foundValue[0].key));
    }

    return selectedItems;
  }

  static List< Map<String, dynamic> /*ValueItem<dynamic>*/> getItemsForMultiDropdown(CodeTableEn tableName)
  {
    List<Map<String, Object?>> list = getCodeTableByName(tableName);

    return mapItemsToComboValueItem(list);
  }

  static String getVersionName(BuildContext context) //async
  {
    String version = '4.0.2 (1)';

    // /*String ss = *//*await*/ DefaultAssetBundle.of(context).loadString('../pubspec.yaml');
    // Uri uri = Platform.script;    //.path;
    // String currentPath = Directory(uri.path).parent.absolute.path;
    // //dirname(Platform.script.toFilePath())
    // String pathToLoad = join(currentPath, 'pubspec.yaml');
    // File file =  File(pathToLoad);
    // file.open(mode: FileMode.read);
    // final String fileData = file.readAsStringSync();
    // final bundle = DefaultAssetBundle.of(context);


    /// version = fileData.split("version: ")[1].split("+")[0];
    // // or use root bundle if no BuildContext is available
    // //pathToLoad = 'pubspec.yaml';   //bundle.loadString('../pubspec.yaml');
    // String pathToLoad = '../pubspec.yaml';
    // final String fileData = File(pathToLoad).readAsStringSync();
    // version = fileData.split("version: ")[1].split("+")[0];
    // //Future<YamlMap> loadPubspec() async => loadYaml(await File(pathToYaml).readAsString());

    return version;
  }

  static List<Map<String, dynamic>> mapItemsToComboValueItem(List<Map<String, Object?>> list)    // /*ValueItem<dynamic>*/
  {
    List<Map<String, dynamic>> listResult = [];

    for (Map<String, Object?> item in list)
    {
      listResult.add({'id': item['ID'], 'label': item['Description'] as String});
      //listResult.add(ValueItem(label: item['Description'] as String, value: item['ID']));
    }
    //TODO: List<ValueItem> result = list.map((e) => ValueItem(label: e.keys.firstWhere((element) => (e['ID'] as String) == element), value: e['Description'])).toList();

    return listResult;
  }

  static List<Map<String, dynamic>> getCodeTableByName(CodeTableEn tableName)
  {
    List<Map<String, dynamic>> table;


    switch (tableName)
    {
      case CodeTableEn.StatuseTable:
        table = tableStatuses;
        break;

      case CodeTableEn.FilmTypesTable:
        table = tableFilmTypes;
        break;

      case CodeTableEn.ActorsTable:
        table = tableActors;
        break;

      case CodeTableEn.GenresTable:
        table = tableGenres;
        break;

      case CodeTableEn.DirectorsTable:
        table = tableDirectors;
        break;

      case CodeTableEn.EditorsTable:
        table = tableEditors;
        break;

      case CodeTableEn.WritersTable:
        table = tableWriters;
        break;

      case CodeTableEn.MusiciansTable:
        table = tableMusicians;
        break;
    }

    return table;
  }




  static /*Future<*/String/*>*/ getCodeTableDesc(int valueToSearch, CodeTableEn tableType) /*async*/
  {
    String result='';

    if (valueToSearch <=0 )
    {
      return result;
    }

    try
    {
      List<Map<String, dynamic>> table = getCodeTableByName(tableType);

      Map<String, dynamic> map = table.firstWhere((e) => e['ID'] == valueToSearch);

      if (map.isNotEmpty) {
        result = map['Description'] as String;
      }
    }
    on Exception catch (e)
    {
      print('$e');
    }
    // No specified type, handles all
    catch (e)
    {
      print('$e');;
    }


    return result;
  }

  static int getCodeTableID(String valueToSearch, CodeTableEn tableType)
  {
    int result = -1;

    if (valueToSearch.isEmpty)
    {
      return result;
    }

    List<Map<String, dynamic>> table = getCodeTableByName(tableType);

    List<Map<String, dynamic>> map = table.where((e) => (e['Description'] as String) == valueToSearch).toList();

    if (map.isNotEmpty)
    {
      result = map[0]['ID'] as int;
    }

    return result;
  }


  // static Future<void> setNotification(Movie note, [Future<void> Function(ReceivedAction receivedAction)? onNotificationActionReceived,
  //                                                 Future<void> Function(ReceivedNotification receivedNotification)? onNotificationDisplayed,
  //                                                 bool isCancelOldBefore = true]) async
  // {
  //
  //   // First, Cancel Notification object
  //   if (isCancelOldBefore)
  //   {
  //     await cancelNotification(note);
  //   }
  //
  //   if (note.DateDueToDate != null && note.DateDueToDate!.compareTo(DateTime.now()) == 1)
  //   {
  //     await NotificationHandle.createScheduleNewNotification(note.NoteID, note.Title, note.Description, note.DateDueToDate!, note.PriorityID, false);
  //
  //     if (onNotificationActionReceived != null)
  //     {
  //       NotificationHandle.onNotificationActionReceived = onNotificationActionReceived;
  //     }
  //
  //     if (onNotificationDisplayed != null)
  //     {
  //       NotificationHandle.onNotificationDisplayed = onNotificationDisplayed;
  //     }
  //
  //     // Have to delete. Indication there was a Notification
  //     //note.notificationHandleObject = NotificationHandle();
  //     // NotificationHandle notificationHandle = note.notificationHandleObject as NotificationHandle;
  //     // notificationHandle.onActionReceivedImplementation = onActionReceivedFunction;
  //     //note.setTimer(onEndResult);
  //   }
  // }
  //
  // /// Cancel Notification object
  // /// TODO: maybe to change the parameter to (int NoteID)
  // static Future<void> cancelNotification(Movie note) async
  // {
  //
  //   //if (note.notificationHandleObject != null)
  //   //{
  //     //NotificationHandle? notificationHandle = note.notificationHandleObject! as NotificationHandle;
  //     await NotificationHandle.cancelScheduleNotificationByID(note.NoteID);
  //     //notificationHandle.onActionReceivedImplementation = null;
  //     //notificationHandle = null;
  //     //note.notificationHandleObject = null;
  //   //}
  // }

  /// static Future<String> downloadAndSaveImageOnDisk(String url, String fileName) async
  // {
  //   var directory = await getApplicationDocumentsDirectory();
  //   var filePath = '${directory.path}/$fileName';
  //   var file = File(filePath);
  //
  //   if (!await file.exists())
  //   {
  //     var response = await http.get(Uri.parse(url));
  //     await file.writeAsBytes(response.bodyBytes);
  //   }
  //
  //   return filePath;
  // }

  /// Pick a file on disk, Save it's content data as bytes on download directory
  /// static Future<bool> loadImageSaveOnDisk() async
  // {
  //   bool result = false;
  //   File? sourceFile;
  //   String sourceFilePath;
  //
  //
  //   try
  //   {
  //     sourceFile = await showFilePicker();
  //
  //     if (sourceFile != null)
  //     {
  //       sourceFilePath = sourceFile.path;
  //     }
  //     else
  //     {
  //       return result;
  //     }
  //
  //
  //     //sourceFile = File(sourceFilePath);
  //     Directory sourceDirectory = sourceFile.parent;
  //     String sourceFileName = sourceFilePath.replaceAll('${sourceDirectory.path}/', '');
  //
  //     Directory targetDirectory = await getApplicationDocumentsDirectory();
  //     String targetFilePath = join(targetDirectory.path, sourceFileName);
  //
  //     File targetFile = File(targetFilePath);
  //
  //     if (await targetFile.exists())
  //     {
  //       targetFile.delete();
  //     }
  //
  //
  //     Uint8List? dataBytes = await getFileBytes(sourceFilePath);
  //
  //     targetFile = File(targetFilePath);
  //
  //     List<int> codesList = dataBytes as List<int>;
  //     targetFile = await targetFile.writeAsBytes(codesList);
  //
  //     result = true;
  //   }
  //   catch (e)
  //   {
  //     result=false;
  //     print(e);
  //   }
  //
  //
  //
  //   return result;
  // }

  // /// Get all Bytes from given file, return it as Bytes memory
  /// static Future<Uint8List?> getFileBytes(String filePath) async
  // {
  //   File sourceFile = File(filePath);
  //
  //   if (!await sourceFile.exists())
  //   {
  //     return null;
  //   }
  //
  //   Uint8List dataBytes = (await sourceFile.readAsBytes());
  //
  //   return dataBytes;
  // }

  /// static Future<File?> showFilePicker() async
  // {
  //   FilePickerResult? filePicked = await FilePicker.platform.pickFiles();
  //   File? sourceFile;
  //
  //   if (filePicked != null)
  //   {
  //     String sourceFilePath = filePicked.files.single.path!;
  //     sourceFile = File(sourceFilePath);
  //   }
  //   else
  //   {
  //     sourceFile = null;
  //   }
  //
  //   return sourceFile;
  // }

  /// Not in use
  /// Future<void> importNotesFromJsonAssetFile(BuildContext context, String fileName) async
  // {
  //   try
  //   {
  //     final jsonStrings = await DefaultAssetBundle.of(context).loadString('assets/data/$fileName');     // notes.json
  //     //final notes = MovieParser.parse(jsonStrings);
  //
  //     //this._objectsList.addAll(objectsList);
  //
  //
  //   }
  //   catch (e)
  //   {
  //     print('Error loading movie: $e');
  //   }
  // }

  static Widget getImageByListType(Movie movie) //async
  {
    late Widget image = const SizedBox();
    Widget? imageParse = null;



    if (movie.SelfLink.isNotEmpty)
    {
      imageParse = MainGlobals.extractUrl(movie.SelfLink, false);
      if (imageParse != null)
      {
        image = imageParse;
      }
    }
    else if (movie.ImagesLinks.any((e) => e.isNotEmpty))
    {
      for (int i = 0; i < movie.ImagesLinks.length; i++)
      {
        if (movie.ImagesLinks[i].isNotEmpty)
        {
          imageParse = MainGlobals.extractUrl(movie.ImagesLinks[i], false);
          if (imageParse != null)
          {
            image = imageParse;
            break;
          }
        }
      }
    }
    else if (movie.Images.isNotEmpty)
    {
      for (NoteImage item in movie.Images)
      {
        image = Image.memory(item.Image/*, width: 40.0, height: 40.0*/, filterQuality: FilterQuality.high, fit: BoxFit.fitHeight, scale: 1.0,);   // BoxFit.contain
        break;
      }
    }
    else
    {
      const String imageName='listtype_task.png';
      image = const Image(image: AssetImage('assets/images/$imageName'), fit: BoxFit.fill, filterQuality: FilterQuality.high);
    }


    // try
    // {
    //   switch (movie.ListTypeID /*as NoteListTypeTypesEn*/)
    //   {
    //     case 1 /*NoteListTypeTypesEn.Reminder.value*/:
    //       imageName = 'listtype_reminder.png';
    //       break;
    //     case 2 /*NoteListTypeTypesEn.Note*/:
    //       imageName = 'note1.png';
    //       break;
    //     case 3 /*NoteListTypeTypesEn.Task*/:
    //       imageName = 'listtype_work.png';
    //       break;
    //     case 4 /*NoteListTypeTypesEn.Work*/:
    //       imageName = 'listtype_work.png';
    //       break;
    //     case 5 /*NoteListTypeTypesEn.Calendar*/:
    //       imageName = 'listtype_task.png';
    //       break;
    //     case 6 /*NoteListTypeTypesEn.ShopList*/:
    //       imageName = 'listtype_shoplist1.jpg';
    //       break;
    //     case 7 /*NoteListTypeTypesEn.Recipe*/:
    //       imageName = 'listtype_recipebook6.png';
    //       break;
    //     default:
    //       imageName = 'note1.png';
    //       break;
    //   }
    //
    //   image = Image(image: AssetImage('assets/images/$imageName'), fit: BoxFit.contain, filterQuality: FilterQuality.high);
    // }
    // catch (e)
    // {
    //   print('Error loading movie: $e');
    // }

    return image;
  }

  /// static Size getScreenSize(BuildContext context) //async
  // {
  //   var pixelRatio = window.devicePixelRatio;
  //
  //   //Size in physical pixels
  //   var physicalScreenSize = window.physicalSize;
  //   var physicalWidth = physicalScreenSize.width;
  //   var physicalHeight = physicalScreenSize.height;
  //
  //   //Size in logical pixels
  //   var logicalScreenSize = window.physicalSize / pixelRatio;
  //   var logicalWidth = logicalScreenSize.width;
  //   var logicalHeight = logicalScreenSize.height;
  //
  //   //logicalHeight = logicalHeight - 370.0;  // AppBar width, down buttons width
  //
  //   //Padding in physical pixels
  //   var padding = window.padding;
  //
  //   //Safe area paddings in logical pixels
  //   var paddingLeft = window.padding.left / window.devicePixelRatio;
  //   var paddingRight = window.padding.right / window.devicePixelRatio;
  //   var paddingTop = window.padding.top / window.devicePixelRatio;
  //   var paddingBottom = window.padding.bottom / window.devicePixelRatio;
  //
  //   //Safe area in logical pixels
  //   var safeWidth = logicalWidth - paddingLeft - paddingRight;
  //   var safeHeight = logicalHeight - paddingTop - paddingBottom;
  //
  //   double screenWidth = MediaQuery.sizeOf(context).width;
  //   double screenHeight = MediaQuery.sizeOf(context).height;
  //   // To get height just of SafeArea (for iOS 11 and above):
  //   var padding2 = MediaQuery.paddingOf(context);
  //   /*double newHeight*/ screenHeight = screenHeight - padding2.top - padding2.bottom;
  //
  //   Size size = Size(logicalWidth, logicalHeight);
  //
  //   return size;
  // }






  /// Elevation For Buttons
  /// static double getElevationForButtons(Set<MaterialState> states)
  // {
  //   const Set<MaterialState> interactiveStates = <MaterialState>{
  //     MaterialState.pressed,
  //     MaterialState.hovered,
  //     MaterialState.focused};
  //   if (states.any(interactiveStates.contains))
  //   {
  //     return 4.0;
  //   }
  //
  //   return 4.0;
  // }

  // /// Backcolor For Buttons

  /// static Color getColorForButtons(Set<MaterialState> states)
  // {
  //   const Set<MaterialState> interactiveStates = <MaterialState>{
  //     MaterialState.pressed,
  //     MaterialState.hovered,
  //     MaterialState.focused};
  //   if (states.any(interactiveStates.contains))
  //   {
  //     return Theme.of(context!).colorScheme.secondary;
  //   }
  //
  //   Color color = Theme.of(context!).colorScheme.inversePrimary;
  //
  //   return color;
  // }

  // /// Backcolor For Buttons

  /// static Color getColorForCheckBox(Set<MaterialState> states)
  // {
  //   const Set<MaterialState> interactiveStates = <MaterialState>{
  //     MaterialState.pressed,
  //     MaterialState.hovered,
  //     MaterialState.focused};
  //   if (states.any(interactiveStates.contains))
  //   {
  //     return Theme.of(context!).colorScheme.secondary;
  //   }
  //
  //   Color color = Theme.of(context!).colorScheme.primary;
  //
  //   return color;
  // }

  // static Future<Movie> addNewNote(String title, String desc) async
  // {
  //   Movie note = Movie(
  //     Title: title,
  //     Description: desc,
  //     DateDue: DateTime.now().add(const Duration(minutes: 30)).toLocal().toString(),
  //     ListTypeID: NoteListTypeTypesEn.Task.value,
  //     StatusID: NoteStatusEn.Open.value,
  //     PriorityID: NotePrioritiesEn.Normal.index,
  //     LastUpdateDate: DateTime.now().toLocal().toString(),
  //     SubTasks: [],
  //     SubjectLabels: '',
  //   );
  //
  //   return note;
  // }

  /// Set ListIndex property
  static Future<void> setListIndexProp(Object notes) async
  {
    int counter = 0;
    for (var note in notes as List<Object>)
    {
      counter++;
      (note as Imh_Object).ListIndex = counter;
    }
  }

  // static Future<void> keepNoteImages(Movie note) async
  // {
  //   keepNoteImagesForCompare.clear();
  //   keepChildesForCompare.clear();
  //
  //   for (NoteImage item in note.images)
  //   {
  //     NoteImage noteImage = NoteImage(NoteID: item.NoteID, Image: item.Image, FirebaseID: item.FirebaseID, ImageName: item.ImageName);
  //     keepNoteImagesForCompare.add(noteImage);
  //   }
  //
  //   for (NoteChild item in note.SubTasks)
  //   {
  //     NoteChild noteChild = NoteChild(NoteID: item.NoteID, Title: item.Title, IsDone: item.IsDone, FirebaseID: item.FirebaseID);
  //     keepChildesForCompare.add(noteChild);
  //   }
  // }




  static Future<bool> addChildsToNotes(List<NoteChild> imagesChilds, List<Movie> notes) async
  {
    bool result = false;


    try
    {
      imagesChilds.sort((a, b) => (a as Imh_Object).ObjectID.compareTo(b.NoteID));

      int i=0;
      int id=0;
      while (i < imagesChilds.length)
      {
        id = imagesChilds[i].NoteID;

        List<NoteChild> list = [];
        while((i < imagesChilds.length) && imagesChilds[i].NoteID == id)
        {
          list.add(imagesChilds[i]);
          i++;
        }
        // Search the right note into the images inside him
        List<Movie> foundNotes = notes.where((e) => (e as Imh_Object).ObjectID == id).toList();
        if (foundNotes.isNotEmpty)
        {
          final Movie note = foundNotes[0];
          note.SubTasks = list;
        }
      }

      result = true;
    }
    catch (e)
    {
      result = false;
    }

    return result;
  }

  static ColorScheme get applicationColorScheme
  {
    final Color applicationMainColor = MainGlobals.translateMainColor();
    ColorScheme colorScheme;

    if (Globals.g_colorsPattern == 1)
    {
      colorScheme = ColorScheme.fromSeed(
                                  seedColor: applicationMainColor,
                                  inversePrimary: Color.fromRGBO(153, 202, 248, 1.0)/*.withOpacity(0.9)*/,      // Color.fromRGBO(27, 139, 245, 1.0),
                    );

      // colorScheme = ColorScheme(/*.fromSeed*/
      //                             //seedColor: applicationMainColor,
      //                             primary: applicationMainColor,
      //                             inversePrimary: Color.fromRGBO(122, 143, 240, 0.5),
      //                             primaryContainer: Color.fromRGBO(140, 151, 207, 1.0),
      //                             secondary: Color.fromRGBO(25, 49, 175, 1.0),
      //                             secondaryContainer: Color.fromRGBO(140, 151, 207, 0.5),
      //                             brightness: Brightness.light,
      //                             onPrimary: applicationMainColor,
      //                             onSecondary: Color.fromRGBO(140, 151, 207, 1.0),
      //                             onError: Colors.red, error: Colors.red,
      //                             surface: Color.fromRGBO(140, 151, 207, 0.5),
      //                             onSurface: Color.fromRGBO(140, 151, 207, 0.5),);
    }
    else
    {
      colorScheme = ColorScheme.fromSeed(seedColor: applicationMainColor);
    }

    return colorScheme;
  }


  // Widget?  getDrawer()
  // {
  //
  //   if (!Globals.isMainInitApplicationLoaded)
  //   {
  //     return const SizedBox();
  //   }
  //
  //   final List<Widget> result = _createDatabasesListItems(this.DataProvider.dataBases);
  //
  //   return
  //
  //     Drawer(
  //       child:
  //       ListView(   //.builder(
  //         physics: const BouncingScrollPhysics(),   // ClampingScrollPhysics(),mNeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         scrollDirection: Axis.vertical,
  //         //itemCount: DatabasesListTiles.length,
  //
  //         children:
  //         result,   //listTiles,
  //
  //       ),
  //     );
  // }

/// static Future<void> showErrorMessage(Exception exception, [String message = '']) async
// {
//   showAlertDialog(context!, 'קרתה תקלה', (message.isNotEmpty ? '$message\n' : '') + exception.toString());
// }

/// Set date in israel format, remove zeros
/// static String setDateFormat(String dateString)
// {
//   String result = dateString;
//   List<String> list = dateString.split(' ');
//
//   if (list.length>1)
//   {
//     String date;
//     String time;
//     if (list[0].contains(':'))
//     {
//       date = setDateReversFormat(list[1]);
//       time = list[0];
//     }
//     else
//     {
//       date = setDateReversFormat(list[0]);
//       time = list[1];
//     }
//     time = time.substring(0, 5);
//     result = '$date  $time';
//   }
//   else
//   {
//     result = dateString.replaceFirst(':00.000', '');
//     result = setDateReversFormat(result);
//   }
//
//   return result;
// }

/// static Future<AlertDialogResultEn?> showAlertDialog(BuildContext context, String title, String message, [AlertDialogOptionEn? options = AlertDialogOptionEn.Close, List<String> buttonsCaption = const []]) async
// {
//   AlertDialogResultEn? result = AlertDialogResultEn.OK;
//   String titleOkButton ='כן';
//   String titleCancelButton ='לא';
//
//
//   switch (options)
//   {
//     case AlertDialogOptionEn.Close:
//       {
//         titleOkButton = 'סגור';
//         titleCancelButton='';
//       }
//       break;
//     case AlertDialogOptionEn.YesNo:
//       {
//         // TODO: Handle this case.
//         titleOkButton = 'כן';
//         titleCancelButton = 'לא';
//         break;
//       }
//     case AlertDialogOptionEn.AcceptDinied:
//       {
//         // TODO: Handle this case.
//         titleOkButton = 'אישור';
//         titleCancelButton = 'ביטול';
//         break;
//       }
//     case null:
//       // TODO: Handle this case.
//   }
//
//   if (buttonsCaption.isNotEmpty)
//   {
//     titleOkButton = buttonsCaption[0];
//     titleCancelButton=buttonsCaption[1];
//   }
//
//   Widget  okTextWidget = Text(titleOkButton, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: const TextStyle(color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.w600));
//
//   // set up the buttons
//   // TextButton okButton = TextButton(
//   //                         child: okTextWidget),
//   //                         onPressed: ()
//   //                         {
//   //                           result = AlertDialogResultEn.Yes;
//   //                           Navigator.of(context).pop();
//   //                           return;
//   //                         },
//   //                       );
//
//   CupertinoDialogAction  okButton = CupertinoDialogAction(
//                                       child: okTextWidget,
//                                       onPressed: ()
//                                       {
//                                         switch (options)
//                                         {
//                                           case AlertDialogOptionEn.Close:
//                                             {
//                                               result = AlertDialogResultEn.Close;
//                                             }
//                                             break;
//                                           case AlertDialogOptionEn.YesNo:
//                                             {
//                                               result = AlertDialogResultEn.Yes;
//                                               break;
//                                             }
//                                           case AlertDialogOptionEn.AcceptDinied:
//                                             {
//                                               result = AlertDialogResultEn.Accept;
//                                               break;
//                                             }
//                                           default:
//                                             result = AlertDialogResultEn.Close;
//                                         }
//                                         Navigator.of(context).pop();
//                                         return;
//                                       },
//                                     );
//
//
//   CupertinoDialogAction?  cancelButton;
//   // TextButton cancelButton;
//
//   if (titleCancelButton.isNotEmpty)
//   {
//     Widget cancelTextWidget = Text(titleCancelButton, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: const TextStyle(color: Colors.red, fontSize: 18.0, fontWeight: FontWeight.w600));
//
//     // TextButton cancelButton = TextButton(
//     //                             child: cancelTextWidget,
//     //                             onPressed: ()
//     //                             {
//     //                               result = AlertDialogResultEn.No;
//     //                               Navigator.of(context).pop();
//     //                               return;
//     //                             },
//     // );
//
//     cancelButton = CupertinoDialogAction(child: cancelTextWidget,
//                                               onPressed: ()
//                                               {
//                                                 switch (options)
//                                                 {
//                                                   case AlertDialogOptionEn.YesNo:
//                                                     {
//                                                       result = AlertDialogResultEn.No;
//                                                       break;
//                                                     }
//                                                   case AlertDialogOptionEn.AcceptDinied:
//                                                     {
//                                                       result = AlertDialogResultEn.Dinied;
//                                                       break;
//                                                     }
//                                                   default:
//                                                     result = AlertDialogResultEn.Close;
//                                                 }
//                                                 Navigator.of(context).pop();
//                                                 return;
//                                               },
//     );
//   }
//
//
//   // set up the AlertDialog
//   // AlertDialog alertAndroid = AlertDialog(
//   //                               title: Text(title,
//   //                                           textAlign: TextAlign.right,
//   //                                           textDirection: TextDirection.rtl,
//   //                                           style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color.fromRGBO(73, 66, 69, 1.0))
//   //                                       ),
//   //
//   //                               content:
//   //                                 SingleChildScrollView(
//   //                                   child:
//   //                                   //ListBody(
//   //                                   //   children: <Widget>[
//   //                                       Text(message,
//   //                                           textAlign: TextAlign.right, textDirection: TextDirection.rtl,
//   //                                           style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.w800, color: Colors.black)),
//   //                                     //],
//   //                                   //),
//   //                                 ),
//   //
//   //   actions: <Widget>[
//   //     okButton,
//   //     if (options != AlertDialogOptionEn.Close) cancelButton
//   //   ],
//   // );
//
//
//   CupertinoAlertDialog alertISO = CupertinoAlertDialog(
//                                     title: Text(title,
//                                                 textAlign: TextAlign.center,
//                                                 textDirection: TextDirection.rtl,
//                                                 style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Color.fromRGBO(73, 66, 69, 1.0))
//                                               ),
//
//                                     content:
//                                       SingleChildScrollView(
//                                         child:
//                                             Column(
//                                               children:
//                                               [
//                                                 //Image.asset('assets/images/Gif/gorilla-66_256.gif', height: 100.0, width:100.0, fit: BoxFit.fill),
//                                                 Image.asset('assets/images/Gif/cartoon-562_256.gif', height: 100.0, width:100.0, fit: BoxFit.fill),   // cow-376_256.gif
//
//                                                 Text(message, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color.fromRGBO(73, 66, 69, 1.0))),
//                                               ],
//                                             )
//
//                                       ),
//
//                                       actions: <Widget>[
//                                         okButton,
//
//                                         if (titleCancelButton.isNotEmpty)
//                                           cancelButton!
//                                       ],
//                                     //actionScrollController: scrollController,
//                                   );
//
//
//   // var result2 = await showDialog<AlertDialogResultEn?>(
//   //                         context: context,
//   //                         barrierDismissible: false, // Modal mode
//   //                         builder: (BuildContext context)
//   //                         {
//   //                           return alertAndroid;
//   //                         }
//   // );
//
//   /*var result2 =*/  await showCupertinoDialog<AlertDialogResultEn?>(
//                               context: context,
//                               barrierDismissible: false, // Modal mode
//                               builder: (BuildContext context)
//                               {
//                                 return alertISO;
//                               }
//   );
//
//   return result;
// }
//
/// static Future<DateTime?> showDatePickerDialog(BuildContext context, DateTime? currDate) async
// {
//
//   DatePickerDialog picker = DatePickerDialog(
//                                 restorationId: 'date_picker_dialog',
//                                 initialEntryMode: DatePickerEntryMode.calendar,
//                                 initialDate: currDate,
//                                 confirmText: 'אישור',
//                                 cancelText: 'ביטול',
//                                 helpText: 'בחר תאריך',
//                                 fieldLabelText: 'בחר תאריך',
//                                 keyboardType: TextInputType.datetime,
//                                 //currentDate: currDate,
//                                 firstDate: DateTime(1900, 1, 1),
//                                 lastDate: DateTime(3000, 1, 1)
//                             );
//
//
//   DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   barrierDismissible: false,    // Modal mode
//                                   textDirection: TextDirection.rtl,
//                                   keyboardType: TextInputType.datetime,
//                                   initialDate: currDate,
//                                   //currentDate: currDate,
//                                   firstDate: DateTime(1900),
//                                   lastDate: DateTime(3000),
//                                   builder: (BuildContext context, Widget? widget)
//                                   {
//                                     return picker;
//                                   });
//
//
//   // assert(debugCheckHasMaterial(context));
//   // assert(debugCheckHasMaterialLocalizations(context));
//   // assert(debugCheckHasDirectionality(context));
//
//   // CupertinoDatePicker picker2 = CupertinoDatePicker(
//   //                                 mode: CupertinoDatePickerMode.dateAndTime,
//   //                                 initialDateTime: DateTime(1969, 1, 1, 11, 33),
//   //                                 onDateTimeChanged: (DateTime newDateTime)
//   //                                 {
//   //                                   //Do Some thing
//   //                                 },
//   //                                 use24hFormat: true,
//   //                                 minuteInterval: 5,
//   //                               );
//
//   // showCupertinoDialog(
//   //       context: context,
//   //       builder: picker2),
//
//
//   return pickedDate;
// }

// https://pub.dev/packages/calendar_date_picker2

/// static Future<TimeOfDay?> showTimePickerDialog(BuildContext context, TimeOfDay? currDate) async
// {
//   TimePickerDialog timePicker = TimePickerDialog(
//                                     restorationId: 'time_picker_dialog',
//                                     initialEntryMode: TimePickerEntryMode.dial,
//                                     initialTime: currDate!,
//                                     minuteLabelText: 'דקות',
//                                     hourLabelText: 'שעות',
//                                     helpText: 'בחר זמן',
//                                     confirmText: 'אישור',
//                                     cancelText: 'ביטול',
//                                 );
//
//
//   TimeOfDay? pickedTime = await showTimePicker(
//                                     context: context,
//                                     initialTime: currDate,
//                                     builder: (BuildContext context, Widget? child)
//                                     {
//                                       return
//                                         MediaQuery(
//                                           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//                                           child: timePicker,    //child!,
//                                         );
//                                     },
//                                   );
//
//   return pickedTime;
//
// }

// static Future<AlertDialogResultEn> showAlarmMessage(BuildContext context, Movie note) async
// {
//   AlertDialogResultEn? result = await showAlertDialog(context, 'תזכורת', ':התרעה על משימה' + '\n' + note.Title + '\n' + note.Description, AlertDialogOptionEn.YesNo, ['נודניק', 'סגור']);
//
//   return result!;
// }

/// static Future<DateTime?> showCalendarWithMultiValues(BuildContext context, String title, List<DateTime?> datesValues) async
// {
//   datesValues = datesValues.map((e) => DateUtils.dateOnly(e!)).toList();
//   datesValues = datesValues.toSet().toList();   // distinct()
//
//   DateTime? result;
//   const dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w500);
//   const weekendTextStyle = TextStyle(color: Colors.grey, fontWeight: FontWeight.w800);
//   const selectedDate = TextStyle(color: Colors.green/*, backgroundColor: Colors.blueAccent*/, fontSize: 16.0, fontWeight: FontWeight.w900);
//   final anniversaryTextStyle = TextStyle(color: Colors.red[100], fontWeight: FontWeight.w600, decoration: TextDecoration.underline);
//   const monthTextStyle = TextStyle(color: Colors.green, fontWeight: FontWeight.w700);
//   Decoration decoration = BoxDecoration(
//       color: Colors.blueAccent.withOpacity(0.04),   // Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
//       border: Border.all(color: Theme.of(context).colorScheme.secondary),
//       borderRadius: const BorderRadius.all(Radius.circular(9.0))
//   );
//   // set up the buttons
//   Widget  okTextWidget = const Text('אישור', textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.w600));
//   TextButton okButton = TextButton(
//     child: okTextWidget,
//     onPressed: ()
//     {
//       result = result;
//       Navigator.of(context).pop();
//     },
//   );
//   Widget cancelTextWidget = const Text('ביטול', textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(color: Colors.red, fontSize: 16.0, fontWeight: FontWeight.w600));
//   TextButton cancelButton = TextButton(
//     child: cancelTextWidget,
//     onPressed: ()
//     {
//       result = null;
//       Navigator.of(context).pop();
//     },
//   );
//
//
//
//   // Widget calendarWidget3 = CalendarDatePicker(
//   //                               selectableDayPredicate: (date)
//   //                               {
//   //                                 return datesValues.contains(date);
//   //                               },
//   //                               initialDate: DateUtils.dateOnly(DateTime.now()),
//   //                               firstDate: DateTime(1900, 1, 1),
//   //                               lastDate: DateTime(3500, 12, 30),
//   //                               onDateChanged: (DateTime value)
//   //                               {
//   //                                 print('lala');
//   //                               },
//   // );
//
//   final config = CalendarDatePicker2Config(
//     disableMonthPicker: true,
//     calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
//     calendarType: CalendarDatePicker2Type.multi,
//     hideScrollViewMonthWeekHeader: true,
//     // closeDialogOnCancelTapped: true,
//     // closeDialogOnOkTapped: true,
//     //calendarViewMode: CalendarDatePicker2Mode.month,
//     firstDayOfWeek: 0,
//     //weekdayLabels: ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ש'],
//     weekdayLabelTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16.0, fontWeight: FontWeight.w700),
//
//     dayTextStyle: dayTextStyle,
//     selectedDayTextStyle: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal),
//     selectedDayHighlightColor: Colors.blueAccent,   // The Bubble background Color for All: pick Month, Pick Year
//
//     monthTextStyle: monthTextStyle,
//     selectedMonthTextStyle: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
//
//     yearTextStyle: const TextStyle(color: Colors.orange, fontSize: 16.0, fontWeight: FontWeight.bold),
//     selectedYearTextStyle: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
//
//     controlsTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16.0, fontWeight: FontWeight.bold),    // The Month choose color
//     todayTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16.0, fontWeight: FontWeight.w900),
//
//     // cancelButtonTextStyle: const TextStyle(color: Colors.red, fontSize: 16.0, fontWeight: FontWeight.w600),
//     // okButtonTextStyle: const TextStyle(color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.w600),
//     centerAlignModePicker: true,
//     customModePickerIcon: const SizedBox(),
//     dayTextStylePredicate: ({required date})
//     {
//       TextStyle? textStyle;
//       if (date.weekday == DateTime.saturday || date.weekday == DateTime.friday)
//       {
//         textStyle = weekendTextStyle;
//       }
//       if (DateUtils.isSameDay(date, DateTime(2021, 1, 25)))  // anniversary
//           {
//         textStyle = anniversaryTextStyle;
//       }
//       return textStyle;
//     },
//   );
//
//   bool isLoaded = false;
//
//   final config2 = CalendarDatePicker2WithActionButtonsConfig(
//     calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
//     calendarType: CalendarDatePicker2Type.single,   //multi,
//     calendarViewMode: CalendarDatePicker2Mode.day,
//     hideScrollViewMonthWeekHeader: true,
//     closeDialogOnCancelTapped: true,
//     closeDialogOnOkTapped: true,
//     firstDayOfWeek: 0,
//     //weekdayLabels: ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ש'],
//     weekdayLabelTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16.0, fontWeight: FontWeight.w700),
//
//     dayTextStyle: dayTextStyle,
//     selectedDayTextStyle: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal),
//     selectedDayHighlightColor: Colors.blueAccent,   // The Bubble background Color for All: pick Month, Pick Year
//
//     monthTextStyle: monthTextStyle,
//     selectedMonthTextStyle: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
//
//     yearTextStyle: const TextStyle(color: Colors.orange, fontSize: 16.0, fontWeight: FontWeight.bold),
//     selectedYearTextStyle: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
//
//     controlsTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16.0, fontWeight: FontWeight.bold),    // The Month choose color
//     todayTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16.0, fontWeight: FontWeight.w900),
//
//     centerAlignModePicker: true,
//     customModePickerIcon: const SizedBox(),
//     // okButton: okButton,
//     // cancelButton: cancelButton,
//     cancelButtonTextStyle: const TextStyle(color: Colors.red, fontSize: 16.0, fontWeight: FontWeight.w600),
//     okButtonTextStyle: const TextStyle(color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.w600),
//
//     dayTextStylePredicate: ({required date})
//     {
//       TextStyle? textStyle;
//       if (date.weekday == DateTime.saturday || date.weekday == DateTime.friday)
//       {
//         textStyle = weekendTextStyle;
//       }
//
//       if (datesValues.contains(date))
//       {
//         textStyle = selectedDate;
//       }
//
//       // Specific date
//       if (DateUtils.isSameDay(date, DateTime(2021, 1, 25)))
//       {
//         textStyle = anniversaryTextStyle;
//       }
//
//       return textStyle;
//     },
//
//     selectableDayPredicate: (date)
//     {
//       if (!datesValues.contains(date))
//       {
//         return true;
//       }
//       else
//       {
//         return true;  //TODO: have to be false - That the user will not UnSelect the given date
//       }
//     },
//
//     // dayBuilder: ({required date, textStyle, decoration, isSelected, isDisabled, isToday})
//     // {
//     //   Widget? dayWidget;
//     //
//     //   if (date.day % 3 == 0 && date.day % 9 != 0)
//     //   {
//     //     dayWidget =
//     //         Container(
//     //           decoration: decoration,
//     //           child:
//     //           Center(
//     //             child:
//     //             Stack(
//     //               alignment: AlignmentDirectional.center,
//     //               children:
//     //               [
//     //                 Text(MaterialLocalizations.of(context).formatDecimal(date.day), style: textStyle),
//     //
//     //                 Padding(
//     //                   padding: const EdgeInsets.only(top: 27.5),
//     //                   child:
//     //                   Container(
//     //                     height: 4,
//     //                     width: 4,
//     //                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: isSelected == true ? Colors.white : Colors.grey[500]),
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),
//     //           ),
//     //         );
//     //   }
//     //
//     //   return dayWidget;
//     // },
//     // yearBuilder: ({required year, decoration, isCurrentYear, isDisabled, isSelected, textStyle})
//     // {
//     //   return
//     //     Center(
//     //       child:
//     //       Container(
//     //         decoration: decoration,
//     //         height: 36,
//     //         width: 72,
//     //         child:
//     //         Center(
//     //           child: Semantics(
//     //             selected: isSelected,
//     //             button: true,
//     //             child: Row(
//     //               mainAxisAlignment: MainAxisAlignment.center,
//     //               children: [
//     //                 Text(
//     //                   year.toString(),
//     //                   style: textStyle,
//     //                 ),
//     //                 if (isCurrentYear == true)
//     //                   Container(
//     //                     padding: const EdgeInsets.all(5),
//     //                     margin: const EdgeInsets.only(left: 5),
//     //                     decoration: const BoxDecoration(
//     //                       shape: BoxShape.circle,
//     //                       color: Colors.redAccent,
//     //                     ),
//     //                   ),
//     //               ],
//     //             ),
//     //           ),
//     //         ),
//     //       ),
//     //     );
//     // },
//   );
//
//
//   Widget calendarWidget =
//   SizedBox(
//       width: 400.0,
//       height: 380.0,
//
//       child:
//       Container(
//         //alignment: Alignment.topRight,
//         padding: const EdgeInsets.all(1.0),
//         margin: const EdgeInsets.all(2.0),
//         //width: 600,
//         //height: 500,
//         decoration: decoration,
//
//         child:
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.start,
//           //mainAxisSize: MainAxisSize.max,
//           children:
//           [
//             //const SizedBox(height: 10),
//             //const Text('Multi Date Picker'),
//
//             CalendarDatePicker2(
//                 config: config,
//                 value: datesValues,
//                 onValueChanged: (dates)
//                 {
//                   //setState(() =
//                   List<DateTime> datesNew = dates;  //.map<DateTime>((e) => !datesValues.contains(e) ? e : null).toList();
//                   result = datesNew[0];
//                   Navigator.of(context).pop();
//                 }
//             ),
//
//             // const SizedBox(height: 20),
//             //
//             // Wrap(
//             //   children:
//             //   [
//             //     const Text('Selection(s):  '),
//             //     const SizedBox(width: 10),
//             //     Text(
//             //       _getValueText(
//             //         config.calendarType,
//             //         datesValues,
//             //       ),
//             //       overflow: TextOverflow.ellipsis,
//             //       maxLines: 1,
//             //       softWrap: false,
//             //     ),
//             //   ],
//             // ),
//
//             //const SizedBox(height: 25),
//           ],
//         ),
//       )
//   );
//
//
//   // AlertDialog alertDialog = AlertDialog(
//   //                               title: Text(title,
//   //                                         textAlign: TextAlign.right,
//   //                                         textDirection: TextDirection.rtl,
//   //                                         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color.fromRGBO(73, 66, 69, 1.0))
//   //                                       ),
//   //                               elevation: 0.5,
//   //                               shadowColor: Colors.blue,
//   //                               //backgroundColor: Colors.yellow,
//   //
//   //                               content: calendarWidget,
//   //
//   //                               actions: <Widget>
//   //                               [
//   //                                 okButton,
//   //                                 cancelButton
//   //                               ],
//   //                         );
//
//   // DateTime? result2 = await showDialog<DateTime?>(
//   //                         context: context,
//   //                         barrierDismissible: false, // Modal mode
//   //                         builder: (BuildContext context)
//   //                         {
//   //                           return calendarWidget;   // calendarWidget
//   //                         }
//   //                       );
//
//   // DateTime? pickedDate = await showDatePicker(
//   //                                 context: context,
//   //                                 textDirection: TextDirection.rtl,
//   //                                 keyboardType: TextInputType.datetime,
//   //                                 barrierDismissible: false, // Modal mode
//   //                                 initialDate: DateUtils.dateOnly(DateTime.now()),
//   //                                 //currentDate: currDate,
//   //                                 firstDate: DateTime(1900),
//   //                                 lastDate: DateTime(3000),
//   //                                 builder: (BuildContext context, Widget? widget)
//   //                                 {
//   //                                   return calendarWidget;    //alertDialog
//   //                                 });
//
//   // CalendarDatePicker2WithActionButtons calendarWidget2 = CalendarDatePicker2WithActionButtons(
//   //                                                   value: datesValues,
//   //                                                   config: config2,
//   //                                                   onValueChanged: (dates)
//   //                                                   {
//   //                                                     datesValues = dates;
//   //                                                   },
//   //                                                   onCancelTapped: (){},
//   //                                                   onOkTapped: (){}
//   //                                           );
//
//
//   List<DateTime?>?  calendarViewer = await showCalendarDatePicker2Dialog(
//     context: context,
//     config: config2,
//     dialogSize: const Size(325, 430),
//     borderRadius: BorderRadius.circular(10),
//     //value: datesValues,
//     barrierDismissible: false, // MODAL mode
//     dialogBackgroundColor: Colors.white,
//     // builder: (BuildContext context, Widget? widget)
//     // {
//     //     return widget!;
//     //     //return calendarWidget;
//     //     //return calendarWidget2;
//     // }
//   );
//   if (calendarViewer!=null && calendarViewer.isNotEmpty)
//   {
//     result = calendarViewer[0]; //calendarViewer?.firstWhere((e) => !datesValues.contains(e));
//   }
//
//   return result;
// }

/// static String setDateReversFormat(String date)
// {
//   String result = '';
//   List<String> list = date.split('-');
//
//   if (list.length<3)
//   {
//     return result;
//   }
//
//   result = '${list[2]}-${list[1]}-${list[0]}';
//
//   return result;
// }

/// When there is also youtube and also image url separated with ' # '
/// static Widget extractUrl(String url, bool takeForYoutube)
// {
//   Widget result = const SizedBox();
//   String urlWithYoutube = url;
//
//
//   try
//   {
//     // Check if link have url from Youtube
//     if (urlWithYoutube.toLowerCase().contains('youtu'))
//     {
//       List<String> splitedUrl = urlWithYoutube.split(' # ');
//       if (splitedUrl.isNotEmpty)
//       {
//         urlWithYoutube = splitedUrl.firstWhere((e) => e.toLowerCase().contains('youtu'));
//         if (takeForYoutube)
//         {
//           // result = SafeArea(
//           //             child
//           //
//           //               Browser(initialUriString: urlWithYoutube)
//           //);
//         }
//         else
//         {
//           result = Image.network(urlWithYoutube, scale: 1.0, fit: BoxFit.fill);
//         }
//         if (splitedUrl.length>1)
//         {
//           urlWithYoutube = splitedUrl.firstWhere((e) => !e.toLowerCase().contains('youtu'));
//           if (urlWithYoutube.isNotEmpty)
//           {
//             result = Image.network(urlWithYoutube, scale: 1.0, fit: BoxFit.fill);
//           }
//         }
//       }
//     }
//
//     // Normal link
//     else if (urlWithYoutube.toLowerCase().startsWith('http') || urlWithYoutube.toLowerCase().startsWith('www.'))    // urlWithYoutube.toLowerCase().contains(':image/jpeg')
//     {
//       result = Image.network(urlWithYoutube, scale: 1.0, fit: BoxFit.fill);
//     }
//     else
//     {
//       // Load File
//       File file = File(urlWithYoutube);
//       if (file.existsSync())
//       {
//         result = Image.file(file, scale: 1.0, fit: BoxFit.fill);
//       }
//       else
//       {
//         return result;
//       }
//     }
//   }
//   catch (e)
//   {
//     print('Error load image: $e');
//   }
//
//   return result;
// }

}

