



//import 'package:path/path.dart';

// import '../pages/ReminderPage.dart';
import 'package:flutter/material.dart';
import 'package:mhmovies/pages/MovieDetailsPage.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataProvider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
// import '../pages/GenericMultiLines.dart';
import '../pages/PicturePage.dart';
import '../pages/FavoritesPage.dart';
import '../pages/HomePage.dart';
// import '../pages/NoteDetailsPage.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';
import '../utils/Globals.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'enums/Enums.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NotificationHandle.dart';
import '../models/Movie.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/Utils.dart';




// ExMPLE FROM FLUTTER
// https://docs.flutter.dev/cookbook/forms/focus
// Build and release an iOS app
// https://pub.dev/packages/image_picker
// https://docs.flutter.dev/deployment/ios;
// https://stackoverflow.com/questions/52398521/flutter-ios-build-failure-error-with-multiple-commands-after-the-xcode-upgrade
// https://github.com/tekartik/sqflite/issues/952
// https://www.ernestchiang.com/en/posts/2020/flutter-itms-90078-missing-push-notification-entitlement/
// Try the following steps to resolve the issue:
//
// Run flutter clean in the terminal to clean the build files.
// Delete the ios and android directories in your Flutter project.
// Run flutter pub cache repair to repair the pub cache.
// Finally, run flutter run again to build and run your app.
// If the issue persists, try uninstalling and reinstalling the sqflite package by removing the sqflite entry from your pubspec.yaml file and then running flutter pub get. Finally, add the sqflite entry back to your pubspec.yaml file and run flutter pub get again.

// Upload App to AppStor
// Or open build/ios/archive/MyApp.xcarchive in Xcode.
//
// Click the Validate App button. If any issues are reported, address them and produce another build. You can reuse the same build ID until you upload an archive.
//
// After the archive has been successfully validated, click Distribute App.
// https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW73
// https://stackoverflow.com/questions/48104184/apple-guideline-5-1-1-legal-privacy-data-collection-and-storage
// Gif picture
// https://pixabay.com/gifs/search/3d/

//https://stackoverflow.com/questions/55015367/flutter-saving-files-locally-so-that-available-with-files-app
//https://dart.dev/language/class-modifiers




Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  Utils.WakelockScreenHandle(false);
  // Wakelock.toggle(on: true);

  await MainGlobals.init();


  runApp(
      ChangeNotifierProvider(
          create: (context) => DataProvider<Movie>(),
          child: MyApp()
      )
  );
}



class MyApp extends StatelessWidget   //StatefulWidget  //
{
  MyApp({super.key});

  String version = '';
  // The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final String routeHome = '/';
  final routeNotification = '/details';
  late BuildContext _context;
  // static int keepOld = 1; //MainGlobals.g_colorsPattern;
  // static Color applicationMainColor = Globals.g_mainMediumColor;
  static late ColorScheme appColorScheme /*= Globals.applicationColorScheme*/;      //ColorScheme.fromSeed(seedColor: applicationMainColor);
  late MyApp mainApp = this;



  Widget setApplicationMainColor(ColorScheme colorScheme)
  {
    MyApp.appColorScheme = colorScheme;
    // MyApp.applicationMainColor = applicationMainColor;
    return build(this._context);
  }


