
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../enums/Enums.dart';
import '../pages/SettingPage.dart';
import '../utils/MovieDetailsPageArguments.dart';
import '../utils/Globals.dart';
import '../models/Movie.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetHomePage.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetRichText.dart';
// import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NotificationHandle.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/ValueItemGlobal.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/DatabaseHandlePage.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/Imh_Object.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataBase.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataProvider.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NetworkHttp.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteImage.dart';
import 'package:kat_html_editor/kat_html_editor.dart';
// import 'package:provider/src/provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
// https://pub.dev/documentation/flutter_screen_wake/latest/
//import 'package:flutter_screen_wake/flutter_screen_wake.dart';
// https://pub.dev/documentation/flutter_screen_wake/latest/
// https://pub.dev/packages/multi_dropdown
// https://stackoverflow.com/questions/76184194/how-can-i-remove-a-specific-developer-identity-from-my-system-when-creating-flut




class HomePage<T> extends StatefulWidget
{
  // static Future<void> Function()? onLoadInitAppRefresh;
  late _HomePageState<T>? homePageState;
  bool isSelectMode = false;
  /*const*/ HomePage({super.key});


  @override
  State<HomePage> createState()
  {
    this.homePageState = _HomePageState<T>();
    return this.homePageState!;
  }
}



class _HomePageState<T> extends State<HomePage>   //implements ListView_Extend
{

  //#region Variables
  String title = 'רשימת כל פריטים';
  Map<String, dynamic> list  = {};
  List<T> _mainList = [];   // The Main list of Notes
  List<Widget> listTiles = [];
  late BuildContext _context = context;
  bool isFirstTime = true;
  bool isEarlyAlarm = false;
  NotesOrderByEn currentOrder = NotesOrderByEn.DateDue;
  NotesOrderDirectionByEn currentOrderDirection = NotesOrderDirectionByEn.ascending;
  String currentFilter = NoteFilterModeEn.allWithOutArchive.value;
  Object? currentFilterValue;
  late WidgetHomePage? widgetHomePage = null;
  double keepScrollPosition = 0;
  int    keepScrollerIndex = 0;
  double screenHeight = 600.0;  // AppBar width, down buttons width
  double screenWidth = 800.0;
  late double LINE_WIDTH;


  @override
  bool IsExternalListItemTile = true;   // Because we want `favorite icon in 'trailing' prop

  final Map<String, dynamic>  _filterDropdownValueItemsDefault =
  {
    NoteFilterModeEn.all.value : NoteFilterModeEn.all.value,
    NoteFilterModeEn.allWithOutArchive.value :NoteFilterModeEn.allWithOutArchive.value,
    NoteFilterModeEn.today.value : NoteFilterModeEn.today.value,
    NoteFilterModeEn.typeNote.value : "פתקים",
    NoteFilterModeEn.typeTask.value : "משימות",
    NoteFilterModeEn.statusCompleted.value : NoteFilterModeEn.statusCompleted.value,
    NoteFilterModeEn.statusNoDone.value : NoteFilterModeEn.statusNoDone.value,
    NoteFilterModeEn.subjects.value : NoteFilterModeEn.subjects.value,
    NoteFilterModeEn.dateDue.value : NoteFilterModeEn.dateDue.value,
    NoteFilterModeEn.dateDueWithOut.value : NoteFilterModeEn.dateDueWithOut.value,
    NoteFilterModeEn.typeReminder.value : NoteFilterModeEn.typeReminder.value,
    NoteFilterModeEn.statusInArchive.value : 'בארכיון',
    NoteFilterModeEn.statusPartCompleted.value : NoteFilterModeEn.statusPartCompleted.value,
    NoteFilterModeEn.typeRecipe.value : "מתכונים",
    NoteFilterModeEn.typeWork.value : NoteFilterModeEn.typeWork.value,
    NoteFilterModeEn.typeShopList.value : "רשימת-קניות",
    NoteFilterModeEn.typeCalendar.value : "אירועים ביומן",
    NoteFilterModeEn.specificDay.value : NoteFilterModeEn.specificDay.value,
  } ;
  //#endregion Variables



  @override
  void initState()
  {
    super.initState();
    MainGlobals.g_physicalScreenSize = MainGlobals.getScreenSize(_context);      //WidgetsBinding.instance.window.physicalSize;
    screenHeight = MainGlobals.g_physicalScreenSize.height - 380.0;  // AppBar width, down buttons width  //((size.height > 1500.0) ? 1100.0 : 0.0);    //405; 340   //((size.height > 2500.0) ? 2290.0 : 0.0);  // AppBar width, down buttons width
    screenWidth  = MainGlobals.g_physicalScreenSize.width  + 147.0;
    LINE_WIDTH    = MainGlobals.g_physicalScreenSize.width - 132.0;
  }



  @override
  Widget build(BuildContext context)
  {
    _context = context;
    MainGlobals.context = context;
    Globals.context = context;



    if (isFirstTime)
    {
      isFirstTime = false;
    }


    widgetHomePage = WidgetHomePage<T, DataProvider<T>>(
                          title: this.title,
                          mainList: this.dataProvider.objectsList as List<T>,
                          funcCreateListItemTile: this.CreateListItemTileFunc,
                          funcFilterList: setFilterToList,
                          funcAddButton: createNewNote,
                          funcSearchItems: _searchItems,
                          funcGetDrawer: getDrawer,
                          funcGetDatesForOpenCalendar: getDatesForOpenCalendar,
                          subjectDropdownValues: _getSubjectDropdownValues,
                          filterDropdownValueItems: _filterDropdownValueItemsDefault,
                          deviceHeight: screenHeight,
                          deviceWidth: screenWidth,
                          onTap: this.onTap,
                          isSelectMode: widget.isSelectMode);


    return widgetHomePage!;
  }


  Future<void> onLoadInitAppRefresh() async
  {
    await readAllRecords();

    await setFilterToList(NoteFilterModeEn.allWithOutArchive.value, false, null);

    // setState(()
    // {
    //
    // });
  }

  double get scrollPosition
  {
    return this.widgetHomePage!.scrollPosition;
  }

  set scrollPosition(double value)
  {
    this.widgetHomePage!.scrollPosition = value;
  }

  int get scrollerIndex
  {
    return this.widgetHomePage!.scrollerIndex;
  }


  Future<DateTime?> openCalendarPicker() async
  {
    DateTime? date;

    // Fill the default selected dates
    List<DateTime>  dates = await getDatesForOpenCalendar();

    date = await MainGlobals.showCalendarWithMultiValues(_context, 'בחר תאריך', dates);

    if (date!=null)
    {
      await setFilterToList(NoteFilterModeEn.specificDay.value, false, date);
    }


    return date;
  }

  Widget?  getDrawer()
  {

    if (!MainGlobals.isMainInitApplicationLoaded)
    {
      return null;
    }

    final List<Widget> result = _createDrawerItems(this.dataProvider.dataBases);

    return

        Drawer(
          child:
            ListView(
              physics: const BouncingScrollPhysics(),   // ClampingScrollPhysics(),mNeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              //itemCount: DatabasesListTiles.length,

              children:
                result,   //listTiles,

            ),
        );
  }

  /// Property of Provider
  DataProvider get dataProvider
  {
    DataProvider<T> notesProvider = Provider.of<DataProvider<T>>(_context, listen: false);
    notesProvider.isEarlyAlarm = isEarlyAlarm;
    notesProvider.context = _context;
    // notesProvider.onNotificationActionReceived = this.onNotificationActionReceived;
    // notesProvider.onNotificationDisplayed = this.onNotificationDisplayed;
    notesProvider.funcGetObject = getFromJson;
    notesProvider.funcGetObjects = getFromJsonsList;
    notesProvider.funcForHandleTables ??= _handleTables;
    notesProvider.funcForCreateTables ??= _createTables;
    notesProvider.funcAddWelcomeNote ??= addWelcomeNote;
    notesProvider.databaseName = 'MH_Movies.db';
    notesProvider.mainTableName = 'TBL_Movies';
    notesProvider.FIREBASE_STORAGE_DIRECTORY = "mhmovies";
    //notesProvider.onShowMessage = ShowMessage;

    return notesProvider;
  }

  Map<String, dynamic> get _getSubjectDropdownValues
  {
    return transferDataForMap(Globals.tableGenres);
  }


  List<T> getFromJsonsList(List<Map<String, Object?>> listOfJsons)
  {
    List<T> outputItems = [];
    int counter = 0;


    for (var item in listOfJsons)
    {
      try
      {
        // Create new Object
        final Movie movie = Movie.fromJson(item, (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value) ? false : true);
        counter++;
        movie.ListIndex = counter;
        final T noteFinal  = movie as T;
        outputItems.add(noteFinal);
      }
      catch (e)
      {
        print(e);
      }

    }


    return outputItems;
  }

  T getFromJson(Map<String, Object?> json)
  {
    return Movie.fromJson(json, ) as T;
  }

  Future<List<T>> readAllRecords([bool isWithMessage = true, bool isRefreshData = true]) async
  {
    //await NotificationHandle.resetBadgeCounter();
    // await NotificationHandle.cancelNotificationsSchedulesAll();
    // await NotificationHandle.cancelNotificationsAll();

    Globals.isLoading = true;


    _mainList = (await this.dataProvider.readAllRecords(isWithMessage, isRefreshData)).cast<T>();


    int counter = 0;
    for (var item in _mainList)
    {
      // Create new Object
      final Movie movie = item as Movie;
      counter++;
      movie.ListIndex = counter;

      // // Send Notification message with reminder
      // await MainGlobals.setNotification((note as Imh_Object), this.onNotificationActionReceived);
    }

    list = transferData(_mainList);

    isFirstTime = false;
    Globals.isLoading = false;


    return _mainList;
  }

  /// Not in Use - Set ListIndex property
  Future<void> setListIndexProp<T>(List<T> notes) async
  {
    int counter = 0;
    for (var note in notes)
    {
      counter++;
      (note as Movie).ListIndex = counter;
    }
  }

  List<Widget> _createDrawerItems(List<DataBase> cloudDatabases) /*async*/
  {
    List<Widget> DatabasesListTiles = [];
    Widget listTile;
    final TextStyle subMenuCaptionTextStyle = TextStyle(fontSize: 17.0, fontWeight: FontWeight.w800, color: Theme.of(_context).colorScheme.primary   /*MainGlobals.buttonsForegroundColor*/);
    const TextStyle subMenuContentTextStyle = TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Colors.black38);



