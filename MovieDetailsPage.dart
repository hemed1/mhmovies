

// import '/pages/SavedScreen.dart';
// import '/utils/BookDetailsArguments.dart';
//https://pub.dev/packages/multiselect_dropdown_flutter/example
// https://pub.dev/packages/multi_dropdown/example
// https://pub.dev/packages/path_provider/example
// file:///Users/meirh/Desktop/Develope/Flutter/mh_movies/lib/Images/The_lord_of_the_ring-2.jpeg

//import 'package:multiselect_dropdown/multiselect_dropdown.dart';
// import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
// import 'package:multiselect/multiselect.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../enums/Enums.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataProvider.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';
import '/utils/Globals.dart';
import '/utils/MovieDetailsPageArguments.dart';
import '/utils/PicturePageArguments.dart';
import '../models/Movie.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetFullScreen.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetRichText.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetComboBox.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/ValueItemGlobal.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteChild.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/GenericMultiLines.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteImage.dart';
import 'package:kat_html_editor/kat_html_editor.dart';





class MovieDetailsPage extends StatefulWidget
{
  MovieDetailsPage({super.key});  //, required Movie movie});

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  late Map<String, Object?> actors    = transferDataForMap(Globals.tableActors);
  late Map<String, Object?> genres    = transferDataForMap(Globals.tableGenres);
  late Map<String, Object?> directors = transferDataForMap(Globals.tableDirectors);
  late Map<String, Object?> filmTypes = transferDataForMap(Globals.tableFilmTypes);
  late Map<String, Object?> writers   = transferDataForMap(Globals.tableWriters);
  late Map<String, Object?> editors   = transferDataForMap(Globals.tableEditors);
  late Map<String, Object?> musicians = transferDataForMap(Globals.tableMusicians);

  // Future<void> initCodeTables() async
  // {
  //
  //   try
  //   {
  //     // itemsActors = await this.dataProvider.readTable("TBL_Actors");
  //     actors = transferDataForMap(Globals.tableActors);
  //     genres = transferDataForMap(Globals.tableGenres);
  //     directors = transferDataForMap(Globals.tableDirectors);
  //     filmTypes = transferDataForMap(Globals.tableFilmTypes);
  //   }
  //   catch (e)
  //   {
  //     print(e);
  //     // MainGlobals.showSnackBar(context, 'Error in "dataProvider.readMainDatabases()": ${e.toString()}');
  //   }
  // }

  Map<String, dynamic> transferDataForMap(List<Map<String, dynamic>> list)
  {
    Map<String, dynamic> listTmp = {};

    for (var i = 0; i < list.length; i++)
    {
      Map<String, dynamic> record = list[i];
      // listTmp['${record['Description'] as String}'] = record['Description'] as String;
      listTmp['${record['ID'] as int}'] = record['Description'] as String;
      //Map<String, Object> singleMap = {'Item $i:', i};
      //list.putIfAbsent('Item $i', () => i);
      //list.add(singleMap);
    }

    return listTmp;
  }

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}



class _MovieDetailsPageState extends State<MovieDetailsPage>
{
  //#region vars
  TextEditingController controllerTitle = TextEditingController();
  MultiSelectController controllerDirector = MultiSelectController();
  MultiSelectController controllerActors = MultiSelectController();
  MultiSelectController controllerGenre = MultiSelectController();
  TextEditingController controllerFilmTypes = TextEditingController();
  TextEditingController controllerYear = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerLanguage = TextEditingController();
  MultiSelectController controllerWriter = MultiSelectController();
  MultiSelectController controllerEditors = MultiSelectController();
  MultiSelectController controllerMusic = MultiSelectController();
  TextEditingController controllerRate = TextEditingController();
  TextEditingController controllerSelfLink = TextEditingController();
  TextEditingController controllerImage1 = TextEditingController();
  TextEditingController controllerImage2 = TextEditingController();
  TextEditingController controllerImage3 = TextEditingController();
  TextEditingController controllerImage4 = TextEditingController();
  TextEditingController controllerDownloadFolder = TextEditingController();
  late WidgetRichText? widgetRichTextNormalScreen = null;
  late WidgetFullScreen? widgetRichTextFullScreen = null;
  late  GlobalKey<QuillHtmlEditorState> keyEditorDescription;
  late final QuillEditorController controllerDescriptionHtml;
  late double screenWidth;
  late double screenHeight;
  bool isImagesLinksOpen = true;
  bool isImagesLinksEdit = false;
  List<NoteImage> imagesList= [];
  List<NoteImage>? imagesListStart= null;
  late BuildContext _context = context as BuildContext;
  bool isUpdateMode = false;
  bool isSaved = false;
  bool isFirstTime = true;
  bool isFromFavoritePage = false;
  bool isRichText = false;
  String actionDesc='';
  late Movie CurrentMovie;
  bool isFullScreenMode = false;
  bool isAlreadyLoadedFullScreen = false;
  bool isAlreadyLoadedNormalScreen = false;
  late Widget? fullScreenWidget = null;
  late Widget normalPageWidget;
  late Widget mainWidget;
  final TextStyle _styleRichText = const TextStyle(fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: "sans-serif"/*, height: -10.0*/, letterSpacing: 0.0, wordSpacing: 0.0);
  String RichTextCaption  = "טקסט מעוצב";

  void Function(String message)? EvenDeleteSucss;
  //#endregion vars

  @override
  void initState()
  {
    super.initState();
    keyEditorDescription = GlobalKey<QuillHtmlEditorState>();
    controllerDescriptionHtml = QuillEditorController();
  }