  @override
  Widget build(BuildContext context)
  {
    NotificationHandle.NavigatorKey = MyApp.navigatorKey;
    this.version = Globals.getVersionName(context);
    this._context = context;
    Globals.context = context;
    MainGlobals.context = context;
    const title = 'Movies Keeper';


    appColorScheme = MainGlobals.applicationColorScheme;

    return

      MaterialApp(
          title: title,
          locale: const Locale('he'),
          theme: ThemeData(colorScheme: MyApp.appColorScheme,  useMaterial3: true),
          navigatorKey: MyApp.navigatorKey,
          //onGenerateInitialRoutes: onGenerateInitialRoutes,
          onGenerateRoute: onGenerateRoute,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          debugShowCheckedModeBanner: false,
          supportedLocales: const
          [
            Locale('en', ''),
            Locale('he', ''),
            // Locale('zh', ''),
            // Locale('es', ''),
            // Locale('ru', ''),
            // Locale('ko', ''),
            // Locale('hi', ''),
          ],
          initialRoute: '/',
          navigatorObservers: [MovieDetailsPage.routeObserver],    // TODO: New
          routes:
          {
            '/home': (context) => /*const*/ HomePage(),
            '/favorite': (context) => const FavoritesPage(),
            '/details': (context) => MovieDetailsPage(),
            '/picture_big': (context) => const PicturePage(),
            // '/subject_labels': (context) => GenericMultiLines(title: 'ניהול פריטים', itemsList: [], mode: GenericPageModeEn.EmptyLines),
            // '/reminder_page': (context) =>  ReminderPage(title: 'תזכורת על משימה', subTitle: 'לקנות לחם שחור'),
          },


          home:
            Directionality(
                textDirection: TextDirection.rtl,
                child:
                  MyHomePage(title: title, version: this.version, mainApp: mainApp),

            )
      );

  }


  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName)
  {
    List<Route<dynamic>> pageStack = [];

    pageStack.add(
        MaterialPageRoute(
            builder: (_) =>

                Directionality(
                  textDirection: TextDirection.rtl,
                  child:
                  SafeArea(child: MyHomePage(title: 'משימות ופתקים', version: this.version, mainApp: mainApp)),
                )
        ));

    if (initialRouteName == this.routeNotification && NotificationHandle.initialAction != null)
    {
      // pageStack.add(
      //     MaterialPageRoute(
      //         builder: (_) => MovieDetailsPage(onNotificationActionReceived: NotificationHandle.initialAction! /*, routeName: ''*/)));
    }

    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings)
  {

    if (settings.name == this.routeHome)
    {
      return MaterialPageRoute(builder: (_) => SafeArea(child: MyHomePage(title: 'משימות ופתקים', version: this.version, mainApp: mainApp)));
    }
    else if (settings.name == this.routeNotification)
    {
      // ReceivedAction receivedAction = settings.arguments as ReceivedAction;
      // return MaterialPageRoute(builder: (_) => MovieDetailsPage(onNotificationActionReceived: receivedAction /*, routeName: ''*/));
    }

    return null;
  }

}







class MyHomePage extends StatefulWidget
{
  MyHomePage({super.key, required this.title, required this.version, required this.mainApp});