    // Header
    listTile = SizedBox(height: 100.0,
        child:
          DrawerHeader(
            decoration: BoxDecoration(color: Globals.applicationColorScheme.inversePrimary /*Theme.of(_context).colorScheme.inversePrimary*/),   //Globals.applicationColorScheme.inversePrimary
            child:
               Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children:
                 [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children:
                      [
                        Text('משימות ופתקים', textAlign: TextAlign.right, style: TextStyle(
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.w900,
                                      color: Theme.of(_context).colorScheme.primary,  //  Globals.applicationColorScheme.primary,    //
                                      shadows: [Shadow(offset: Offset.fromDirection(1.0, 5.0), color: Colors.white38, blurRadius: 5.0)])),
                        const Image(image: AssetImage('assets/images/note1.png'), fit: BoxFit.contain, width: 30.0, height: 30.0,),
                      ]),

                    //const SizedBox(height: 10.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children:
                      [
                        const Text('גירסה:', textAlign: TextAlign.right, style: subMenuContentTextStyle),
                        Text(Globals.getVersionName(_context), textAlign: TextAlign.left, textDirection: TextDirection.ltr,
                            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.black54)),
                      ])
                 ],
               )));
    DatabasesListTiles.add(listTile);


    // Setting page
    listTile = ListTile(
        title: Text('הגדרות', style: subMenuCaptionTextStyle),
        subtitle: const Text('שנה הגדרות המערכת', style: subMenuContentTextStyle),
        leading: Icon(Icons.settings, size: 30.0, color: Theme.of(_context).colorScheme.primary),  // Globals.applicationColorScheme.primary),
        onTap: () async
        {
          // Close the drawer
          Navigator.pop(_context);
          await this.dataProvider. readSettings();
          //Object? resultNavigator = await Navigator.pushNamed(_context, '/details', arguments: noteDetailsPageArguments);
          await Navigator.push(_context, MaterialPageRoute(builder: (_context) => const SettingPage()));
        });
    DatabasesListTiles.add(listTile);


    // Database Manage
    if (Globals.isWithDatabasesChange && dataProvider.CurrentDatabase != null && dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.cloudDB.value && this.dataProvider.CurrentUser.UserID == 1)
    {
        listTile = ListTile(
            title: Text('ניהול מסדי-נתונים', style: subMenuCaptionTextStyle),
            subtitle: const Text('מותר רק למנהל מערכת', style: subMenuContentTextStyle),
            leading: Icon(Icons.settings, size: 30.0, color: Theme.of(_context).colorScheme.primary),   //Globals.applicationColorScheme.primary),
            onTap: () async
            {
              // Close the drawer
              Navigator.pop(_context);

              //Object? resultNavigator = await Navigator.pushNamed(_context, '/details', arguments: noteDetailsPageArguments);
              await Navigator.push(_context, MaterialPageRoute(
                                                builder: (BuildContext context)
                                                {
                                                  return DatabaseHandle<T>(2, this._context, this.dataProvider).widgetToShow;     //DatabaseHandlePage();
                                                }));
            });
        DatabasesListTiles.add(listTile);
    }

    // Export/Import to External Json file
    listTile = ListTile(
                  title: Text('ייבוא/ייצוא לקובץ חיצוי', style: subMenuCaptionTextStyle),
                  subtitle: const Text('גבה את הנתונים שלך לקןבץ Json', style: subMenuContentTextStyle),
                  leading: Icon(Icons.file_copy_outlined, size: 30.0, color: Theme.of(_context).colorScheme.primary),
                  onTap: () async
                  {
                    // Close the drawer
                    Navigator.pop(_context);
                    if (widgetHomePage!.widgetHomePageState != null)
                    {
                      setState(() {
                        widgetHomePage!.widgetHomePageState!.isExport = true;
                        widgetHomePage!.isSelectMode = true;
                      });
                    }
                  }
    );
    DatabasesListTiles.add(listTile);


    /// Local DB - if exists
    if (Globals.isWithDatabasesChange)          // && MainGlobals.mainApplicationDirectory.isNotEmpty && File(MainGlobals.mainApplicationDirectory).existsSync())
    {
      DataBase dataBase = DataBase(ID: 1, FirebaseID: '', Title: 'מסד-הנתונים של סרטים בענן', DBName: dataProvider.databaseName, TypeID: DatabaseTypesEn.localDB.value, BaseUrl: MainGlobals.mainApplicationDirectory, NumeratorNotesID: 1);

      listTile = ListTile(
                    title: Text('מסד-נתונים מקומי', style: subMenuCaptionTextStyle),
                    subtitle: Column(
                                textDirection: TextDirection.rtl,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:
                                [
                                  Text(dataBase.Title.trim(), style: subMenuContentTextStyle),
                                  Text(dataBase.DBName, style: subMenuContentTextStyle),
                                ],
                              ),
                    leading: const Image(image: AssetImage('assets/images/database-local 5.png'), fit: BoxFit.contain, width: 30.0, height: 30.0,),
                    selectedTileColor: Theme.of(_context).colorScheme.primary,
                    onTap: () async
                    {
                      // Close the drawer
                      Navigator.pop(_context);
                      if (await this.dataProvider.changeDatabase(dataBase) != null)
                      {
                        _mainList = await this.readAllRecords(true, false);
                        setFilterToList(NoteFilterModeEn.allWithOutArchive.value, false, null);
                      }
                    });
      DatabasesListTiles.add(listTile);
      Globals.g_databasesList.add(listTile);
    }


    /// Cloud databases
    if (Globals.isWithDatabasesChange)
    {
      for (DataBase item in cloudDatabases)
      {
        listTile = ListTile(
                      title: Text(item.Title, style: subMenuCaptionTextStyle),
                      subtitle: Text(item.DBName, style: subMenuContentTextStyle),
                      leading: const Image(image: AssetImage('assets/images/database-cloud 1.jpg'), fit: BoxFit.contain, width: 30.0, height: 30.0),
                      selectedTileColor: Theme.of(_context).colorScheme.primary,
                      onTap: () async
                      {
                        // Close the drawer
                        Navigator.pop(_context);
                        if (await this.dataProvider.changeDatabase(item) != null)
                        {
                          _mainList = await this.readAllRecords(true, false);
                          setFilterToList(NoteFilterModeEn.allWithOutArchive.value, false, null);
                        }
                      });
        DatabasesListTiles.add(listTile);
        Globals.g_databasesList.add(listTile);
      }
    }


    listTiles = DatabasesListTiles;


    return listTiles;
  }

  Future<List<T>> getNote() async
  {
    return _mainList;
  }

  /// Not in use
  // @override
  // Widget CreateListView(Map<String, dynamic> listItems)
  // {
  //   if (this.IsExternalListItemTile)
  //   {
  //     return
  //       WidgetListView(
  //         ListItems: listItems,
  //         IsExternalListItemTile: this.IsExternalListItemTile,
  //         CreateListItemTileFunc: this.CreateListItemTileFunc,
  //         CardBackgroundColor: Colors.white,
  //         ItemTitleForegroundColor: Globals.applicationColorScheme.primary);
  //   }
  //   else
  //   {
  //     return
  //       WidgetListView(
  //         ListItems: listItems,
  //         IsExternalListItemTile: this.IsExternalListItemTile,
  //         ExtractListItemFieldsFunc: _getCardFieldsValues,
  //         CreateAdditionalInfoFunc: _createAdditionalInfoFunc,
  //         CardBackgroundColor: Colors.white,
  //         ItemTitleForegroundColor: Globals.applicationColorScheme.primary,
  //     );
  //   }
  // }

  Future<void> addWelcomeNote() async
  {
    T  object;

    Movie note = Movie(Title: 'ברוכים הבאים לניהול הסרטים שלך', Description: 'הקש על הכפתור ״+״ בתחתית המסך להוספת סרט', LastUpdateDate: DateTime.now().toLocal().toString().substring(0, 16), FilmTypeID: 1);

    object = note as T;
    if (await this.dataProvider.insertRecord(object) == 0)
    {
        //return null;
    }

    //// TODO: Movie note = Movie(Title: "New", Actors: [], Images: []);

    // return object;
  }


  Widget CreateListItemTileFunc(BuildContext context, dynamic objectInstantFirst) {
    // ListTile tileObject;
    Widget tileObject = const Text('');
    final bool isShowDetails;
    Widget titleWidget;
    Widget? subTitleWidget = null;
    Widget leadingImageWidget;
    final Widget deleteWidget;
    final TextStyle styleRichText;
    //final GlobalKey<RichEditorState> keyEditorDescription = GlobalKey<RichEditorState>();
    WidgetRichText? widgetRichText = null;


    if (objectInstantFirst == null) {
      return tileObject;
    }

    Movie movieInstant = objectInstantFirst as Movie;


    isShowDetails = false;

    styleRichText = TextStyle(color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontStyle: (movieInstant.IsSelect) ? FontStyle.italic : FontStyle
            .normal,
        fontSize: 16.0,
        height: 1.0,
        decoration: (movieInstant.StatusID == NoteStatusEn.Completed.value)
            ? TextDecoration.lineThrough
            : TextDecoration.none,
        letterSpacing: 0.0,
        wordSpacing: 0.08);

    // Main image
    final Widget image = Globals.getImageByListType(movieInstant);

    leadingImageWidget = (!widgetHomePage!.isSelectMode  /*widgetHomePage!.widgetHomePageState!.isSelectMode*/)
        // Image
        ? SizedBox(width: 40.0, height: 40.0,
            child:
              CircleAvatar(radius: 1.0, child: image))    //backgroundImage: NetworkImage(url)/*, minRadius: 1.0,*/)

        // Checkbox
        : SizedBox(width: 40.0, height: 40.0,
            child:
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColorForCheckbox),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                value: movieInstant.IsSelect,
                onChanged: (bool? value)
                {
                  setState(()
                  {
                    movieInstant.IsSelect = value!;
                    widget.isSelectMode = true;
                    widgetHomePage!.isSelectMode = true;
                  });
                }));



    // Favorite icon
    deleteWidget = SizedBox(width: 26.0, height: 26.0,
                      child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                            child:
                              IconButton(
                              color: Theme.of(context).colorScheme.primary,
                              hoverColor: Colors.red,
                              icon: Icon((movieInstant.IsFavorite) ? Icons.favorite : Icons.favorite_border, size: 26.0, color: Theme.of(context).colorScheme.primary),
                              onPressed: () async
                              {
                                _scrollerGet();

                                await this.dataProvider.saveFavorite(movieInstant);

                                _scrollerSet();
                              },
                            ),
                        ));


    String description = movieInstant.Description.trim();

    // Title widget
    titleWidget  = Text(movieInstant.Title,   //.padLeft(35, 'a'),
        // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontStyle: (movieInstant.IsSelect) ? FontStyle.italic : FontStyle.normal,
                          //height: 20.0,
                          fontSize: 17.5,
                          decoration: (movieInstant.StatusID == NoteStatusEn.Completed.value || (movieInstant.StatusID == NoteStatusEn.PartialCompleted.value)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none)),
                      maxLines: (description.isEmpty ? 2 : 1),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right);


    // Put Title and trailing Image in same row
    titleWidget =
        Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              SizedBox(width: LINE_WIDTH, /*height: 25.0,*/
                  child: titleWidget),

              deleteWidget
            ]);


    // Description field
    if (description.isNotEmpty || movieInstant.Genre.isNotEmpty)
    {
      if (description.isNotEmpty && MainGlobals.isItRichText(description))
      {
        final QuillEditorController controllerDescriptionHtml = QuillEditorController();
        widgetRichText = WidgetRichText(
                            initValue: description,
                            controller: controllerDescriptionHtml,
                            backgroundColor: Colors.white,
                            fontFamilyName: "sans-serif",
                            lineSpacing: 0.3,
                            textStyle: styleRichText,
                            toolBarPosition: 0,    /*BarPosition.TOP,*/
                            readOnly: true,
                            height: 45.0,
                            width: screenWidth+28);

        description = widgetRichText.adjustRichText(description);
        widgetRichText.setHtmlText(description);

        // Assume that Title is only 1 Line
        if (description.isNotEmpty)
        {
          titleWidget = SizedBox(height: 29.0, child: titleWidget);
        }
      }

      subTitleWidget =
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: (description.isNotEmpty && movieInstant.Genre.isNotEmpty) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children:
              [
                // Description in Rich Text
                if (description.isNotEmpty && MainGlobals.isItRichText(description))
                  GestureDetector(
                    onTap: () async
                    {
                      await this.onTap(movieInstant);
                    },

                    child: widgetRichText!,
                  ),


                // Description in Normal Text
                if (description.isNotEmpty && !MainGlobals.isItRichText(description))
                  Text(description,
                      style: styleRichText,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right),

                // Small Space to Push the Date more down
                if (description.isEmpty && movieInstant.Genre.isNotEmpty)
                  const SizedBox(height: 1.0),

                // Genre
                if (movieInstant.Genre.isNotEmpty)
                  SizedBox(height: 16.0,
                      child:
                      Text(movieInstant.Genre,
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 13.0),
                          maxLines: 1,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right)
                  ),

              ]);
    }


    // Card BackColor
    Color cardBackColor = Colors.white;
    // if (movieInstant.CardBackColor.isNotEmpty)
    // {
    //   List<String> colors = movieInstant.CardBackColor.split(';');
    //   int red = int.parse(colors[0]);
    //   int green = int.parse(colors[1]);
    //   int blue = int.parse(colors[2]);
    //   cardBackColor = Color.fromRGBO(red, green, blue, 0.9);
    // }


    if (isShowDetails)
    {
      tileObject = ExpansionTile(
          title:    titleWidget,

          subtitle: subTitleWidget,

          trailing: deleteWidget,

          leading: Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 5.0),
            child:
            leadingImageWidget,
          ),

          tilePadding: const EdgeInsets.all(0),

          children: [

            _createAdditionalInfoFunc(context, movieInstant)

          ]
      );
    }
    else
    {

      tileObject =
          ListTile(
            title:   titleWidget,

            subtitle: subTitleWidget,

            //trailing: deleteWidget,

            leading: Padding(padding: const EdgeInsets.only(right: 9.0, bottom: 0.0), child: leadingImageWidget),

            isThreeLine: false,
            contentPadding: const EdgeInsets.only(top: 0.0, right: 0.0, left: 0.0, bottom: 0.0),
            //titleTextStyle: TextStyle(fontSize: 15, color: Colors.blue), subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.blue),
            style:          ListTileStyle.list,
            titleAlignment: ListTileTitleAlignment.titleHeight,
            visualDensity:  VisualDensity.comfortable,
            iconColor:      Theme.of(context).colorScheme.primary,     //Colors.blue,
            selectedColor:  Theme.of(context).colorScheme.primary,   //Colors.deepPurpleAccent,
            hoverColor:     Colors.orange,
            focusColor:     cardBackColor,
            // tileColor:      cardBackColor,   Bug on Dart - If used, the corner not round
            selectedTileColor: Colors.blue,
            enabled: true,
            dense: false,
            onTap: () async
            {
              await this.onTap(movieInstant);
            },
            onLongPress: setSelectMode,
            // onFocusChange: onFocusChange,
          );

    }


    // tileObject =
    //   GestureDetector(
    //      onTap: () async
    //      {
    //        await this.onTap(movieInstant);
    //      },
    //
    //     onLongPress: setSelectMode,
    //
    //     child: tileObject,
    //   );



    return tileObject;
  }

  Future<void> onTap(Object item)  async
  {
    _scrollerGet();

    T object = item as T;
    MovieDetailsPageArguments noteDetailsPageArguments = MovieDetailsPageArguments<T>(noteObject: object, isUpdateMode: true, onEvenDeleteSucss: onEvenDeleteSucss);

    final Object? resultNavigator = await Navigator.pushNamed(_context, '/details', arguments: noteDetailsPageArguments);

    // When returned from page 'NoteDetailsPage', Refresh list
    await navigatorAnswerHandle(resultNavigator, object, noteDetailsPageArguments.isEarlyAlarm);

    _scrollerSet();
  }



  void setSelectMode()
  {
     widgetHomePage!.changeSelectMode();
  }

  /// BackColor For Checkbox
  Color getColorForCheckbox(Set<MaterialState> states)
  {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains))
    {
      return Colors.green;
    }

    return Colors.green;
  }

  /// Forecolor For Buttons
  Color getColorForButtons(Set<MaterialState> states)
  {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains))
    {
      return Colors.blue;
    }

    return Colors.blue;
  }

  /// Event raised after delete record
  void onEvenDeleteSucss(String message)
  {
    //Globals.showSnackBar(_context, message);
  }

  Widget _createAdditionalInfoFunc(BuildContext context, dynamic objectInstant)
  {
    Widget result;
    Movie note = objectInstant as Movie;


    result =
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.only(left: 10, right: 10.0),
          //height: 500,

          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,

            children:
            [
              RichText(textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                  text: TextSpan(style: DefaultTextStyle.of(context).style,
                      children:
                      [
                        // const TextSpan(text: "סטטוס: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15.0)),
                        // TextSpan(text: "${Globals.getCodeTableDesc(note.StatusID, CodeTableEn.StatuseTable)} \n", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.normal, fontSize: 15.0)),
                        //
                        // const TextSpan(text: "סוג פריט : ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15.0)),
                        // TextSpan(text: "${Globals.getCodeTableDesc(note.ListTypeID, CodeTableEn.ListTypesTable)} \n", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.normal, fontSize: 15.0)),
                        //
                        // if (note.PriorityID!=null)
                        //   const TextSpan(text: "עדיפות: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15.0)),
                        // TextSpan(text: "${Globals.getCodeTableDesc(note.PriorityID!, CodeTableEn.PrioritiesTable)} \n", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.normal, fontSize: 15.0)),
                        //
                        // if (note.Description.isNotEmpty)
                        //   const TextSpan(text: "הערות: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15.0)),
                        // TextSpan(text: note.Description, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0)),
                      ]
                  )
              ),

              /// Navigate to the Details page
              TextButton(child: const Text('קרא עוד ...', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  onPressed: () async
                  {
                    MovieDetailsPageArguments noteDetailsPageArguments = MovieDetailsPageArguments(noteObject: note, isUpdateMode: true);
                    Object? resultNavigator = await Navigator.pushNamed(context, '/details', arguments: noteDetailsPageArguments);

                    // When returned from page 'NoteDetailsPage', Refresh list
                    await navigatorAnswerHandle(resultNavigator, note as T, noteDetailsPageArguments.isEarlyAlarm);
                  }
              )
            ],
          ),
        );


    return result;
  }

  // TODO: maybe make Asynch
  Future<void> setProvider() async
  {
    double scrollPosition = this.widgetHomePage!.scrollPosition;
    int scrollerIndex = this.widgetHomePage!.scrollerIndex;

    this.dataProvider.objectsList = _mainList;

    // setState(() async
    // {
    //   this.widgetHomePage!.scrollPosition = scrollPosition;
    //   this.widgetHomePage!.scrollerIndex = scrollerIndex;
    // });
  }

  String _getCardFieldsValues(dynamic objectInstant)
  {
    Movie note = objectInstant as Movie;
    return "${note.Title}#${note.Description}";
  }

  /*Future<*/Map<String, dynamic> transferData(List<T> list) //async
  {
    Map<String, dynamic> listTmp = {};

    for (var i = 0; i < list.length; i++)
    {
      final Movie note = list[i] as Movie;
      listTmp['${(note as Imh_Object).ObjectID}'] = note;
      //Map<String, Object> singleMap = {'Item $i:', i};
      //list.putIfAbsent('Item $i', () => i);
      //list.add(singleMap);
    }

    return listTmp;
  }

  Map<String, dynamic> transferDataForMap(List<Map<String, dynamic>> list)
  {
    Map<String, dynamic> listTmp = {};

    for (var i = 0; i < list.length; i++)
    {
      final Map<String, dynamic> record = list[i];
      listTmp['${record['ID'] as int}'] = record['Description'] as String;
      //Map<String, Object> singleMap = {'Item $i:', i};
      //list.putIfAbsent('Item $i', () => i);
      //list.add(singleMap);
    }

    return listTmp;
  }

  Future<void> _searchItems(String query) async
  {
    List<Movie> resultList=[];
    List<Movie> tmpList=[];
    List<Movie> listAll=[];
    query = query.toLowerCase().trim();


    try
    {
      if (query.isNotEmpty)
      {
        listAll =this.dataProvider.objectsListBackupAll as List<Movie>;
        tmpList = listAll.where((e) => e.Title.toLowerCase().contains(query)).toList();
        resultList.addAll(tmpList);
        tmpList = listAll.where((e) => e.Description.toLowerCase().contains(query)).toList();
        resultList.addAll(tmpList);
        // resultList.addAll(tmpList.where((e) => !tmpList.contains(e)).toList());

        _mainList = resultList as List<T>;
        list = transferData(_mainList);
        await setProvider();
      }
      else
      {
        await this.setFilterToList(currentFilter, false, null);
      }

    }
    catch (e)
    {
      print('Error in _searchItems: ${e}');
    }
  }

  void setStateRefresh()
  {
    if (mounted)
    {
      //Globals.showSnackBar(_context, 'מרענן');
      setState(()
      {

      });
    }
  }

  /// Filter data
  Future<void> setFilterToList(String filterMode, bool isLoadFromDB, Object? valueToCompare, [bool extraRefresh = false]) async
  {
    DateTime? specificDate;
    List<NoteFilterModeEn> filterModeWithOutArchive = [NoteFilterModeEn.allWithOutArchive, NoteFilterModeEn.today, NoteFilterModeEn.dateDue, NoteFilterModeEn.dateDueWithOut];
    currentFilter = filterMode;
    final int tableCode;



    List<NoteFilterModeEn> /*String*/ values = NoteFilterModeEn.values.where((e) => e.value == filterMode).toList();
    if (values.isNotEmpty)
    {
      // MainGlobals.showSnackBar(_context, 'value: ${values[0].value}');
    }
    else
    {
      // MainGlobals.showSnackBar(_context, 'Error: ***$filterMode***');
      return;
    }

    switch (values[0])
    {
      case NoteFilterModeEn.all:
        if (isLoadFromDB)
        {
          _mainList = await this.readAllRecords(true);
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll as List<T>;
        }
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);

      case NoteFilterModeEn.allWithOutArchive:
        if (isLoadFromDB)
        {
          _mainList = await this.readAllRecords(true);
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll as List<T>;
        }
        await setOrderSelected(NotesOrderByEn.LastUpdateDate, NotesOrderDirectionByEn.descending);
        break;

      case NoteFilterModeEn.today:
        DateTime date = DateTime.now();
        String dateStr = date.toLocal().toString().substring(0, 10);
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter("substr(DateDue, 1, 10) = ?", [ dateStr]) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.DateDue.isNotEmpty &&  a.DateDue.substring(0, 10) == dateStr).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
        //_mainList = await DatabaseHelper.instance.readWithFilter("STRFTIME('%d/%m/%Y %H.value:%M', DateDue) >= ", [ date.toLocal().toString() ]);
        //https://support.atlassian.com/analytics/docs/sqlite-date-and-time-functions/#
        // STRFTIME('%d-%m-%Y',DateDue) CONVERT(DATETIME,DateDue)  .. CAST(DateDue as date)
        // Use them in any of the following functions: DATE(), TIME(), DATETIME()
        // The equivalent format for the DATE() function is STRFTIME(‘%Y-%m-%d’,…).
        // The equivalent format for the TIME() function is STRFTIME(‘%H:%M:%S’,…).
        // The equivalent format for the DATETIME() function is STRFTIME(‘%Y-%m-%d’,…).
        break;

      case NoteFilterModeEn.dateDue:
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter("DateDue != ?", ['']) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.DateDue.isNotEmpty).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
        break;

      case NoteFilterModeEn.dateDueWithOut:
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter("DateDue = ?", ['']) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.DateDue.isEmpty).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.LastUpdateDate, NotesOrderDirectionByEn.ascending);
        break;

      case NoteFilterModeEn.statusNoDone:
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter('StatusID = ?', [NoteStatusEn.Open.value]) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.StatusID == NoteStatusEn.Open.value).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
        break;

      case NoteFilterModeEn.statusCompleted:
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter('StatusID = ?', [NoteStatusEn.Completed.value]) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.StatusID == NoteStatusEn.Completed.value).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
        break;

      case NoteFilterModeEn.statusPartCompleted:
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter('StatusID = ?', [NoteStatusEn.PartialCompleted.value]) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.StatusID == NoteStatusEn.PartialCompleted.value).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.LastUpdateDate, NotesOrderDirectionByEn.ascending);
        break;

      case NoteFilterModeEn.statusInArchive:
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter('StatusID = ?', [NoteStatusEn.InArchive.value]) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.StatusID == NoteStatusEn.InArchive.value).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
        break;

      case NoteFilterModeEn.typeReminder:
      case NoteFilterModeEn.typeWork:
      case NoteFilterModeEn.typeCalendar:
      case NoteFilterModeEn.typeShopList:
      case NoteFilterModeEn.typeRecipe:
      case NoteFilterModeEn.typeTask:
      case NoteFilterModeEn.typeNote:   // || NoteFilterModeEn.typeRecipe || NoteFilterModeEn.typeShopList || NoteFilterModeEn.typeCalendar || NoteFilterModeEn.typeWork || NoteFilterModeEn.typeReminder || NoteFilterModeEn.typeTask:
        tableCode = Globals.getCodeTableID(values[0].value, CodeTableEn.FilmTypesTable);
        if (tableCode != -1)
        {
          if (isLoadFromDB)
          {
            _mainList = await this.dataProvider.readWithFilter('FilmTypeID = ?', [ tableCode]) as List<T>;
          }
          else
          {
            _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.ListTypeID == tableCode).toList().cast<T>();
          }
          await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
        }
        break;

      case NoteFilterModeEn.specificDay:
        if (valueToCompare == null)
        {
          // Open Calendar
          specificDate = await openCalendarPicker();
          currentFilterValue = specificDate;
          return;
        }
        else
        {
          specificDate = (valueToCompare as DateTime?);
        }

        currentFilterValue = valueToCompare;

        if (specificDate == null)
        {
          return;
        }
        String dateStr= specificDate.toString();
        dateStr = dateStr.substring(0, 10);
        if (isLoadFromDB)
        {
          _mainList = await this.dataProvider.readWithFilter("substr(DateDue, 1, 10) = ?", [ dateStr]) as List<T>;
        }
        else
        {
          _mainList = this.dataProvider.objectsListBackupAll.where((a) => a.DateDueToDate!=null && DateUtils.dateOnly(a.DateDueToDate!) == DateUtils.dateOnly(specificDate!)).toList().cast<T>();
        }
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
        break;

      case NoteFilterModeEn.subjects:
        // The parameter 'valueToCompare' come as: 'Health, About Home, About Work'
        // MainGlobals.showSnackBar(_context, 'In Filter func: $valueToCompare');
        if (valueToCompare == null || valueToCompare == "")
        {
          _mainList = this.dataProvider.objectsListBackupAll as List<T>;
          MainGlobals.showSnackBar(_context, ' מרענן הכל ${_mainList.length}');
        }
        else
        {
          List<String> chosen = (valueToCompare as String).split(', ').toList();
          List<T> tmpList = [];
          // MainGlobals.showSnackBar(_context, 'chosen: $chosen');
          // Loop subject by subject
          for (String item in chosen)
          {
            final List<T> justThis/* = []*/;

            if (isLoadFromDB)
            {
              if (this.dataProvider.CurrentDatabase!.TypeID==DatabaseTypesEn.localDB.value)
              {
                justThis = await this.dataProvider.readWithFilter("'$item' IN SubjectLabels", []) as List<T>;
              }
              else
              {
                justThis = await this.dataProvider.readWithFilter("SubjectLabels", []) as List<T>;
              }
              tmpList.addAll(justThis);
            }
            else
            {
              justThis = this.dataProvider.objectsListBackupAll.where((a) => a.SubjectLabels.toString().contains(item)).toList().cast<T>();
              tmpList.addAll(justThis);
              // if (tmpList.isNotEmpty)
              // {
              //   MainGlobals.showSnackBar(_context, (tmpList.elementAt(tmpList.length-1) as Note).SubjectLabels);
              // }
            }

            // MainGlobals.showSnackBar(_context, 'item: $item,  $justThis found');
          }

          if (tmpList.isNotEmpty)
          {
            tmpList = tmpList.toSet().toList();     // remove duplicates values
            _mainList = tmpList;
          }
          else
          {
            _mainList = this.dataProvider.objectsListBackupAll as List<T>;
            MainGlobals.showSnackBar(_context, ' מרענן הכל ${_mainList.length}');
          }
        }
        currentFilterValue = valueToCompare;
        await setOrderSelected(NotesOrderByEn.Description, NotesOrderDirectionByEn.ascending);
        break;

      default:
        await setOrderSelected(NotesOrderByEn.DateDue, NotesOrderDirectionByEn.ascending);
    }



    Iterable<NoteFilterModeEn> noteFilterModeEns = filterModeWithOutArchive.where((a) => a.value == currentFilter);

    if (noteFilterModeEns.isNotEmpty)
    {
      _mainList = _mainList.where((a) => (a as Movie).StatusID != NoteStatusEn.InArchive.value).toList();
    }

    list = transferData(_mainList);

    this.title = await getCaption(specificDate);
    this.widgetHomePage!.title = this.title;

    await setProvider();

    // Done in provider
    if (extraRefresh)
    {
      setState(() {});
    }


  }

  /// Order the list
  // Sort from shortest to longest.
  // Ascending
  //numbers.sort((a, b) => a.length.compareTo(b.length));
  // Descending
  //numbers.sort((a, b) => b.length.compareTo(a.length));
  Future<void> setOrderSelected(NotesOrderByEn orderField, NotesOrderDirectionByEn sortDirection) async
  {

    currentOrder = orderField;
    currentOrderDirection = sortDirection;

    switch (orderField)
    {
      case NotesOrderByEn.Title:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          _mainList.sort((a, b) => (a as Movie).Title.compareTo((b as Movie).Title));
        }
        else
        {
          // Descending
          _mainList.sort((a, b) => (b as Movie).Title.compareTo((a as Movie).Title));
        }
        break;

      case NotesOrderByEn.DateDue:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          // _mainList.sort((a, b) => (a as Movie).DateDue.compareTo((b as Movie).DateDue));
        }
        else
        {
          // Descending
          // _mainList.sort((a, b) => (b as Movie).DateDue.compareTo((a as Movie).DateDue));
        }
        break;

      case NotesOrderByEn.Description:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          _mainList.sort((a, b) => (a as Movie).Description.compareTo((b as Movie).Description));
        }
        else
        {
          // Descending
          _mainList.sort((a, b) => (b as Movie).Description.compareTo((a as Movie).Description));
        }
        break;

      case NotesOrderByEn.Status:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          _mainList.sort((a, b) => (a as Movie).StatusID!.compareTo((b as Movie).StatusID!));
        }
        else
        {
          // Descending
          _mainList.sort((a, b) => (b as Movie).StatusID!.compareTo((a as Movie).StatusID!));
        }
        break;

      case NotesOrderByEn.ListType:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          _mainList.sort((a, b) => (a as Movie).ListTypeID.compareTo((b as Movie).ListTypeID));
        }
        else
        {
          // Descending
          _mainList.sort((a, b) => (b as Movie).ListTypeID.compareTo((a as Movie).ListTypeID));
        }
        break;

      case NotesOrderByEn.Priority:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          // _mainList.sort((a, b) => (a as Movie).PriorityID!.compareTo((b as Movie).PriorityID!));
        }
        else
        {
          // Descending
          // _mainList.sort((a, b) => (b as Movie).PriorityID!.compareTo((a as Movie).PriorityID!));
        }
        break;

      case NotesOrderByEn.Subject:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          _mainList.sort((a, b) => (a as Movie).SubjectLabels.compareTo((b as Movie).SubjectLabels));
        }
        else
        {
          // Descending
          _mainList.sort((a, b) => (b as Movie).SubjectLabels.compareTo((a as Movie).SubjectLabels));
        }
        break;

      case NotesOrderByEn.LastUpdateDate:
        if (sortDirection==NotesOrderDirectionByEn.ascending)
        {
          _mainList.sort((a, b) => (a as Movie).LastUpdateDate.compareTo((b as Movie).LastUpdateDate));
        }
        else
        {
          // Descending
          _mainList.sort((a, b) => (b as Movie).LastUpdateDate.compareTo((a as Movie).LastUpdateDate));
        }
        break;

    }


  }

  /// Not in use - When Timer work
  void onTimerTick(Movie note) async
  {

    // https://github.com/bluefireteam/audioplayers/blob/main/getting_started.md
    // https://stackoverflow.com/questions/43813386/how-to-play-a-custom-sound-in-flutter

    // PlayAudio playAudio = PlayAudio('dream_bonus_notification.mp3', 1.0);
    // await playAudio.play();

    SystemSound.play(SystemSoundType.alert);    // '../assets/sounds/symphony.mp3');

    AlertDialogResultEn result = await MainGlobals.showAlarmMessage(_context, note.Title, note.Description);

    if (result == AlertDialogResultEn.Yes)
    {
      // DateTime dateTime = note.DateDueToDate!.add(const Duration(minutes: 10));

      await this.dataProvider.updateRecord(note);


      // Output Action string to do, when close page 'NoteDetailsPage'

      //await navigatorAnswerHandle('updated', note);

      // setProvider();
      // note.setTimer(onTimerTick);
      //
      // setState(() {
      //
      // });
    }
    else
    {
      //setStateRefresh();
    }
  }

  // void onTimerT(Note note) async
  // {
  //
  //   // https://github.com/bluefireteam/audioplayers/blob/main/getting_started.md
  //   // https://stackoverflow.com/questions/43813386/how-to-play-a-custom-sound-in-flutter
  //
  //   // Keep the screen on.
  //   //KeepScreenOn.turnOn();
  //   // Reset
  //   //KeepScreenOn.turnOff();
  //   // KeepScreenOn.turnOn(on: false);or...
  //   //     //
  //   //KeepScreenOn.addAllowLockWhileScreenOn();
  //   //KeepScreenOn.clearAllowLockWhileScreenOn();
  //   //bool p = await KeepScreenOn.isAllowLockWhileScreenOn
  //   //bool? p = await KeepScreenOn.isOn;
  //   //bool? p = await KeepScreenOn.isOff;
  //
  //   // PlayAudio playAudio = PlayAudio('dream_bonus_notification.mp3', 1.0);
  //   // await playAudio.play();
  //
  //   SystemSound.play(SystemSoundType.alert);
  //
  //   AlertDialogResultEn result = await MainGlobals.showAlarmMessage(_context, note.Title, note.Description);
  //
  //   if (result == AlertDialogResultEn.Yes)
  //   {
  //     DateTime dateTime = note.DateDueToDate!.add(const Duration(minutes: 10));
  //     // note.DateDueToDate = dateTime;
  //     note.TimeDue = TimeOfDay.fromDateTime(dateTime);
  //     note.SetDateDueToString();
  //
  //     // setProvider();
  //     // note.setTimer(onTimerT);
  //     //
  //     // setState(() {
  //     //
  //     // });
  //   }
  //   else
  //   {
  //     setState(() {
  //
  //     });
  //   }
  // }

  // /// When Notification arrived and User Press on Notification buttons
  // Future<void> onNotificationActionReceived(dynamic action) async
  // {
  //   ReceivedAction receivedAction = action as ReceivedAction;
  //   int noteID = receivedAction.id!;
  //   final Movie? note;
  //   List<Movie> listTmp;
  //
  //
  //
  //   if (noteID > 100000)
  //   {
  //     noteID = noteID - 100000;
  //   }
  //
  //   listTmp = (this.dataProvider.objectsListBackupAll as List<Note>).where((e) => e.NoteID == noteID).toList();
  //
  //   // In case not find the item
  //   if (listTmp.isEmpty)
  //   {
  //     // Refresh the list, to find the item
  //     listTmp = await this.dataProvider.readAllRecords(false/*, false*/)  as List<Note>;
  //     listTmp = this.dataProvider.objectsListBackupAll.where((e) => e.NoteID == noteID).toList()  as List<Note>;
  //     if (listTmp.isEmpty)
  //     {
  //       MainGlobals.showSnackBar(_context, 'הפריט לא נמצא');
  //       return;
  //     }
  //     note = listTmp.first;
  //   }
  //   else
  //   {
  //     note = listTmp.first;
  //   }
  //
  //
  //   // Cancel Notification object
  //   await MainGlobals.cancelNotification(note);
  //
  //
  //     // After come from Notification appeared
  //   await notificationAnswerHandle(receivedAction.buttonKeyPressed, note);
  //
  // }

  // /// After come from Notification appeared
  // Future<void> notificationAnswerHandle(String answer, Note note) async
  // {
  //
  //   switch (answer)
  //   {
  //     case 'snooze':
  //       note.DateDueToDate = DateTime.now().add(Duration(minutes: MainGlobals.g_buzzerMinutes));
  //       note.TimeDue = TimeOfDay.fromDateTime(note.DateDueToDate!);
  //       note.SetDateDueToString();
  //       await this.dataProvider.updateRecord(note);
  //       break;
  //
  //     case 'snooze24':
  //       note.DateDueToDate = DateTime.now().add(const Duration(hours: 24));
  //       note.TimeDue = TimeOfDay.fromDateTime(note.DateDueToDate!);
  //       note.SetDateDueToString();
  //       await this.dataProvider.updateRecord(note);
  //       break;
  //
  //     case 'delete':
  //       await this.dataProvider.deleteRecord([note], "MovieID", false);
  //       break;
  //
  //     case 'completed':
  //       note.StatusID = NoteStatusEn.Completed.value;
  //       await this.dataProvider.updateRecord(note);
  //       break;
  //
  //     case 'dismiss':
  //     case 'exit':
  //       break;
  //
  //     case '':
  //     case 'details':
  //       NoteDetailsPageArguments noteDetailsPageArguments = NoteDetailsPageArguments(noteObject: note, isUpdateMode: true);
  //       // Get into NoteDetailsPage
  //       Object? resultNavigator = await NotificationHandle.getNavigatorKey?.currentState?.pushNamedAndRemoveUntil(
  //                                     '/details', (route) => (route.settings.name != '/details') || route.isFirst,
  //                                     arguments: noteDetailsPageArguments);
  //
  //       // When returned from page 'NoteDetailsPage', Refresh list
  //       await navigatorAnswerHandle(resultNavigator, note as T, noteDetailsPageArguments.isEarlyAlarm);
  //       break;
  //
  //     default:
  //       break;
  //   }
  //
  //
  // }
  //
  // // /// When Notification arrived and User Press on Notification buttons
  // // Future<void> onNotificationDisplayed(dynamic action) async
  // // {
  // //   ReceivedNotification receivedNotification = action as ReceivedNotification;
  // //   final int noteID = receivedNotification.id!;
  // //   final Movie? note;
  // //   final List<Movie> listTmp;
  // //
  // //
  // //
  // //   listTmp = dataProvider.objectsListBackupAll.where((e) => e.NoteID == noteID).toList()  as List<Note>;
  // //
  // //   if (listTmp.isEmpty)
  // //   {
  // //     MainGlobals.showSnackBar(_context, 'הפריט לא נמצא');
  // //     return;
  // //   }
  // //   else
  // //   {
  // //     note = listTmp.first;
  // //   }
  // //
  // //
  // //   Object? resultNavigator;
  // //   NoteDetailsPageArguments noteDetailsPageArguments;
  // //
  // //
  // //   // // Open 'Reminder screen
  // //   // if (note.PriorityID == NotePrioritiesEn.High.value)
  // //   // {
  // //   //   if (receivedNotification.payload != null)
  // //   //   {
  // //   //     // handle notification payload here
  // //   //     print('Notification payload: ${receivedNotification.payload}');
  // //   //   };
  // //   //
  // //   //   noteDetailsPageArguments = NoteDetailsPageArguments(noteObject: note, isUpdateMode: true, onNotificationDisplayed: receivedNotification);
  // //   //
  // //   //   // Navigate into pages, avoiding to open the notification details page over another details page already opened
  // //   //   resultNavigator = await NotificationHandle.getNavigatorKey?.currentState?.pushNamedAndRemoveUntil(
  // //   //                                                                                   '/reminder_page',
  // //   //                                                                                 (route) =>
  // //   //                                                                                 (route.settings.name != '/reminder_page') || route.isFirst,
  // //   //                                                                                 arguments: noteDetailsPageArguments);
  // //   //
  // //   //   // After come from Notification appeared
  // //   //   await notificationAnswerHandle(resultNavigator as String, note);
  // //   // }
  // //
  // // }
  //
  // Future<void> onNotificationDismiss(ReceivedAction receivedAction) async
  // {
  //
  // }


  /// When returned from page 'NoteDetailsPage', Refresh list
  Future<void> navigatorAnswerHandle(Object? answer, T note, [bool isEarlyAlarm = false]) async
  {
    bool isNeedRefresh = false;
    final bool result;



    if (answer==null)
    {
      return;
    }

    this.isEarlyAlarm = isEarlyAlarm;

    switch (answer.toString())
    {
      case 'updated':
        result = await this.dataProvider.updateRecord(note);
        isNeedRefresh = true;
        break;

      case 'deleted':
        await this.dataProvider.deleteRecord([ note ], "MovieID", true);
        isNeedRefresh = true;
        break;

      case 'inserted':
        result = (await this.dataProvider.insertRecord(note) > 0);
        // await setFilterToList(NoteFilterModeEn.allWithOutArchive.value, false, null);
        isNeedRefresh = true;    // TODO: To Show the new item in top of list
        break;

      case 'favorite':
        (note as Movie).IsFavorite = true;
        result = await this.dataProvider.saveFavorite(note);
        break;

    }


    if (isNeedRefresh)
    {
      await setFilterToList(currentFilter, false, currentFilterValue);
    }


  }

  Future<String> getCaption([DateTime? specificDate]) async
  {
    title = 'כל הפריטים';
    NoteFilterModeEn value = NoteFilterModeEn.values.firstWhere((e) => e.value == currentFilter);


    switch (value)
    {
      case NoteFilterModeEn.all:
        title = 'כל הפריטים';
        break;
      case NoteFilterModeEn.allWithOutArchive:
        title = 'כל הפריטים (ללא ארכיון)';
        break;
      case NoteFilterModeEn.today:
        title = 'המשימות להיום';
        break;
      case NoteFilterModeEn.dateDue:
        title = 'המשימות המתוזמנות';
        break;
      case NoteFilterModeEn.specificDay:
        String dateStr = specificDate!.toLocal().toString().substring(0, 10);
        dateStr = MainGlobals.setDateFormat(dateStr);
        title = ' הפריטים לתאריך $dateStr';
        break;
      case NoteFilterModeEn.dateDueWithOut:
        title = 'המשימות הלא מתוזמנות';
        break;
      case NoteFilterModeEn.statusNoDone:
        title = 'המשימות שעדיין לא בוצעו';
        break;
      case NoteFilterModeEn.statusCompleted:
        title = 'המשימות שהושלמו';
        break;
      case NoteFilterModeEn.typeNote:
        title = 'הפריטים מסוג פתק';
        break;
      case NoteFilterModeEn.typeTask:
        title = 'הפריטים מסוג משימה';
        break;
      case NoteFilterModeEn.typeReminder:
        title = 'הפריטים מסוג תזכורת';
        break;
      case NoteFilterModeEn.statusPartCompleted:
        title='המשימות שבוצעו חלקית';
        break;
      case NoteFilterModeEn.typeWork:
        title = 'הפריטים שקשורים לעבודה';
        break;
      case NoteFilterModeEn.typeCalendar:
        title = 'הפריטים שקשורים ליומן פגישות';
        break;
      case NoteFilterModeEn.subjects:
        title = 'הפריטים עם התוויות נושאים';
        break;

      default:
        title = 'רשימת כל הפריטים';
    }


    return title;
  }

  /// When Add button pressed
  Future<void> createNewNote([Object? value]) async
  {
    DateTime? dateDue;


    if (value != null)
    {
      dateDue = value as DateTime;
    }

    Movie note = Movie(
                  Title: '',
                  Description: '',
                  FilmTypeID: NoteListTypeTypesEn.Task.value,
                  StatusID: NoteStatusEn.Open.value,
                  // PriorityID: NotePrioritiesEn.Normal.value,
                  LastUpdateDate: DateTime.now().toString(),
                  SubTasks: []);

    if (dateDue!=null)
    {
      // note.DateDueToDate = dateDue;
      // note.TimeDue = TimeOfDay.fromDateTime(dateDue);
      // note.SetDateDueToString();
    }

    MovieDetailsPageArguments noteDetailsPageArguments = MovieDetailsPageArguments(noteObject: note, isUpdateMode: false, isFromFavoritePage: false);

    Object? resultNavigator = await Navigator.pushNamed(_context, '/details', arguments: noteDetailsPageArguments);

    //Output Action string to do, when close page 'NoteDetailsPage'
    await navigatorAnswerHandle(resultNavigator, note as T, noteDetailsPageArguments.isEarlyAlarm);

  }

  List<DateTime> getDatesForOpenCalendar()  //async
  {
    List notes  = this.dataProvider.objectsListBackupAll;

    // Fill the default selected dates
    notes = notes.where((e) => e.DateDue.isNotEmpty &&
                              (e.DateDueToDate!.month == DateTime.now().month &&
                               e.DateDueToDate!.year == DateTime.now().year)).toList();

    final List<DateTime>  dates = notes.map<DateTime>((e) => e.DateDueToDate!).toList();


    return dates;
  }

  Future<List<Movie>> getSelectedItems() async
  {
    return _mainList.where((e) => (e as Movie).IsSelect).toList() as List<Movie>;
  }

  void ShowMessage(String message)
  {
    MainGlobals.showSnackBar(_context, message);
  }


  Future<void> _createTables(Database db, int databaseVersion) async
  {
    await _createMoviesTable(db, databaseVersion);
    await _createNotesImagesTable(db, databaseVersion);
    await _createStatusesTable(db, databaseVersion);
    await _createFilmTypesTable(db, databaseVersion);
    await _createActorsTable(db, databaseVersion);
    await _createGenresTable(db, databaseVersion);
    await _createDirectorsTable(db, databaseVersion);
    await _createNotesChildsTable(db, databaseVersion);
    await _createSettingTable(db, databaseVersion);
    await _createEditorsTable(db, databaseVersion);
    await _createWritersTable(db, databaseVersion);
    await _createMusiciansTable(db, databaseVersion);
  }

  Future<void> _handleTables() async
  {

    // Where there is a change in tables structure - Change the tables with copy Data
    await _changeTable();

    //Globals.tableStatuses = await this.dataProvider.getCodeTableValues("TBL_Statuses");
    Globals.tableFilmTypes = await this.dataProvider.getCodeTableValues("TBL_FilmTypes");
    Globals.tableActors = await this.dataProvider.getCodeTableValues("TBL_Actors");
    Globals.tableGenres = await this.dataProvider.getCodeTableValues("TBL_Genres");
    Globals.tableDirectors = await this.dataProvider.getCodeTableValues("TBL_Directors");
    Globals.tableEditors = await this.dataProvider.getCodeTableValues("TBL_Editors");
    Globals.tableWriters = await this.dataProvider.getCodeTableValues("TBL_Writers");
    Globals.tableMusicians = await this.dataProvider.getCodeTableValues("TBL_Musicians");
    Globals.tableActors = await sortMap(Globals.tableActors);
    Globals.tableGenres = await sortMap(Globals.tableGenres);
    Globals.tableDirectors = await sortMap(Globals.tableDirectors);
    Globals.tableEditors = await sortMap(Globals.tableEditors);
    Globals.tableWriters = await sortMap(Globals.tableWriters);
    Globals.tableMusicians = await sortMap(Globals.tableMusicians);
  }

  /// Where there is a change in tables structure - Change the tables with copy Data
  Future<void> _changeTable() async
  {
    bool result = true;


    if (!await this.dataProvider.isTableExist(this.dataProvider.mainTableName))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createMoviesTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        // await _createDatabaseTableFireBase(this.dataProvider.CurrentDatabase!);
      }
    }

    if (!await this.dataProvider.isTableExist("TBL_Actors"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createFilmTypesTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createActorsTableFireBase();
      }
      Globals.tableActors = await this.dataProvider.getCodeTableValues("TBL_Actors");
    }

    if (!await this.dataProvider.isTableExist("TBL_Genres"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createGenresTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createGenresTableFireBase();
      }
      Globals.tableGenres = await this.dataProvider.getCodeTableValues("TBL_Genres");
    }

    if (!await this.dataProvider.isTableExist("TBL_Directors"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createDirectorsTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createDirectorsTableFireBase();
      }
      Globals.tableDirectors = await this.dataProvider.getCodeTableValues("TBL_Directors");
    }

    if (!await this.dataProvider.isTableExist("TBL_FilmTypes"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createFilmTypesTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createFilmTypesTableFireBase();
      }
      Globals.tableFilmTypes = await this.dataProvider.getCodeTableValues("TBL_FilmTypes");
    }

    if (!await this.dataProvider.isTableExist("TBL_Editors"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createEditorsTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createEditorsTableFireBase();
      }
      Globals.tableEditors = await this.dataProvider.getCodeTableValues("TBL_Editors");
    }

    if (!await this.dataProvider.isTableExist("TBL_Writers"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createWritersTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createWritersTableFireBase();
      }
      Globals.tableWriters = await this.dataProvider.getCodeTableValues("TBL_Editors");
    }

    if (!await this.dataProvider.isTableExist("TBL_Musicians"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createMusiciansTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createMusiciansTableFireBase();
      }
      Globals.tableMusicians = await this.dataProvider.getCodeTableValues("TBL_Musicians");
    }

    if (!await this.dataProvider.isTableExist("TBL_Settings"))
    {
      if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
      {
        await this._createSettingTable(await this.dataProvider.databaseHelperSqllite.SqfLite.database, this.dataProvider.databaseHelperSqllite.SqfLite.databaseVersion);
      }
      else
      {
        await _createSettingTableFireBase();
      }
    }

    if (!await this.dataProvider.isTableExist('TBL_NotesChilds'))
    {
      await _createNotesChildsTable(await this.dataProvider.databaseHelperSqllite.database, this.dataProvider.databaseHelperSqllite.databaseVersion);
    }

    if (!await this.dataProvider.isTableExist('TBL_NotesImages'))
    {
      await _createNotesImagesTable(await this.dataProvider.databaseHelperSqllite.database, this.dataProvider.databaseHelperSqllite.databaseVersion);
    }


    if (this.dataProvider.CurrentDatabase!.TypeID == DatabaseTypesEn.localDB.value)
    {
      if (!await this.dataProvider.isFieldExist(this.dataProvider.mainTableName, 'Country'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('Country', 'VARCHAR', this.dataProvider.mainTableName);
      }

      if (!await this.dataProvider.isFieldExist(this.dataProvider.mainTableName, 'Music'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('Music', 'VARCHAR', this.dataProvider.mainTableName);
      }

      if (!await this.dataProvider.isFieldExist(this.dataProvider.mainTableName, 'FilmTypeID'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('FilmTypeID', 'int', this.dataProvider.mainTableName);
      }

      if (!await this.dataProvider.isFieldExist(this.dataProvider.mainTableName, 'SubjectLabels'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('SubjectLabels', 'VARCHAR', this.dataProvider.mainTableName);
      }

      if (!await this.dataProvider.isFieldExist("TBL_Settings", 'UserEmail'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('UserEmail', 'VARCHAR NULL', "TBL_Settings");
      }

      if (!await this.dataProvider.isFieldExist("TBL_Settings", 'UserPassword'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('UserPassword', 'VARCHAR NULL', "TBL_Settings");
      }

      if (!await this.dataProvider.isFieldExist("TBL_Settings", 'MainDataName'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('MainDataName', 'VARCHAR NULL', "TBL_Settings");
        //// TODO: String sql = "UPDATE TBL_Settings SET MainDataName = '" + MainGlobals.g_mainDataName + "'";
        // await this.dataProvider.databaseHelperSqllite.database.execute(sql);
      }

      if (!await this.dataProvider.isFieldExist(this.dataProvider.mainTableName, 'FirebaseID'))
      {
        result = await this.dataProvider.databaseHelperSqllite.addField('FirebaseID', 'VARCHAR', this.dataProvider.mainTableName);
      }
    }

    // if (/*Globals.tableStatuses.isNotEmpty &&*/ Globals.tableSubjects.length < 4)
    // {
    //   // delete all table's records
    //   await this.deleteAllRecordsInTable('TBL_Subjects');
    //   await this._createSubjectsTable(await _SqlInstant.database, _SqlInstant.databaseVersion);
    //   Globals.tableSubjects = await getCodeTableValues(/*"TBL_Subjects"*/ CodeTableEn.SubjectLabel);
    // }
    //
    // //await _SqlInstant.deleteRecord('TBL_Statuses');
    // if (Globals.tableStatuses.length < 4)
    // {
    //   const String sql = 'DROP TABLE IF EXISTS TBL_Statuses';
    //   await _SqlInstant.executeSqlNoResult(sql);
    //   await this._createStatusesTable(await _SqlInstant.database, _SqlInstant.databaseVersion);
    //   Globals.tableStatuses = await getCodeTableValues(/*"TBL_Statuses"*/ CodeTableEn.StatuseTable);
    // }
    //
    // if (Globals.tableListTypes.length < 7)
    // {
    //   const String sql = 'DROP TABLE IF EXISTS TBL_ListTypes';
    //   await _SqlInstant.executeSqlNoResult(sql);
    //   await this._createFilmTypesTable(await _SqlInstant.database, _SqlInstant.databaseVersion);
    //   Globals.tableListTypes = await getCodeTableValues(/*'TBL_ListTypes'*/ CodeTableEn.ListTypesTable);
    // }


  }

  Future<List<Map<String, dynamic>>> sortMap(List<Map<String, dynamic>> mapValues) async
  {
    List<ValueItemGlobal> list = [];
    List<Map<String, dynamic>> resultMaps = [];

    for (Map<String, dynamic> item in mapValues)
    {
      Map<String, Object?> json = {'label': (item['Description'] as String), 'value': item['ID'] as Object};
      final ValueItemGlobal valueItemGlobal = ValueItemGlobal.fromJson(json);
      list.add(valueItemGlobal);
    }

    list.sort((a, b) => a.label.compareTo(b.label));

    for (ValueItemGlobal item in list)
    {
      final Map<String, dynamic> map = {'ID': item.value as int, 'Description': item.label};
      resultMaps.add(map);
    }

    return resultMaps;
  }

  Future<void> _createMoviesTable(Database db, int databaseVersion) async
  {
    String sql = "";


    // sql = 'DROP DATABASE ${dataProvider.databaseName} IF EXISTS';
    // db.execute(sql);





    try
     {
       sql = '''CREATE TABLE  ${dataProvider.mainTableName}(
                  MovieID INTEGER PRIMARY KEY AUTOINCREMENT, 
                  Title       VARCHAR(200),
                  Description VARCHAR,
                  Director    VARCHAR(200),
                  Writer      VARCHAR(200),
                  Actors      VARCHAR,
                  ImagesLinks VARCHAR,
                  Year        VARCHAR(4),
                  Language    VARCHAR(12),
                  Country     VARCHAR(12),
                  Rated       VARCHAR,
                  Music       VARCHAR,
                  FirebaseID  VARCHAR(20) NULL,
                  Genre       VARCHAR,
                  StatusID    int,
                  FilmTypeID  int,
                  SelfLink    VARCHAR,
                  LastUpdateDate  VARCHAR(10),
                  IsFavorite      int,   
                  SubjectLabels   VARCHAR,
                  CardBackColor   VARCHAR(10),
                  FOREIGN KEY(MovieID) REFERENCES TBL_NotesChilds(noteID),
                  FOREIGN KEY(MovieID) REFERENCES TBL_NotesImages(noteID))''';

       await db.execute(sql);
     }
        catch (e)
    {
      print(e);
    }
  }

  Future<void> _createStatusesTable(Database db, int databaseVersion) async
  {
    String sql;


    sql = '''CREATE TABLE TBL_Statuses (
                 ID INTEGER PRIMARY KEY,
                 Description TEXT NOT NULL
                 )''';

    await db.execute(sql);

    await db.insert("TBL_Statuses", {'ID': 1, 'Description': 'לא בוצעה'});
    await db.insert("TBL_Statuses", {'ID': 2, 'Description': 'בוצעה חלקית'});
    await db.insert("TBL_Statuses", {'ID': 3, 'Description': 'הושלמה'});
    await db.insert("TBL_Statuses", {'ID': 4, 'Description': 'לארכיון'});
  }

  Future<void> createDatabaseFireBase(DataBase db) async
  {

    try
    {
      await _createDatabaseTableFireBase(db);

      await _createFilmTypesTableFireBase();
      await _createActorsTableFireBase();
      await _createGenresTableFireBase();
      await _createDirectorsTableFireBase();
      await _createSettingTableFireBase();

      // result = true;
    }
    catch (e)
    {
      print('error');
    }

    // return result;
  }

  Future<void> _createFilmTypesTable(Database db, int databaseVersion) async
  {
    String sql;


    try
    {
      sql = '''CREATE TABLE  TBL_FilmTypes (
                   ID INTEGER PRIMARY KEY,
                   Description TEXT NOT NULL
                   )''';

      await db.execute(sql);

      await db.insert('TBL_FilmTypes', {'ID': 1, 'Description': 'סרט'});
      await db.insert('TBL_FilmTypes', {'ID': 2, 'Description': 'סידרה'});
      await db.insert('TBL_FilmTypes', {'ID': 3, 'Description': 'דוקו'});
    }
    catch (e)
    {
      print('$e');
    }
  }

  Future<void> _createFilmTypesTableFireBase() async
  {
    bool result=false;
    dynamic data;
    Map<String, Object> dataToSend;



    // Create User record'
    dataToSend = {'ID': 1, 'Description': 'סרט'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_FilmTypes.json');

    dataToSend = {'ID': 2, 'Description': 'סידרה'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_FilmTypes.json');

    dataToSend = {'ID': 3, 'Description': 'דוקו'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_FilmTypes.json');

  }

  Future<void> _createActorsTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE IF NOT EXISTS TBL_Actors (
                   ID INTEGER PRIMARY KEY,
                   Description TEXT NOT NULL
                   )''';

      await db.execute(sql);

      await db.insert("TBL_Actors", {'ID': 1, 'Description': 'Robert De Niro'});
      await db.insert("TBL_Actors", {'ID': 2, 'Description': 'Jack Nicholson'});
      await db.insert("TBL_Actors", {'ID': 3, 'Description': 'Tom Cruise'});
      await db.insert("TBL_Actors", {'ID': 4, 'Description': 'Brad Pitt'});
      await db.insert("TBL_Actors", {'ID': 5, 'Description': 'Marlon Brando'});
      await db.insert("TBL_Actors", {'ID': 6, 'Description': 'Harvey Kyrtle'});
      await db.insert("TBL_Actors", {'ID': 7, 'Description': 'Denzel Washington'});
      await db.insert("TBL_Actors", {'ID': 8, 'Description': 'Daniel Day-Lewis'});
      await db.insert("TBL_Actors", {'ID': 9, 'Description': 'Leonardo DiCaprio'});
      await db.insert("TBL_Actors", {'ID': 10, 'Description': 'Paul Newman'});
      await db.insert("TBL_Actors", {'ID': 11, 'Description': 'Al Pacino'});
      await db.insert("TBL_Actors", {'ID': 12, 'Description': 'Tom Hanks'});
      await db.insert("TBL_Actors", {'ID': 13, 'Description': 'Cate Blanchett'});
      await db.insert("TBL_Actors", {'ID': 14, 'Description': 'Morgan Freeman'});
      await db.insert("TBL_Actors", {'ID': 15, 'Description': 'Julia Roberts'});
      await db.insert("TBL_Actors", {'ID': 16, 'Description': 'Jodie Foster'});
    }
    catch (e)
    {
      print('$e');
    }
  }

  Future<void> _createActorsTableFireBase() async
  {
    bool result=false;
    dynamic data;
    Map<String, Object> dataToSend;



    // Create User record'
    dataToSend = {'ID': 1, 'Description': 'Robert De Niro'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 2, 'Description': 'Jack Nicholson'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 3, 'Description': 'Tom Cruise'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 4, 'Description': 'Brad Pitt'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 5, 'Description': 'Marlon Brando'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 6, 'Description': 'Harvey Kyrtle'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 7, 'Description': 'Denzel Washington'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 8, 'Description': 'Daniel Day-Lewis'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 9, 'Description': 'Leonardo DiCaprio'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 10, 'Description': 'Paul Newman'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 11, 'Description': 'Al Pacino'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 12, 'Description': 'Tom Hanks'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 13, 'Description': 'Cate Blanchett'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 14, 'Description': 'Morgan Freeman'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 15, 'Description': 'Julia Roberts'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

    dataToSend = {'ID': 16, 'Description': 'Jodie Foster'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Actors.json');

  }

  Future<void> _createGenresTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE TBL_Genres (
                   ID INTEGER PRIMARY KEY,
                   Description TEXT NOT NULL
                   )''';

      await db.execute(sql);

      await db.insert("TBL_Genres", {'ID': 1, 'Description': 'מתח מסתורין'});
      await db.insert("TBL_Genres", {'ID': 2, 'Description': 'דרמה'});
      await db.insert("TBL_Genres", {'ID': 3, 'Description': 'אקשן'});
      await db.insert("TBL_Genres", {'ID': 4, 'Description': 'קומדיה'});
      await db.insert("TBL_Genres", {'ID': 5, 'Description': 'קומדיה רומנטית'});
      await db.insert("TBL_Genres", {'ID': 6, 'Description': 'אימה'});
      await db.insert("TBL_Genres", {'ID': 7, 'Description': 'מערבון'});
      await db.insert("TBL_Genres", {'ID': 8, 'Description': 'מדע בדיוני'});
      await db.insert("TBL_Genres", {'ID': 9, 'Description': 'דוקומנטרי'});
      await db.insert("TBL_Genres", {'ID': 10, 'Description': 'פנטזייה'});
    }
    catch (e)
    {
      print('$e');
    }
  }

  Future<void> _createEditorsTableFireBase() async
  {
    bool result=false;
    dynamic data;
    Map<String, Object> dataToSend;



    dataToSend = {'ID': 1, 'Description': 'Ridly Scott'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Editors.json');

  }

  Future<void> _createEditorsTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE TBL_Editors (
                   ID INTEGER PRIMARY KEY,
                   Description TEXT NOT NULL
                   )''';

      await db.execute(sql);

      await db.insert("TBL_Editors", {'ID': 1, 'Description': 'Ridly Scott'});
    }
    catch (e)
    {
      print('$e');
    }
  }

  Future<void> _createWritersTableFireBase() async
  {
    bool result=false;
    dynamic data;
    Map<String, Object> dataToSend;



    dataToSend = {'ID': 1, 'Description': 'Ridly Scott'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Writers.json');

  }

  Future<void> _createWritersTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE TBL_Writers (
                   ID INTEGER PRIMARY KEY,
                   Description TEXT NOT NULL
                   )''';

      await db.execute(sql);

      await db.insert("TBL_Writers", {'ID': 1, 'Description': 'Ridly Scott'});
    }
    catch (e)
    {
      print('$e');
    }
  }

  Future<void> _createMusiciansTableFireBase() async
  {
    bool result=false;
    dynamic data;
    Map<String, Object> dataToSend;



    dataToSend = {'ID': 1, 'Description': 'Enrico Maricana'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Musicians.json');

  }

  Future<void> _createMusiciansTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE TBL_Musicians (
                   ID INTEGER PRIMARY KEY,
                   Description TEXT NOT NULL
                   )''';

      await db.execute(sql);

      await db.insert("TBL_Musicians", {'ID': 1, 'Description': 'Enrico Maricana'});
    }
    catch (e)
    {
      print('$e');
    }
  }

  Future<void> _createGenresTableFireBase() async
  {
    bool result=false;
    dynamic data;
    Map<String, Object> dataToSend;



    // Create User record'
    dataToSend = {'ID': 1, 'Description': 'מתח מסתורין'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 2, 'Description': 'דרמה'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 3, 'Description': 'אקשן'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 4, 'Description': 'קומדיה'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 5, 'Description': 'קומדיה רומנטית'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 6, 'Description': 'אימה'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 7, 'Description': 'מערבון'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 8, 'Description': 'מדע בדיוני'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 9, 'Description': 'דוקומנטרי'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');

    dataToSend = {'ID': 10, 'Description': 'פנטזייה'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Genres.json');
  }

  Future<void> _createDirectorsTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE TBL_Directors (
                   ID INTEGER PRIMARY KEY,
                   Description TEXT NOT NULL
                   )''';

      await db.execute(sql);

      await db.insert("TBL_Directors", {'ID': 1, 'Description': 'Ridley Scott'});
      await db.insert("TBL_Directors", {'ID': 2, 'Description': 'Tony Scott'});
      await db.insert("TBL_Directors", {'ID': 3, 'Description': 'Martin Scorsese'});
      await db.insert("TBL_Directors", {'ID': 4, 'Description': 'Steven Spielberg'});
      await db.insert("TBL_Directors", {'ID': 5, 'Description': 'Quentin Tarantino'});
      await db.insert("TBL_Directors", {'ID': 6, 'Description': 'James Cameron'});
      await db.insert("TBL_Directors", {'ID': 7, 'Description': 'Francis Ford Coppola'});
      await db.insert("TBL_Directors", {'ID': 8, 'Description': 'Christopher Nolan'});
    }
    catch (e)
    {
      print('$e');
    }
  }

  Future<void> _createDirectorsTableFireBase() async
  {
    bool result=false;
    dynamic data;
    Map<String, Object> dataToSend;



    // Create User record'
    dataToSend = {'ID': 1, 'Description': 'Ridley Scott'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

    dataToSend = {'ID': 2, 'Description': 'Tony Scott'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

    dataToSend = {'ID': 3, 'Description': 'Martin Scorsese'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

    dataToSend = {'ID': 4, 'Description': 'Steven Spielberg'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

    dataToSend = {'ID': 5, 'Description': 'Quentin Tarantino'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

    dataToSend = {'ID': 6, 'Description': 'James Cameron'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

    dataToSend = {'ID': 7, 'Description': 'Francis Ford Coppola'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

    dataToSend = {'ID': 8, 'Description': 'Christopher Nolan'};
    data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Directors.json');

  }

  Future<void> _createNotesImagesTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      // sql = 'DROP TABLE TBL_NotesImages'; // IF EXISTS''';
      // await db.execute(sql);

      sql = '''CREATE TABLE IF NOT EXISTS TBL_NotesImages (
                   FirebaseID VARCHAR,
                   NoteID INTEGER ,
                   Image BLOB Not Null
                   )''';    // //ID INTEGER PRIMARY KEY AUTOINCREMENT,

      await db.execute(sql);

      // sql = '''ALTER TABLE $_tableName
      //               ADD CONSTRAINT FK_NotesImages
      //               FOREIGN KEY (NoteID)
      //               REFERENCES TBL_NotesImages(NoteID)''';
      //
      // await db.execute(sql);
    }
    catch (e)
    {
      print('$e');
    }


  }

  Future<void> _createNotesChildsTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE IF NOT EXISTS TBL_NotesChilds (
                   NoteID INTEGER  Not Null,
                   Title VARCHAR Not Null,
                   IsDone Bit
                   )''';    // //ID INTEGER PRIMARY KEY AUTOINCREMENT,

      await db.execute(sql);
    }
    catch (e)
    {
      print('$e');
    }

  }

  Future<void> _createSettingTable(Database db, int databaseVersion) async
  {
    String sql;

    try
    {
      sql = '''CREATE TABLE TBL_Settings (
                   SettingID          VARCHAR Not Null,
                   EarlyAlarmMinutes  INTEGER,
                   BuzzerMinutes      INTEGER,
                   DefaultDatabaseID  INTEGER,
                   ColorsPattern      INTEGER,
                   MainDatabaseUrl    VARCHAR Null,
                   MainDataName       VARCHAR Null,
                   UserEmail          VARCHAR NULL,
                   UserPassword       VARCHAR NULL
                   )''';    // //ID INTEGER PRIMARY KEY AUTOINCREMENT,

      await db.execute(sql);
    }
    catch (e)
    {
      print('$e');
    }

  }

  Future<void> _createSettingTableFireBase() async
  {
    final Map<String, Object> dataToSend = {'SettingID': 1, 'EarlyAlarmMinutes': 90, 'BuzzerMinutes': 20,
                                            'MainDataName': '', 'UserEmail': '', 'UserPassword': '',
                                            'DefaultDatabaseID': Null, 'ColorsPattern': '', 'MainDatabaseUrl': ''};
    String data = await NetworkHttp.post(this.dataProvider.CurrentDatabase!.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Settings.json');
  }

  Future<void> _createDatabaseTableFireBase(DataBase db) async
  {
    Map<String, Object?> dataToSend =
    {
      'ID': 1,
      'Title': db.Title,
      'DBName': db.DBName,
      'BaseUrl': db.BaseUrl,
      'BaseUrlForStorage': db.BaseUrlForStorage,
      'TypeID': DatabaseTypesEn.cloudDB.value,
      'NumeratorNotesID': 0,
      'FirebaseID': "",
    };

    // Create a Json object 'water.json'
    final String newRecordID = await this.dataProvider.DatabaseHelper.insertRecordByValues('TBL_Databases', dataToSend);
    //final String newNoteID = await NetworkHttp.post(db.BaseUrl, {'Content-Type': 'application/json'}, dataToSend, 'TBL_Databases.json');
    dataToSend =  {'FirebaseID': newRecordID};
    await this.dataProvider.DatabaseHelper.updateRecordInTable('TBL_Databases', dataToSend);
  }

  void _scrollerSet()
  {
    this.scrollPosition = keepScrollPosition;
    // this.scrollerIndex = keepScrollerIndex;
  }

  void _scrollerGet()
  {
    keepScrollPosition = this.scrollPosition;
    keepScrollerIndex = this.scrollerIndex;
  }

}