  @override
  Widget build(BuildContext context)
  {
    this._context = context;
    MainGlobals.context = context;
    Globals.context = context;
    // Get Main object & Properties
    final args = ModalRoute.of(context)?.settings.arguments as MovieDetailsPageArguments;
    this.CurrentMovie = args.noteObject;
    final bool isUpdateMode = args.isUpdateMode;
    final theme = Theme.of(context).textTheme;
    EvenDeleteSucss = args.onEvenDeleteSucss;



    if (isFirstTime)
    {
      isFirstTime = false;
      MainGlobals.g_physicalScreenSize = MainGlobals.getScreenSize(
          _context); //WidgetsBinding.instance.window.physicalSize;
      screenWidth = MainGlobals.g_physicalScreenSize.width - 40.0;
      screenHeight = MainGlobals.g_physicalScreenSize.height - 160.0;
      if (this.CurrentMovie.Images.isEmpty)
      {
        this.CurrentMovie.Images = [];
      }
      MainGlobals.keepNoteImages(this.CurrentMovie);
      if (isUpdateMode)
      {
        setRecordToObject(this.CurrentMovie);
      }
    }

    imagesList = this.CreateValidUrlsToShowImage();
    imagesListStart = imagesList;
    isImagesLinksOpen = imagesList.isNotEmpty;

    // Get Widget between Normal page & Note text full page
    if (isFullScreenMode)
    {
      // Widget for full Note text page
      if (!isAlreadyLoadedFullScreen)
      {
        if (fullScreenWidget == null)
        {
          widgetRichTextFullScreen = WidgetFullScreen<Movie>(this.CurrentMovie, this.controllerDescription, this.controllerDescriptionHtml, this.keyEditorDescription, oExitFullScreen);
          fullScreenWidget = widgetRichTextFullScreen;
        }
        mainWidget = fullScreenWidget!;
      }
    }
    else
    {
      if (!isAlreadyLoadedNormalScreen)
      {
        isAlreadyLoadedNormalScreen = true;
        // Widget of the Normal page
        normalPageWidget = getNormalScreenWidget(this.CurrentMovie);
        mainWidget = normalPageWidget;
      }
    }


    return

      Scaffold(
        appBar: AppBar(title: Text(this.CurrentMovie.Title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                       actions:
                       [
                          // Top Buttons
                          SizedBox(width: 315.0, height: 40.0,    // For space between buttons
                          child:
                            Center(
                            child:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:
                                [
                                  // Delete button
                                  if (isUpdateMode == true && !this.isFromFavoritePage)
                                    SizedBox(width: 115.0,
                                      child:
                                      //IconButton(
                                      ElevatedButton.icon(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith(MainGlobals.getColorForButtons),
                                            elevation: MaterialStateProperty.resolveWith(MainGlobals.getElevationForButtons)),
                                        icon:  const Icon(Icons.delete, color: Colors.red, size: 28.0, fill: 1.0, textDirection: TextDirection.rtl),
                                        label: const Text('מחק', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16.0)),
                                        onPressed: () async
                                        {
                                          // await this.dataProvider.deleteRecord([ this.CurrentNote.NoteID ]);
                                          actionDesc='deleted';
                                          this.isSaved = true;
                                          Navigator.pop(context, actionDesc);
                                          if (EvenDeleteSucss !=null)
                                          {
                                            // EvenDeleteSucss!(' רשומה מספר ${this.CurrentNote.NoteID} נמחקה');
                                          }
                                        },

                                      ),
                                    ),


                                  // Save button
                                  if (!this.isFromFavoritePage)
                                    SizedBox(width: 115.0,
                                      child:
                                      //IconButton(
                                      ElevatedButton.icon(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith(MainGlobals.getColorForButtons),
                                            elevation: MaterialStateProperty.resolveWith(MainGlobals.getElevationForButtons)),
                                        //shape: MaterialStateProperty.resolveWith(getShapeForButtons),                                                   ),
                                        icon:  const Icon(Icons.save, color: Colors.green, size: 28.0, fill: 1.0, textDirection: TextDirection.rtl),
                                        label: const Text('שמור', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16.0)),
                                        onPressed: () async
                                        {
                                          //arguments.isEarlyAlarm = this.isEarlyAlarm;
                                          await saveRecord(isUpdateMode, 1);
                                        },
                                      ),
                                    ),


                                  // favorite button
                                  if (isUpdateMode == true)
                                    IconButton(
                                      onPressed: () async
                                      {
                                        await this.dataProvider.saveFavorite(this.CurrentMovie);
                                        setState(()
                                        {
                                          // Your state change code goes here
                                        });
                                      },
                                      highlightColor: Theme.of(context).colorScheme.primary,
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith(MainGlobals.getColorForButtons),
                                          elevation: MaterialStateProperty.resolveWith(MainGlobals.getElevationForButtons)),
                                      icon: Icon(((this.CurrentMovie.IsFavorite) ? Icons.favorite : Icons.favorite_border), color: Theme.of(context).colorScheme.primary, size: 28.0, fill: 1.0, textDirection: TextDirection.rtl),
                                    ),

                                ]
                            ),
                          ),
                        ),
                      ]),


        body:
          Directionality(
            textDirection: TextDirection.rtl,
            child:

              mainWidget

          )
    );


  }

  Future<void> oExitFullScreen(String text) async
  {
    // if (MainGlobals.isItRichText(text))
    // {
    //   await this.controllerDescriptionHtml.setText(text);
    // }
    // else
    // {
    //   this.controllerDescription.text = text;
    // }

    setState(()
    {
      isAlreadyLoadedFullScreen = false;
      isFullScreenMode = false;
      isAlreadyLoadedNormalScreen = false;
    });
  }

  /// Widget of the Normal page
  Widget getNormalScreenWidget(Movie movie)
  {

    final List<ToolBarStyle> customToolBarList =
    [
      ToolBarStyle.bold,
      ToolBarStyle.underline,
      // ToolBarStyle.italic,
      ToolBarStyle.color,
      ToolBarStyle.background,
      ToolBarStyle.align,
      ToolBarStyle.listBullet,
      ToolBarStyle.listOrdered,
      // ToolBarStyle.size,
      ToolBarStyle.directionRtl,
      ToolBarStyle.directionLtr,
      ToolBarStyle.redo,
      ToolBarStyle.undo,
      // ToolBarStyle.addTable,
      // ToolBarStyle.editTable,
    ];

    if (widgetRichTextNormalScreen == null)
    {
      String tmpDesc = this.CurrentMovie.Description;       // controllerDescription.text;    // (widgetRichTextNormalScreen != null) ? widgetRichTextNormalScreen!.getHtmlText() : this.CurrentNote.Description ;
      // tmpDesc = controllerDescriptionHtml.getText();
      widgetRichTextNormalScreen = WidgetRichText(
                                      keyEditor: keyEditorDescription,
                                      initValue: tmpDesc,
                                      controller: controllerDescriptionHtml,
                                      backgroundColor: Theme.of(_context).colorScheme.primaryContainer.withOpacity(0.30),
                                      toolBarConfig: customToolBarList,
                                      fontFamilyName: "arial",
                                      hint: 'הקלד הערות נוספות',
                                      lineSpacing: 0.0,
                                      toolBarPosition: 1,    /*BarPosition.TOP,*/
                                      textStyle: _styleRichText,
                                      iconSize: 25.0,
                                      height: 153.0,
                                      width: screenWidth);
      tmpDesc = widgetRichTextNormalScreen!.adjustRichText(tmpDesc);
      widgetRichTextNormalScreen!.setHtmlText(tmpDesc);
      // Because we need Async await
      // setRichTextBetweenScreens(widgetRichTextNormalScreen!, true,true);
    }
    widgetRichTextNormalScreen!.toolBarConfig = customToolBarList;


    return

      // Main container
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:
        [
          Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top:5.0, bottom: 5.0),
              margin:  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,bottom: 10.0),
              height: screenHeight - 20.0,
              width:  screenWidth - 20.0,
              decoration: BoxDecoration(
                  color: Theme.of(_context).colorScheme.primaryContainer.withOpacity(0.2),    //.inversePrimary
                  border: Border.all(color: Theme.of(_context).colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(7.0))),

              child:
                SingleChildScrollView(
                  // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  child:

                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                      [
                        // Buttons Row
                        SizedBox(height: 37.0,        //width: 110.0,
                          child:
                            Row(
                              textDirection: TextDirection.rtl,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                              [
                                // 'מסך מלא' button
                                SizedBox(height: 34.0,
                                  child:
                                    TextButton(
                                        child: Text('מסך מלא', style: MainGlobals.g_styleButtonsSub),
                                        onPressed: ()   async
                                        {
                                          String tmp = '';
                                          if (this.isRichText)
                                          {
                                            tmp = await widgetRichTextNormalScreen!.getHtmlText();
                                          }
                                          setState(()
                                          {
                                            if (this.isRichText)
                                            {
                                              // if (widgetRichTextFullScreen != null)
                                              // {
                                              //   widgetRichTextFullScreen!.initValue = tmp;
                                              //   widgetRichTextFullScreen!.setHtmlText(tmp);
                                              //   // await setRichTextBetweenScreens(widgetRichTextFullScreen!, true);
                                              // }
                                              controllerDescription.text = tmp;
                                            }
                                            // Widget of Note text page
                                            isFullScreenMode = true;
                                            isAlreadyLoadedFullScreen = false;
                                          });
                                        })),


                                // Button - Close images & links
                                SizedBox(height: 37.0,
                                  child:
                                    TextButton(
                                      onPressed: ()
                                      {
                                        setState(()
                                        {
                                          isImagesLinksEdit = !isImagesLinksEdit;
                                          isAlreadyLoadedNormalScreen = false;
                                        });
                                      },
                                      child:
                                      Text('לינקים', style: MainGlobals.g_styleButtonsSub),
                                      // const Row(
                                      // children:
                                      // [
                                      //   // Text('More...', style: TextStyle(color: Colors.blue, fontSize: 11.0,),),
                                      //   Icon(Icons.open_in_browser, size: 25.0,)
                                      // ]),
                                    )),


                                // SubTasks screen - Generic screen with rows & checkboxes
                                SizedBox(height: 37.0,
                                  child:
                                    TextButton(
                                        child:
                                          Text('פריטים נוספים', style: MainGlobals.g_styleButtonsSub),
                                        onPressed: () async
                                        {
                                          // Open generic page, with rows of TextBoxes & CheckBoxes
                                          await openSubTasksScreen();
                                        })),


                                // Pictures screen
                                SizedBox(height: 37.0,    //width:80.0
                                  child:
                                    TextButton(
                                        child: Text('תמונות', style: MainGlobals.g_styleButtonsSub),
                                        onPressed: () async
                                        {
                                          final List<NoteImage> list = imagesListStart!;
                                          list.addAll(this.CurrentMovie.Images);
                                          await Navigator.pushNamed(_context, '/picture_big', arguments: PicturePageArguments(images: list, movieTitle: this.CurrentMovie.Title, movie: this.CurrentMovie));
                                        })),

                              ])),

                        const SizedBox(height: 5.0),

                        // Scroll Images
                        if (isImagesLinksOpen)
                          Container(
                            height: 140,
                            width: screenWidth + 5.0,
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                            decoration: BoxDecoration(
                              //color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                                border: Border.all(color: Colors.black87, width: 0.7),   // Theme.of(context).colorScheme.secondary
                                borderRadius: const BorderRadius.all(Radius.circular(7.0))),

                            child:
                              ListView.builder(
                                itemCount: imagesList.length,
                                physics: const BouncingScrollPhysics(),   // ClampingScrollPhysics(),mNeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index)
                                {
                                  Widget? imageWidget = null;
                                  if (imagesList[index].Image.isEmpty && MainGlobals.isUrlValid(imagesList[index].ImageName))
                                  {
                                    imageWidget = MainGlobals.extractUrl(imagesList[index].ImageName, true);
                                  }
                                  else
                                  {
                                    imageWidget = Image.memory(imagesList[index].Image);
                                  }


                                  return
                                    GestureDetector(
                                      child:
                                        Card(
                                          elevation: 4.0,
                                          child:
                                            SizedBox(
                                              width: 90.0,
                                              height: 50.0,     //double.infinity,    // 50.0,

                                              child:
                                                imageWidget

                                          )
                                      ),
                                      onDoubleTap: ()
                                      {
                                        Navigator.pushNamed(context, '/picture_big', arguments: PicturePageArguments(images: imagesList, movieTitle: this.CurrentMovie.Title, movie: this.CurrentMovie));
                                      },
                                    );
                                }
                            ),
                          ),

                        // Button - Show/Hide Scrolls Images
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                          [
                            IconButton(
                                onPressed: ()
                                {
                                  setState(()
                                  {
                                    isImagesLinksOpen = !isImagesLinksOpen; //imagesList.isNotEmpty;
                                    isAlreadyLoadedNormalScreen = false;
                                  });
                                },
                                icon: const Icon(Icons.picture_in_picture)),
                            Text(this.CurrentMovie.MovieID.toString())
                          ],
                        ),

                        const SizedBox(height: 5.0),

                        // Get Images links TextBox
                        if (isImagesLinksEdit)
                          Column(
                              children:
                              [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.ltr,
                                    children:
                                    [
                                      SizedBox(width: screenWidth - 10.0,     //height: 60,
                                          child:
                                          TextField(
                                            controller: controllerImage1,
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(fontSize: 15.0, ),
                                            decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: 'תמונה 1',
                                                icon: IconButton(icon: const Icon(Icons.file_download_outlined, size: 20.0),
                                                    onPressed: () async
                                                    {
                                                      Map<String, Object?>? image = await MainGlobals.pickImageFromLibrary();
                                                      if (image != null)
                                                      {
                                                        final String path = image['key'] as String;
                                                        final Uint8List codesList = image['value'] as Uint8List;    //List<int>;
                                                        File file = File(path);
                                                        final int index = path.lastIndexOf('/');
                                                        if (index>-1)
                                                        {
                                                          String name = path.substring(index+1);
                                                          await file.copy(join(MainGlobals.directoryLibrary.path, name));
                                                        }
                                                        NoteImage noteImage = NoteImage(NoteID: this.CurrentMovie.MovieID, Image: codesList, FirebaseID: this.CurrentMovie.FirebaseID);
                                                        //this.CurrentMovie.Images.add(noteImage);
                                                        controllerImage1.text = path;
                                                        setState(()
                                                        {

                                                        });
                                                      }
                                                    })),
                                          )),
                                    ]),


                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.ltr,
                                    children:
                                    [
                                      SizedBox(width: screenWidth - 10.0,       //height: 60,
                                          child:
                                          TextField(
                                            controller: controllerImage2,
                                            keyboardType: TextInputType.text,
                                            style: const TextStyle(fontSize: 15.0),
                                            decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: 'תמונה 2',
                                                icon: IconButton(icon: const Icon(Icons.file_download_outlined, size: 20.0),
                                                    onPressed: () async
                                                    {
                                                      Map<String, Object?>? image = await MainGlobals.pickImageFromLibrary();
                                                      if (image != null)
                                                      {
                                                        final String path = image['key'] as String;
                                                        final Uint8List codesList = image['value'] as Uint8List;    //List<int>;
                                                        File file = File(path);
                                                        final int index = path.lastIndexOf('/');
                                                        if (index>-1)
                                                        {
                                                          String name = path.substring(index+1);
                                                          await file.copy(join(MainGlobals.directoryLibrary.path, name));
                                                        }
                                                        NoteImage noteImage = NoteImage(NoteID: this.CurrentMovie.MovieID, Image: codesList, FirebaseID: this.CurrentMovie.FirebaseID);
                                                        //this.CurrentMovie.Images.add(noteImage);
                                                        controllerImage2.text = path;
                                                        setState(()
                                                        {
                                                        });
                                                      }
                                                    })),
                                          )),

                                    ]),


                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.ltr,
                                    children:
                                    [
                                      SizedBox(width: screenWidth - 10.0,     //height: 60,
                                          child:
                                          TextField(
                                              controller: controllerImage3,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: 'תמונה 3', icon: IconButton(icon: const Icon(Icons.file_download_outlined, size: 20.0),
                                                  onPressed: () async
                                                  {
                                                    Map<String, Object?>? image = await MainGlobals.pickImageFromLibrary();
                                                    if (image != null)
                                                    {
                                                      final String path = image['key'] as String;
                                                      final Uint8List codesList = image['value'] as Uint8List;    //List<int>;
                                                      File file = File(path);
                                                      final int index = path.lastIndexOf('/');
                                                      if (index>-1)
                                                      {
                                                        String name = path.substring(index+1);
                                                        await file.copy(join(MainGlobals.directoryLibrary.path, name));
                                                      }
                                                      NoteImage noteImage = NoteImage(NoteID: this.CurrentMovie.MovieID, Image: codesList, FirebaseID: this.CurrentMovie.FirebaseID);
                                                      //this.CurrentMovie.Images.add(noteImage);
                                                      controllerImage3.text = path;
                                                      setState(() async
                                                      {});
                                                    }
                                                  })),
                                              style: const TextStyle(fontSize: 15.0))),

                                      // SizedBox(width: 24, height: 24,
                                      //   child:
                                      //     TextButton(
                                      //       onPressed: () async
                                      //       {
                                      //         Map<String, Object>? image = await MainGlobals.pickImageFromLibrary();
                                      //         if (image != null)
                                      //         {
                                      //           final String path = image['key'] as String;
                                      //           //final Uint8List imageBytes = image['key'] as Uint8List;
                                      //           setState(()
                                      //           {
                                      //             controllerImage3.text = path;
                                      //           });
                                      //         }
                                      //       },
                                      //       isSemanticButton: true,
                                      //       child: const Icon(Icons.file_download_outlined, size: 24.0))),
                                    ]),


                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textDirection: TextDirection.ltr,
                                    children:
                                    [
                                      SizedBox(width: screenWidth - 10.0,     //height: 60,
                                          child:
                                          TextField(
                                              controller: controllerImage4,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: 'תמונה 4',
                                                  icon: IconButton(icon: const Icon(Icons.file_download_outlined, size: 20.0),
                                                      onPressed: () async
                                                      {
                                                        Map<String, Object?>? image = await MainGlobals.pickImageFromLibrary();

                                                        if (image != null)
                                                        {
                                                          final String path = image['key'] as String;
                                                          final Uint8List codesList = image['value'] as Uint8List;    //List<int>;
                                                          File file = File(path);
                                                          final int index = path.lastIndexOf('/');
                                                          if (index>-1)
                                                          {
                                                            String name = path.substring(index+1);
                                                            await file.copy(join(MainGlobals.directoryLibrary.path, name));
                                                          }
                                                          NoteImage noteImage = NoteImage(NoteID: this.CurrentMovie.MovieID, Image: codesList, FirebaseID: this.CurrentMovie.FirebaseID);
                                                          //this.CurrentMovie.Images.add(noteImage);
                                                          controllerImage4.text = path;
                                                          setState(()
                                                          {

                                                          });
                                                        }
                                                      })),
                                              style: const TextStyle(fontSize: 15.0)
                                          )),

                                    ]),


                                // Self Link field
                                TextField(
                                    controller: controllerSelfLink,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Self Link',
                                    ),
                                    style: const TextStyle(fontSize: 15.0)),

                                // Download Folder
                                TextField(
                                    controller: controllerDownloadFolder,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Folder',
                                    ),
                                    style: const TextStyle(fontSize: 15.0)),
                              ]),

                        const SizedBox(height: 20.0),


                        // ---------------------------------------------------------------------- //
                        // Show Movie Details Textbox fields under the Image
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            textDirection: TextDirection.rtl,
                            children:
                            [
                              // Title, ID Caption
                              Column(
                                children:
                                [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children:
                                    [
                                      Text('כותרת  (חובה להקליד)', style: MainGlobals.g_styleFieldsCaptions),
                                      if (isUpdateMode == true)
                                        Text('${this.CurrentMovie.MovieID}', textAlign: TextAlign.left, style: const TextStyle(fontSize: 14.0)),
                                      // Film Types
                                      SizedBox(height: 32.0, width: 130.0,
                                          child:
                                          WidgetComboBox(
                                            selectionType: ComboBoxType.single,
                                            Items: widget.filmTypes,
                                            // TODO: controllerObjectMulti: controllerSubjects,
                                            // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                            selectedValue: MainGlobals.getGlobalTablesValueToValueItemGlobals(Globals.tableFilmTypes, this.CurrentMovie.FilmTypeID),
                                            title: 'סוג',
                                            height: 200.0,
                                            SelectedItemBackgroundColor: Theme.of(_context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                            SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                            BackgroundColor: Theme.of(_context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                            ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                            onChanged: (List<ValueItemGlobal> selectedItems)
                                            {
                                              controllerFilmTypes.text = selectedItems[0].value as String;
                                            },
                                          )),
                                    ],
                                  ),

                                  const SizedBox(height: 5.0),

                                  // Title field
                                  Container(
                                      padding: const EdgeInsets.only(left: 5.0, top: 0.3, right: 5.0, bottom: 0.3),
                                      decoration: BoxDecoration(
                                          color: Theme.of(_context).colorScheme.primaryContainer.withOpacity(0.3),
                                          border: Border.all(color: Colors.grey  /*Theme.of(context).colorScheme.secondary*/, width: 0.7),
                                          borderRadius: const BorderRadius.all(Radius.circular(7.0))),
                                      child:
                                      TextField(
                                        controller: controllerTitle,
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,    // TODO: maybe to delete, it's parent component haz already value
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        autofocus: true,
                                        showCursor: true,
                                        autocorrect: false,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          fillColor: Theme.of(_context).colorScheme.primaryContainer.withOpacity(0.2),
                                          focusColor: Theme.of(_context).colorScheme.primary,
                                          border: InputBorder.none,
                                          hintText: 'הקלד/י כותרת...',
                                          hintStyle:  MainGlobals.g_styleFieldsCaptions.copyWith(color: Colors.blueGrey),
                                          labelStyle: MainGlobals.g_styleFieldsCaptions.apply(fontSizeDelta: 1.0),
                                          // enabledBorder: InputBorder.none,  // const UnderlineInputBorder()
                                          // focusedBorder: const OutlineInputBorder(gapPadding: 10.0, borderSide: BorderSide(color: Colors.grey, style: BorderStyle.solid)),
                                          // labelText:   'כותרת (שדה חובה)',

                                          //helperText: 'הקלד כותרת ...',
                                        ),
                                        style: MainGlobals.styleFieldsText.copyWith(fontSize: 25, decoration: (this.CurrentMovie.StatusID == NoteStatusEn.Completed.value || this.CurrentMovie.StatusID == NoteStatusEn.PartialCompleted.value) ? TextDecoration.lineThrough : TextDecoration.none),
                                      )),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Description field
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:
                                  [
                                    // Caption
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:
                                      [

                                        Text('תיאור', style: MainGlobals.g_styleFieldsCaptions, textAlign: TextAlign.right),

                                        // Switch to Rich Text
                                        SizedBox(height: 36.0,
                                          child:
                                          TextButton(
                                              child: Text(this.RichTextCaption, textAlign: TextAlign.right, style: MainGlobals.g_styleFieldsCaptions),
                                              onPressed: ()   async
                                              {
                                                if (this.isRichText)
                                                {
                                                  await switchNormalTextMode(true);
                                                }
                                                else
                                                {
                                                  await switchRichTextMode(true);
                                                }
                                              }),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 2.0),

                                    // Description field
                                    Container(
                                      padding: const EdgeInsets.only(left: 5.0, top: 3.0, right: 5.0, bottom: 3.0),
                                      decoration: BoxDecoration(
                                          color: Theme.of(_context).colorScheme.primaryContainer.withOpacity(0.3),
                                          border: Border.all(color: Theme.of(_context).colorScheme.secondary),
                                          borderRadius: const BorderRadius.all(Radius.circular(9.0))),
                                      height: 170.0,
                                      child:
                                        TextField(
                                        controller: controllerDescription,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'הקלד/י הערות נסופות...',
                                          hintStyle:  MainGlobals.g_styleFieldsCaptions.copyWith(color: Colors.blueGrey),
                                          //labelText: 'Description'
                                        ),
                                        style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18, fontStyle: FontStyle.italic),
                                        scrollPhysics: const BouncingScrollPhysics(),
                                        scrollPadding: const EdgeInsets.only(left: 5.0),
                                        maxLines: 6,
                                        showCursor: true,
                                        autocorrect: false,
                                        //overflow: TextOverflow.ellipsis
                                        //textInputAction: TextInputAction.newline,
                                      ),
                                      //Text(this.CurrentMovie.Description, style: theme.bodyMedium, maxLines: 6),
                                    ),
                                  ]),

                              const SizedBox(height: 10),

                              // Director, Actors, Writer, genres
                              Container(
                                  padding: const EdgeInsets.only(left: 7.0, top: 7.0, right: 7.0, bottom: 7.0),
                                  decoration: BoxDecoration(
                                      color: Theme.of(_context).colorScheme.primaryContainer.withOpacity(0.3),
                                      border: Border.all(color: Colors.grey  /*Theme.of(context).colorScheme.secondary*/, width: 0.7),
                                      borderRadius: const BorderRadius.all(Radius.circular(7.0))),
                                  // height: 140.0,
                                  child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      textDirection: TextDirection.rtl,
                                      children:
                                      [
                                        // Genre
                                        Column(
                                          children:
                                          [
                                            // Caption
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                              children:
                                              [
                                                Text('ג׳נרים', style: MainGlobals.g_styleFieldsCaptions),
                                              ],
                                            ),

                                            const SizedBox(height: 1.0),

                                            // ComboBox Genres, + Button
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              textDirection: TextDirection.rtl,
                                              children:
                                              [
                                                SizedBox(height: 35.0, width: screenWidth-60.0,
                                                  child:
                                                    WidgetComboBox(
                                                      selectionType: ComboBoxType.multi,
                                                      Items: widget.genres,
                                                      // TODO: controllerObjectMulti: controllerSubjects,
                                                      // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                                      selectedValue: MainGlobals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(Globals.tableGenres, this.CurrentMovie.Genre),
                                                      title: 'ג׳נרים',
                                                      height: 400.0,
                                                      textDirection: TextDirection.rtl,
                                                      SelectedItemBackgroundColor: Theme.of(_context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                      SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                      BackgroundColor: Theme.of(_context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                      ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                      onChanged: (List<ValueItemGlobal> selectedItems)
                                                      {
                                                        final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                        controllerGenre.setOptions(items);
                                                      },
                                                    )),

                                                const SizedBox(width: 3.0),

                                                // Add button - Open new page for manage the Subjects
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child:
                                                    SizedBox(height: 30.0, width: 30,
                                                      child:
                                                        IconButton(
                                                            color: Theme.of(_context).colorScheme.primary,
                                                            //splashRadius:
                                                            icon: const Icon(Icons.add, size: 29.0,),
                                                            iconSize: 30.0,
                                                            onPressed: () async
                                                            {
                                                              List<String> list = Globals.tableGenres.map((e) => e['Description'] as String).toList();
                                                              List<NoteChild> listToShow = [];
                                                              for (int i=0; i<list.length; i++)
                                                              {
                                                                NoteChild noteChild = NoteChild(NoteID: this.CurrentMovie.MovieID, Title: list[i], IsDone: false, FirebaseID: '');
                                                                listToShow.add(noteChild);
                                                              }
                                                              Object? resultNavigator = await Navigator.push(_context, MaterialPageRoute(builder: (context) =>
                                                                  GenericMultiLines(
                                                                      title: 'ניהול ג׳נרים',
                                                                      itemsList: listToShow,
                                                                      mode: GenericPageModeEn.EmptyLines,
                                                                      isFullPage: true,
                                                                      onConfirmEvent: null)));
                                                              if (resultNavigator != null)
                                                              {
                                                                List<String> list = (resultNavigator as List<NoteChild>).map((e) => e.Title).toList();
                                                                await dataProvider.saveNewLookupRecords('TBL_Genres', list);
                                                                setState(()
                                                                {});
                                                              }
                                                            }
                                                        )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 2.0),

                                        // Directors
                                        Column(
                                          children:
                                          [
                                            // Caption
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                              children:
                                              [
                                                Text('במאים', style: MainGlobals.g_styleFieldsCaptions),
                                              ],
                                            ),

                                            const SizedBox(height: 2.0),

                                            // Directors ComboBox
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              textDirection: TextDirection.rtl,
                                              children:
                                              [
                                                SizedBox(height: 35.0, width: screenWidth-60.0,
                                                  child:
                                                    WidgetComboBox(
                                                        selectionType: ComboBoxType.multi,
                                                        Items: widget.directors,
                                                        // TODO: controllerObjectMulti: controllerDirector,
                                                        // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                                        selectedValue: MainGlobals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(Globals.tableDirectors, this.CurrentMovie.Director),
                                                        title: 'במאיים',
                                                        height: 400.0,
                                                        textDirection: TextDirection.ltr,
                                                        SelectedItemBackgroundColor: Theme.of(_context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                        SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                        BackgroundColor: Theme.of(_context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                        ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                        onChanged: (List<ValueItemGlobal> selectedItems)
                                                        {
                                                          final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                          controllerDirector.setOptions(items);
                                                        })),

                                                const SizedBox(width: 3.0),

                                                // Add button - Open new page for manage the Subjects
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child:
                                                    SizedBox(height: 30.0, width: 30,
                                                      child:
                                                        IconButton(
                                                            color: Theme.of(_context).colorScheme.primary,
                                                            icon: const Icon(Icons.add, size: 29.0,),
                                                            iconSize: 30.0,
                                                            onPressed: () async
                                                            {
                                                              List<String> list = Globals.tableDirectors.map((e) => e['Description'] as String).toList();
                                                              List<NoteChild> listToShow = [];
                                                              for (int i=0; i<list.length; i++)
                                                              {
                                                                NoteChild noteChild = NoteChild(NoteID: this.CurrentMovie.MovieID, Title: list[i], IsDone: false, FirebaseID: '');
                                                                listToShow.add(noteChild);
                                                              }
                                                              Object? resultNavigator = await Navigator.push(_context, MaterialPageRoute(builder: (context) =>
                                                                  GenericMultiLines(
                                                                      title: 'במאים',
                                                                      itemsList: listToShow,
                                                                      mode: GenericPageModeEn.EmptyLines,
                                                                      isFullPage: true,
                                                                      onConfirmEvent: null)));
                                                              if (resultNavigator != null)
                                                              {
                                                                List<String> list = (resultNavigator as List<NoteChild>).map((e) => e.Title).toList();
                                                                await dataProvider.saveNewLookupRecords('TBL_Directors', list);
                                                                Globals.tableWriters = await this.dataProvider.getCodeTableValues("TBL_Directors");
                                                                setState(()
                                                                {
                                                                  isAlreadyLoadedNormalScreen;
                                                                  widget.directors = widget.transferDataForMap(Globals.tableDirectors);
                                                                });
                                                              }
                                                            }
                                                        )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 2.0),

                                        // Actors
                                        Column(
                                          children:
                                          [
                                            // Caption
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              // crossAxisAlignment: CrossAxisAlignment.end,
                                              children:
                                              [
                                                Text('שחקנים', style: MainGlobals.g_styleFieldsCaptions),
                                              ],
                                            ),

                                            const SizedBox(height: 2.0),

                                            // Actors ComboBox
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              textDirection: TextDirection.rtl,
                                              children:
                                              [
                                                SizedBox(height: 35.0, width: screenWidth-60.0,
                                                  child:
                                                    WidgetComboBox(
                                                      selectionType: ComboBoxType.multi,
                                                      Items: widget.actors,
                                                      // TODO: controllerObjectMulti: controllerActors,
                                                      // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                                      selectedValue: MainGlobals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(Globals.tableActors, this.CurrentMovie.Actors),
                                                      title: 'שחקנים',
                                                      height: 400.0,
                                                      textDirection: TextDirection.ltr,
                                                      SelectedItemBackgroundColor: Theme.of(_context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                      SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                      BackgroundColor: Theme.of(_context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                      ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                      onChanged: (List<ValueItemGlobal> selectedItems)
                                                      {
                                                        final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                        controllerActors.setOptions(items);
                                                      },
                                                    )),

                                                const SizedBox(width: 3.0),

                                                // Add button - Open new page for manage the Subjects
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child:
                                                    SizedBox(height: 30.0, width: 30,
                                                      child:
                                                        IconButton(
                                                          color: Theme.of(_context).colorScheme.primary,
                                                          icon: const Icon(Icons.add, size: 30.0,),
                                                          iconSize: 30.0,
                                                          onPressed: () async
                                                          {
                                                            List<String> list = Globals.tableActors.map((e) => e['Description'] as String).toList();
                                                            List<NoteChild> listToShow = [];
                                                            for (int i=0; i<list.length; i++)
                                                            {
                                                              NoteChild noteChild = NoteChild(NoteID: this.CurrentMovie.MovieID, Title: list[i], IsDone: false, FirebaseID: '');
                                                              listToShow.add(noteChild);
                                                            }
                                                            Object? resultNavigator = await Navigator.push(_context, MaterialPageRoute(builder: (context) =>
                                                                GenericMultiLines(
                                                                    title: 'שחקנים',
                                                                    itemsList: listToShow,
                                                                    mode: GenericPageModeEn.EmptyLines,
                                                                    isFullPage: true,
                                                                    onConfirmEvent: null)));
                                                            if (resultNavigator != null)
                                                            {
                                                              List<String> list = (resultNavigator as List<NoteChild>).map((e) => e.Title).toList();
                                                              await dataProvider.saveNewLookupRecords('TBL_Actors', list);
                                                              Globals.tableActors = await this.dataProvider.getCodeTableValues("TBL_Actors");
                                                              setState(()
                                                              {
                                                                isAlreadyLoadedNormalScreen;
                                                                widget.actors = widget.transferDataForMap(Globals.tableActors);
                                                              });
                                                            }
                                                          }
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                  )
                              ),

                              const SizedBox(height: 10),

                              // Writers, Editors, Music, Year, Language fields
                              Container(
                                padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(_context).colorScheme.primaryContainer.withOpacity(0.3),
                                    border: Border.all(color: Colors.grey  /*Theme.of(context).colorScheme.secondary*/, width: 0.7),
                                    borderRadius: const BorderRadius.all(Radius.circular(7.0))),
                                height: 300.0,
                                child:

                                  Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:
                                    [
                                      // Writers
                                      Column(
                                        children:
                                        [
                                          // Caption
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            children:
                                            [
                                              Text('כותבים', style: MainGlobals.g_styleFieldsCaptions),
                                            ],
                                          ),

                                          const SizedBox(height: 2.0),

                                          // Writers ComboBox
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            textDirection: TextDirection.rtl,
                                            children:
                                            [
                                              SizedBox(height: 35.0, width: screenWidth-60.0,
                                                child:
                                                  WidgetComboBox(
                                                      selectionType: ComboBoxType.multi,
                                                      Items: widget.writers,
                                                      // TODO: controllerObjectMulti: controllerDirector,
                                                      // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                                      selectedValue: MainGlobals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(Globals.tableWriters, this.CurrentMovie.Writer),
                                                      title: 'כותבים',
                                                      height: 400.0,
                                                      textDirection: TextDirection.ltr,
                                                      SelectedItemBackgroundColor: Theme.of(_context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                      SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                      BackgroundColor: Theme.of(_context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                      ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                      onChanged: (List<ValueItemGlobal> selectedItems)
                                                      {
                                                        final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                        controllerWriter.setOptions(items);
                                                      })),

                                              const SizedBox(width: 3.0),

                                              // Add button - Open new page for manage the Subjects
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child:
                                                  SizedBox(height: 30.0, width: 30,
                                                    child:
                                                      IconButton(
                                                        color: Theme.of(_context).colorScheme.primary,
                                                        icon: const Icon(Icons.add, size: 29.0,),
                                                        iconSize: 30.0,
                                                        onPressed: () async
                                                        {
                                                          List<String> list = Globals.tableWriters.map((e) => e['Description'] as String).toList();
                                                          List<NoteChild> listToShow = [];
                                                          for (int i=0; i<list.length; i++)
                                                          {
                                                            NoteChild noteChild = NoteChild(NoteID: this.CurrentMovie.MovieID, Title: list[i], IsDone: false, FirebaseID: '');
                                                            listToShow.add(noteChild);
                                                          }
                                                          Object? resultNavigator = await Navigator.push(_context, MaterialPageRoute(builder: (context) =>
                                                              GenericMultiLines(
                                                                  title: 'כותבים',
                                                                  itemsList: listToShow,
                                                                  mode: GenericPageModeEn.EmptyLines,
                                                                  isFullPage: true,
                                                                  onConfirmEvent: null)));
                                                          if (resultNavigator != null)
                                                          {
                                                            List<String> list = (resultNavigator as List<NoteChild>).map((e) => e.Title).toList();
                                                            await dataProvider.saveNewLookupRecords('TBL_Writers', list);
                                                            Globals.tableWriters = await this.dataProvider.getCodeTableValues("TBL_Writers");
                                                            setState(()
                                                            {
                                                              isAlreadyLoadedNormalScreen;
                                                              widget.writers = widget.transferDataForMap(Globals.tableWriters);
                                                            });
                                                          }
                                                        }
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      // Editors
                                      Column(
                                        children:
                                        [
                                          // Caption
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            children:
                                            [
                                              Text('עורכים', style: MainGlobals.g_styleFieldsCaptions),
                                            ],
                                          ),

                                          const SizedBox(height: 2.0),

                                          // Editors ComboBox
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            textDirection: TextDirection.rtl,
                                            children:
                                            [
                                              SizedBox(height: 35.0, width: screenWidth-60.0,
                                                child:
                                                  WidgetComboBox(
                                                      selectionType: ComboBoxType.multi,
                                                      Items: widget.editors,
                                                      // TODO: controllerObjectMulti: controllerDirector,
                                                      // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                                      selectedValue: MainGlobals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(Globals.tableEditors, this.CurrentMovie.Editor),
                                                      title: 'עורכים',
                                                      height: 400.0,
                                                      textDirection: TextDirection.ltr,
                                                      SelectedItemBackgroundColor: Theme.of(_context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                      SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                      BackgroundColor: Theme.of(_context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                      ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                      onChanged: (List<ValueItemGlobal> selectedItems)
                                                      {
                                                        final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                        controllerEditors.setOptions(items);
                                                      })),

                                              const SizedBox(width: 3.0),

                                              // Add button - Open new page for manage the Subjects
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child:
                                                  SizedBox(height: 30.0, width: 30,
                                                    child:
                                                      IconButton(
                                                        color: Theme.of(_context).colorScheme.primary,
                                                        icon: const Icon(Icons.add, size: 29.0,),
                                                        iconSize: 30.0,
                                                        onPressed: () async
                                                        {
                                                          List<String> list = Globals.tableEditors.map((e) => e['Description'] as String).toList();
                                                          List<NoteChild> listToShow = [];
                                                          for (int i=0; i<list.length; i++)
                                                          {
                                                            NoteChild noteChild = NoteChild(NoteID: this.CurrentMovie.MovieID, Title: list[i], IsDone: false, FirebaseID: '');
                                                            listToShow.add(noteChild);
                                                          }
                                                          Object? resultNavigator = await Navigator.push(_context, MaterialPageRoute(builder: (context) =>
                                                              GenericMultiLines(
                                                                  title: 'עורכים',
                                                                  itemsList: listToShow,
                                                                  mode: GenericPageModeEn.EmptyLines,
                                                                  isFullPage: true,
                                                                  onConfirmEvent: null)));
                                                          if (resultNavigator != null)
                                                          {
                                                            List<String> list = (resultNavigator as List<NoteChild>).map((e) => e.Title).toList();
                                                            await dataProvider.saveNewLookupRecords('TBL_Editors', list);
                                                            Globals.tableWriters = await this.dataProvider.getCodeTableValues("TBL_Editors");
                                                            setState(()
                                                            {
                                                              isAlreadyLoadedNormalScreen;
                                                              widget.editors = widget.transferDataForMap(Globals.tableEditors);
                                                            });
                                                          }
                                                        }
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      // Music
                                      Column(
                                        children:
                                        [
                                          // Caption
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            // crossAxisAlignment: CrossAxisAlignment.end,
                                            children:
                                            [
                                              Text('מוסיקאים', style: MainGlobals.g_styleFieldsCaptions),
                                            ],
                                          ),

                                          const SizedBox(height: 2.0),

                                          // Music ComboBox
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            textDirection: TextDirection.rtl,
                                            children:
                                            [
                                              SizedBox(height: 35.0, width: screenWidth-60.0,
                                                child:
                                                  WidgetComboBox(
                                                      selectionType: ComboBoxType.multi,
                                                      Items: widget.musicians,
                                                      // TODO: controllerObjectMulti: controllerDirector,
                                                      // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                                      selectedValue: MainGlobals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(Globals.tableMusicians, this.CurrentMovie.Music),
                                                      title: 'מוסיקאים',
                                                      height: 400.0,
                                                      textDirection: TextDirection.ltr,
                                                      SelectedItemBackgroundColor: Theme.of(_context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                      SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                      BackgroundColor: Theme.of(_context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                      ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                      onChanged: (List<ValueItemGlobal> selectedItems)
                                                      {
                                                        final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                        controllerMusic.setOptions(items);
                                                      })),

                                              const SizedBox(width: 3.0),

                                              // Add button - Open new page for manage the Subjects
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child:
                                                  SizedBox(height: 30.0, width: 30,
                                                    child:
                                                      IconButton(
                                                        color: Theme.of(_context).colorScheme.primary,
                                                        icon: const Icon(Icons.add, size: 29.0,),
                                                        iconSize: 30.0,
                                                        onPressed: () async
                                                        {
                                                          List<String> list = Globals.tableMusicians.map((e) => e['Description'] as String).toList();
                                                          List<NoteChild> listToShow = [];
                                                          for (int i=0; i<list.length; i++)
                                                          {
                                                            NoteChild noteChild = NoteChild(NoteID: this.CurrentMovie.MovieID, Title: list[i], IsDone: false, FirebaseID: '');
                                                            listToShow.add(noteChild);
                                                          }
                                                          Object? resultNavigator = await Navigator.push(_context, MaterialPageRoute(builder: (context) =>
                                                              GenericMultiLines(
                                                                  title: 'מוסיקאים',
                                                                  itemsList: listToShow,
                                                                  mode: GenericPageModeEn.EmptyLines,
                                                                  isFullPage: true,
                                                                  onConfirmEvent: null)));
                                                          if (resultNavigator != null)
                                                          {
                                                            List<String> list = (resultNavigator as List<NoteChild>).map((e) => e.Title).toList();
                                                            await dataProvider.saveNewLookupRecords('TBL_Musicians', list);
                                                            Globals.tableWriters = await this.dataProvider.getCodeTableValues("TBL_Musicians");
                                                            setState(()
                                                            {
                                                              isAlreadyLoadedNormalScreen;
                                                              widget.musicians = widget.transferDataForMap(Globals.tableMusicians);
                                                            });
                                                          }
                                                        }
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),


                                      // Language, Year
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:
                                        [
                                          // Year
                                          SizedBox(width: 55, height: 60,
                                              child:
                                              TextField(
                                                  controller: controllerYear,
                                                  // maxLength: 4,
                                                  keyboardType: TextInputType.number,
                                                  decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'שנה'),
                                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.blueGrey)
                                              )),

                                          // Language
                                          SizedBox( height: 40, width: 200,
                                            child:
                                            TextField(
                                                controller: controllerLanguage,
                                                keyboardType: TextInputType.text,
                                                decoration: const InputDecoration(border: UnderlineInputBorder(), labelText: 'שפה',),
                                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.blueGrey)
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20.0),
                                    ]),
                              ),

                            ]),


                        const SizedBox(height: 20.0),

                    ])

                )

          ),

        ]);

  }

  List<NoteImage> CreateValidUrlsToShowImage()
  {
    List<NoteImage> imagesList = [];


    if (MainGlobals.isUrlValid(this.CurrentMovie.SelfLink))
    {
      List<int> image = [];
      NoteImage noteImage =NoteImage(NoteID: this.CurrentMovie.MovieID, Image: Uint8List.fromList(image), FirebaseID: this.CurrentMovie.FirebaseID, ImageName: this.CurrentMovie.SelfLink);
      imagesList.add(noteImage);
    }

    for (String item in this.CurrentMovie.ImagesLinks)
    {
      if (MainGlobals.isUrlValid(item))
      {
        List<int> image = [];
        NoteImage noteImage = NoteImage(NoteID: this.CurrentMovie.MovieID, Image: Uint8List.fromList(image), FirebaseID: this.CurrentMovie.FirebaseID, ImageName: item);
        imagesList.add(noteImage);
      }

      // for (NoteImage noteImage in this.CurrentMovie.Images)
      // {
      //   imagesList.add(noteImage);
      // }
    }

    return imagesList;
  }

  /// Open generic page, with rows of TextBoxes & CheckBoxes
  Future<void> openSubTasksScreen() async
  {

    String title = 'פריטים נוספים';

    // if (!this.isUpdateMode)
    // {
      // if (this.CurrentMovie.SubTasks.isEmpty)
      // {
      //     this.CurrentMovie.SubTasks.add(NoteChild(NoteID: 0, Title: '', IsDone: false, FirebaseID: ''));
      // }
    // }

    // if (this.CurrentMovie.SubTasks.isEmpty)
    // {
    //   this.CurrentMovie.SubTasks.add(NoteChild(NoteID: 0, Title: '', IsDone: false, FirebaseID: ''));
    // }

    Object? resultNavigator = await Navigator.push(_context, MaterialPageRoute(builder: (tmpContext) =>
                                                                                                          GenericMultiLines(
                                                                                                              title: title,
                                                                                                              itemsList: this.CurrentMovie.SubTasks,
                                                                                                              mode: GenericPageModeEn.LinesWithCheckeBoxes,
                                                                                                              isFullPage: true,
                                                                                                              onConfirmEvent: null)));


    if (resultNavigator != null)
    {
      setState(()
      {
        this.CurrentMovie.SubTasks = resultNavigator as List<NoteChild>;
        this.CurrentMovie.SubTasks.forEach((item) {item.NoteID = this.CurrentMovie.MovieID;});
      });
    }
  }

  Future<bool> saveRecord(bool isUpdateMode, int mode) async
  {
    bool result = false;


    // Update Note object from screen's fields
    await setObjectToRecord(this.CurrentMovie);

    if (!await isValid(this.CurrentMovie, mode))
    {
      return false;
    }

    if (isUpdateMode)
    {
      // result = await this.dataProvider.updateRecord(this.CurrentMovie);
      actionDesc = 'updated';
    }
    else
    {
      // result = (await this.dataProvider.insertRecord(this.CurrentMovie) > 0);
      actionDesc = 'inserted';
    }

    // export PATH=$HOME/Desktop/Develope/flutter_library/bin:$PATH
    this.isSaved = true;
    result = true;

    // Exit the page
    Navigator.pop(_context, actionDesc);

    // if (Globals.isItRichText(this.CurrentMovie.Description))
    // {
    //   // final GlobalKey<QuillHtmlEditorState> keyEditorDescription = GlobalKey<QuillHtmlEditorState>();
    //   // controllerDescriptionHtml = QuillEditorController();
    //   // controllerDescriptionHtml.editorKey = keyEditorDescription;
    //   // await controllerDescriptionHtml.setText(note.Description);
    //   this.CurrentMovie.Description = await controllerDescriptionHtml.getPlainText();
    // }


    return result;
  }

  // Future<void> insertRecord(Movie this.CurrentMovie) async
  // {
  //   try
  //   {
  //     await setObjectToRecord(this.CurrentMovie);
  //     int newRecordID = await MoviesProvider.is(this.CurrentMovie); //await Provider.of<MovieProvider>(_context, listen: false).insert(this.CurrentMovie);
  // MainGlobals.showSnackBar(_context, 'Movie Saved - ID=$newRecordID');
  // }
  // catch (e)
  //   {
  //   print('\nError in Book save: $e\n');
  //   MainGlobals.showSnackBar(_context, 'Error in save...');
  //   }
  // }
  //
  // Future<void> updateRecord(Movie this.CurrentMovie) async
  // {
  //   try
  //   {
  //     setObjectToRecord(this.CurrentMovie);
  //     int newRecordID = await DatabaseHelper.instance.updateItem(this.CurrentMovie);
  //     int id = newRecordID>0 ? this.CurrentMovie.MovieID : 0;
  //     if (id>0)
  //     {
  //       Globals.showSnackBar(_context, 'Movie Saved - ID=$id');
  //     }
  //     else
  //     {
  //       Globals.showSnackBar(_context, 'Error in save "updateRecord"');
  //     }
  //   }
  //   catch (e)
  //   {
  //     print('\nError in Book save: $e\n');
  //     Globals.showSnackBar(_context, 'Error in save "updateRecord"');
  //   }
  // }

  Future<bool> isValid(Movie note, int mode) async
  {
    bool result = true;

    // String message='';
    //
    //
    // if (note.Title.isEmpty)
    // {
    //   result = 1;
    //   message = 'חובה לקלוט כותרת';
    // }
    // if (note.StatusID<=0)
    // {
    //   result = 0;
    //   message += '\nחובה לקלוט סטטוס';
    // }
    // if (note.ListTypeID<=0)
    // {
    //   result = 0;
    //   message += '\nֿחובה לקלוט סוג מידע';
    // }
    // // if (note.PriorityID==null || note.PriorityID!<=0)
    // // {
    // //   result = false;
    // //   message += '\nחובה לקלוט עדיפות';
    // // }
    // if (note.DateDueToDate!=null && note.TimeDue==null /*|| (note.TimeDue!.hour==0 && note.TimeDue!.minute==0)*/)
    // {
    //   result = 0;
    //   message += 'במידה ובחרת יום בתאריך, חובה לקלוט זמן';
    // }
    // if ((note.DateDueToDate==null || note.TimeDue==null) && this.isEarlyAlarm)
    // {
    //   result = 0;
    //   message += 'ֿבמידה ובחרת התראה מוקדמת, חובה לקלוט תאריך וזמן';
    // }
    //
    // if (result!=2 && mode==1 /*&& !(!this.isUpdateMode && message == 'חובה לקלוט כותרת')*/)
    // {
    //   await MainGlobals.showAlertDialog(_context, 'בדיקת תקינות', message, AlertDialogOptionEn.Close);
    // }

    return result;
  }

  /// Property of Provider
  DataProvider get dataProvider
  {
    DataProvider<Movie> notesProvider = Provider.of<DataProvider<Movie>>(this._context, listen: false);
    notesProvider.context = this._context;
    return notesProvider;
  }

  void setRecordToObject(Movie movie)
  {
    controllerTitle.text = movie.Title.trim();
    controllerDescription.text = movie.Description.trim();
    controllerYear.text = movie.Year;
    controllerLanguage.text = movie.Language;
    controllerRate.text = movie.Rated;
    controllerSelfLink.text = movie.SelfLink;
    controllerFilmTypes.text = movie.FilmTypeID.toString();
    controllerImage1.text = (movie.ImagesLinks.length>0) ?movie.ImagesLinks[0] : '';
    controllerImage2.text = (movie.ImagesLinks.length>1) ?movie.ImagesLinks[1] : '';
    controllerImage3.text = (movie.ImagesLinks.length>2) ?movie.ImagesLinks[2] : '';
    controllerImage4.text = (movie.ImagesLinks.length>3) ?movie.ImagesLinks[3] : '';
    controllerDownloadFolder.text = MainGlobals.directoryLibrary.path;

    setComboContreols(CodeTableEn.ActorsTable, movie.Actors, controllerActors);
    setComboContreols(CodeTableEn.GenresTable, movie.Genre, controllerGenre);
    setComboContreols(CodeTableEn.DirectorsTable, movie.Director, controllerDirector);
    setComboContreols(CodeTableEn.EditorsTable, movie.Editor, controllerEditors);
    setComboContreols(CodeTableEn.WritersTable, movie.Writer, controllerWriter);
    setComboContreols(CodeTableEn.MusiciansTable, movie.Music, controllerMusic);
  }

  void setComboContreols(CodeTableEn type, String selectedField, MultiSelectController controller)
  {
    final List<ValueItemGlobal> list = Globals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(type, selectedField);
    List<ValueItem<Object?>> listNew = ValueItemGlobal.fromGlobalToValueItem(list);

    controller.setOptions(listNew);
    controller.setSelectedOptions(listNew);
  }

  Future<void> setObjectToRecord(Movie movie) async
  {
    movie.Title = controllerTitle.text.trim();
    movie.Description = controllerDescription.text.trim();
    if (controllerFilmTypes.text.isNotEmpty)
    {
      movie.FilmTypeID = int.parse(controllerFilmTypes.text);
    }
    movie.Director = controllerDirector.options.map((e) => e.label).join(', ');
    movie.Actors = controllerActors.options.map((e) => e.label).join(', ');
    movie.Genre = controllerGenre.options.map((e) => e.label).join(', '); // controllerSubjects.options.map((e) => e.label).join(', ');
    movie.Writer = controllerWriter.options.map((e) => e.label).join(', ');
    movie.Music = controllerMusic.options.map((e) => e.label).join(', ');
    movie.Editor = controllerEditors.options.map((e) => e.label).join(', ');
    movie.Year = controllerYear.text;
    movie.Language = controllerLanguage.text;
    movie.Rated = controllerRate.text;
    movie.SelfLink = controllerSelfLink.text;
    movie.ImagesLinks = []; //controllerImage1.text, controllerImage2.text, controllerImage3.text, controllerImage4.text];
    if (controllerImage1.text.trim().isNotEmpty)
    {
      movie.ImagesLinks.add(controllerImage1.text.trim());
    }
    if (controllerImage2.text.trim().isNotEmpty)
    {
      movie.ImagesLinks.add(controllerImage2.text.trim());
    }
    if (controllerImage3.text.trim().isNotEmpty)
    {
      movie.ImagesLinks.add(controllerImage3.text.trim());
    }
    if (controllerImage4.text.trim().isNotEmpty)
    {
      movie.ImagesLinks.add(controllerImage4.text.trim());
    }
  }

  Future<void> switchRichTextMode(bool isRichTextToScreenSmall) async
  {

    if (isRichTextToScreenSmall)
    {
      String tmp = controllerDescription.text.trim();
      setState(()
      {
        this.RichTextCaption = "טקסט רגיל";
        isRichText = !isRichText;
        if (widgetRichTextNormalScreen!.initValue==null || (widgetRichTextNormalScreen!.initValue!=null && widgetRichTextNormalScreen!.initValue!.isEmpty))
        {
          if (!tmp.contains("dir="))
          {
            tmp = Globals.setHtmlInitString + tmp + "</p>";
          }
        }
        widgetRichTextNormalScreen!.initValue = tmp;
        /*await*/ widgetRichTextNormalScreen!.setHtmlText(tmp);
        // if (widgetRichTextFullScreen != null)
        // {
        //   widgetRichTextFullScreen!.initValue = tmp;
        //   /*await*/ widgetRichTextFullScreen!.setHtmlText(tmp);
        // }
        isAlreadyLoadedNormalScreen = false;
        //setRichTextBetweenScreens(widgetRichTextNormalScreen!, true, false);
      });
    }
    else
    {
      await controllerDescriptionHtml.setText(controllerDescription.text.trim());
      setState(()
      {
        this.RichTextCaption = "טקסט רגיל";
        isRichText = !isRichText;
        if (isRichText)
        {
          // widgetRichTextFullScreen!.initValue = controllerDescription.text;
          // widgetRichTextFullScreen!.setHtmlText(controllerDescription.text);
          if (widgetRichTextNormalScreen != null)
          {
            widgetRichTextNormalScreen!.initValue = controllerDescription.text;
            widgetRichTextNormalScreen!.setHtmlText(controllerDescription.text);
          }
        }
        this.isFullScreenMode = true;
        this.isAlreadyLoadedFullScreen = false;
        this.isAlreadyLoadedNormalScreen = false;
        //setRichTextBetweenScreens(widgetRichTextNormalScreen!, true, false);
      });
    }

  }

  Future<void> switchNormalTextMode(bool isRichTextFromScreenSmall) async
  {

    if (isRichTextFromScreenSmall)
    {
      final String tmp = await widgetRichTextNormalScreen!.getHtmlText();
      setState(()
      {
        this.RichTextCaption = "טקסט מעוצב";
        isRichText = !isRichText;
        // if (widgetRichTextFullScreen != null)
        // {
        //   widgetRichTextFullScreen!.initValue = tmp;
        //   widgetRichTextFullScreen!.setHtmlText(tmp);
        // }
        controllerDescription.text = tmp;
        isAlreadyLoadedNormalScreen = false;
        //setRichTextBetweenScreens(widgetRichTextNormalScreen!, true, false);
      });
    }
    else
    {
      String tmp = await controllerDescriptionHtml.getText();       //await widgetRichTextFullScreen!.getHtmlText();
      setState(()
      {
        this.RichTextCaption = "טקסט מעוצב";
        if (isRichText)
        {
          if (widgetRichTextNormalScreen != null)
          {
            widgetRichTextNormalScreen!.setHtmlText(tmp);
          }
          controllerDescription.text = tmp;
        }
        isRichText = !isRichText;
        this.isFullScreenMode = true;
        this.isAlreadyLoadedFullScreen = false;
        this.isAlreadyLoadedNormalScreen = false;
        //setRichTextBetweenScreens(widgetRichTextFullScreen!, true, false);
      });
    }

  }

}




// https://pub.dev/packages/multi_dropdown
// class MultiSelectExample extends StatelessWidget {
//   const MultiSelectExample({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             MultiSelectDropdown(
//               list: const [
//                 {'id': 'dog', 'label': 'Dog'},
//                 {'id': 'cat', 'label': 'Cat'},
//                 {'id': 'mouse', 'label': 'Mouse'},
//                 {'id': 'rabbit', 'label': 'Rabbit'},
//               ],
//               initiallySelected: const [],
//               onChange: (newList) {
//                 // your logic
//                 // typically setting state
//               },
//               numberOfItemsLabelToShow: 2, // label to be shown for 2 items
//               whenEmpty:
//               'Choose from the list', // text to show when selected list is empty
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//   DropDownMultiSelect(
//      selected_values_style: TextStyle(color: Colors.white),
//      onChanged: (List<String> x) {
//        setState(() {
//          //selected =x;
//        });
//      },
//      options: ['a' , 'b' , 'c' , 'd'],
//      selectedValues: ['a'],
//      whenEmpty: 'Select Something',
// ),
// MultiSelectDropdown.simpleList(
//   list: const [
//     'Drama',
//     'Action',
//     'Doco',
//     'Snake',
//     'Mouse',
//     'Rabbit',
//     'Cow',
//     'Sheep',
//   ],
//   initiallySelected: const [],
//   onChange: (newList) {
//     // your logic
//   },
//   includeSearch: true,
//   includeSelectAll: true,
//   isLarge: true, // Modal size will be a little large
//   // Give a definite width when rendering this widget in a row
//   width: 150, // Must be a definite number
//   boxDecoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(15),
//   ),
// ),