  final String title;
  final String version;
  Future<void> Function()?   onLoadInitAppRefresh;
  late MyApp mainApp;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage>    //with WidgetsBindingObserver
{
  int _currentIndex = 0;
  // final List<Widget> _screens = [/*const*/ HomePage<Movie>(), const FavoritesPage()];
  late BuildContext _context;
  bool isFirstTime = true;
  HomePage? homeWidget = null;
  FavoritesPage? favoritesWidget = null;
  static int keepOld = 1;


  @override
  void initState()
  {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose()
  {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeMetrics()
  // {
  //   // This is called when the screen size changes
  //   MainGlobals.g_physicalScreenSize = MainGlobals.getScreenSize(this._context);   //WidgetsBinding.instance.window.physicalSize;
  //   print("New physical size: ${MainGlobals.g_physicalScreenSize.width} , height: ${MainGlobals.g_physicalScreenSize.height}");
  //   // You would then typically call setState to rebuild the UI if needed
  // }

  void setApplicationMainColor(ColorScheme colorScheme)
  {
    setState(()
    {
      MyApp.appColorScheme = colorScheme;
      // MyApp.applicationMainColor = applicationMainColor;
      widget.mainApp.setApplicationMainColor(colorScheme);
    });
  }


  @override
  Widget build(BuildContext context)
  {
    this._context = context;
    Globals.context = context;
    MainGlobals.context = context;
    Widget screenWidget = const SizedBox();



    if (isFirstTime && !MainGlobals.isMainInitApplicationLoaded)
    {
      isFirstTime = false;
      this.initApplication();
    }

    if (_currentIndex == 0)
    {
      this.homeWidget ??= HomePage<Movie>() as HomePage?;    // ??=
      screenWidget = this.homeWidget as Widget;
    }
    else if (_currentIndex == 1)
    {
      this.favoritesWidget ??= const FavoritesPage();       // ??=
      screenWidget = this.favoritesWidget as Widget;
    }

    return

      Scaffold(
        backgroundColor: Colors.white70,  //MyApp.appColorScheme.primaryContainer,

        appBar:
          // Version Row
          AppBar(
            backgroundColor: MyApp.appColorScheme.inversePrimary,   //Theme.of(context).colorScheme.inversePrimary,
            centerTitle: false,
            title:
              // Version Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                [
                  Text(widget.title,
                    style: TextStyle(
                        color: MyApp.appColorScheme.primary,  //Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        shadows: [Shadow(offset: Offset.fromDirection(1.0, 5.0), color: Colors.white38, blurRadius: 5.0)]),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right),

                  const SizedBox(width: 10.0),

                  Text(widget.version,
                        style: const TextStyle(color: Colors.black38, fontSize: 18, fontWeight: FontWeight.w800),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left),
                ],
              ),
           ),

        //key: MyApp.navigatorKey,
        bottomNavigationBar:
          BottomNavigationBar(
                    currentIndex: _currentIndex,
                    backgroundColor: MyApp.appColorScheme.inversePrimary,   //Theme.of(context).colorScheme.inversePrimary,
                    selectedItemColor: Colors.white,   //MyApp.appColorScheme.primary,
                    unselectedItemColor: Colors.black,      // MyApp.appColorScheme.onSurfaceVariant,
                    items: const <BottomNavigationBarItem>
                    [
                        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'בית'),
                        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'מועדפים'),
                    ],

                    onTap: (value)
                    {
                      setState(()
                      {
                        _currentIndex = value;
                      });
                    }) ,


        body:
          Directionality(
              textDirection: TextDirection.rtl,
              child:

                screenWidget
          )

      );

  }



  Future<void> initApplication() async
  {

    MainGlobals.isMainInitApplicationLoaded = false;

    // Always initialize Awesome Notifications
    await NotificationHandle.init();

    await this.dataProvider.init('MH_Movies.db', 'TBL_Movies', 'mhmovies');   // Contained func 'readSettings()'

    // await this.dataProvider.readAllRecords(true, true);


    if (this.homeWidget != null && this.homeWidget!.homePageState != null)
    {
      widget.onLoadInitAppRefresh = this.homeWidget!.homePageState!.onLoadInitAppRefresh;
      // widget.onLoadInitAppRefresh = /*await*/(widget2 as HomePage<Note>).homePageState.onLoadInitAppRefresh;
    }

    if (widget.onLoadInitAppRefresh != null)
    {
      await widget.onLoadInitAppRefresh!();
    }

    MainGlobals.isMainInitApplicationLoaded = true;

    /*await*/ _getApplicationMainColor();

  }

  Future<void> _getApplicationMainColor() async
  {
    final Color applicationMainColor = MainGlobals.translateMainColor();
    ColorScheme colorScheme = MainGlobals.applicationColorScheme;

    // MyApp.appColorScheme = colorScheme;
    // MyApp.applicationMainColor = applicationMainColor;

    if (keepOld != MainGlobals.g_colorsPattern)
    {
      // setApplicationMainColor(colorScheme);
      // widget.mainApp.setApplicationMainColor(colorScheme);

      // setState(()   // Because the Drawer menu
      // {
        MyApp.appColorScheme = colorScheme;
      //   //MyApp.applicationMainColor = applicationMainColor;
      //    main();
      // });
      main();
    }

  }

  Future<void> onLoadInitAppRefresh() async
  {
    // setState(()
    // {
    //   // MainGlobals.isMainInitApplicationLoaded = true;
    // });
    // await main();
  }

  DataProvider get dataProvider
  {
    DataProvider<Movie> notesProvider = Provider.of<DataProvider<Movie>>(this._context, listen: false);
    // notesProvider.isEarlyAlarm = isEarlyAlarm;
    notesProvider.context = this._context;
    // notesProvider.onNotificationActionReceived = this.onNotificationActionReceived;
    // notesProvider.onNotificationDisplayed = this.onNotificationDisplayed;
    //notesProvider.onShowMessage = ShowMessage;
    return notesProvider;
  }

  // Widget chooseScreen()
  // {
  //   final Widget widget2 = _screens[0];
  //
  //   // if (_currentIndex==0)
  //   // {
  //     widget.onLoadInitAppRefresh = /*await*/(widget2 as HomePage<Movie>).homePageState.onLoadInitAppRefresh;
  //   // }
  //
  //   return widget2;
  // }


}

