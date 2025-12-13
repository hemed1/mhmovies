

// import '/pages/SavedScreen.dart';
// import '/utils/BookDetailsArguments.dart';
//https://pub.dev/packages/multiselect_dropdown_flutter/example
// https://pub.dev/packages/multi_dropdown/example
// https://pub.dev/packages/path_provider/example
// file:///Users/meirh/Desktop/Develope/Flutter/mh_movies/lib/Images/The_lord_of_the_ring-2.jpeg

//import 'package:multiselect_dropdown/multiselect_dropdown.dart';
// import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
// import 'package:multiselect/multiselect.dart';
import 'package:flutter/material.dart';
import '../enums/Enums.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataProvider.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';
import '/utils/Globals.dart';
import '/utils/MovieDetailsPageArguments.dart';
import '/utils/PicturePageArguments.dart';
import '../models/Movie.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetComboBox.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/ValueItemGlobal.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteChild.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/GenericMultiLines.dart';



class MovieDetailsPage extends StatefulWidget
{
  MovieDetailsPage({super.key});  //, required Movie movie});

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  late final Map<String, Object?> actors = transferDataForMap(Globals.tableActors);
  late final Map<String, Object?> genres = transferDataForMap(Globals.tableGenres);
  late final Map<String, Object?> directors = transferDataForMap(Globals.tableDirectors);
  late final Map<String, Object?> filmTypes = transferDataForMap(Globals.tableFilmTypes);

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
  TextEditingController controllerWriter = TextEditingController();
  TextEditingController controllerRate = TextEditingController();
  TextEditingController controllerSelfLink = TextEditingController();
  TextEditingController controllerImage1 = TextEditingController();
  TextEditingController controllerImage2 = TextEditingController();
  TextEditingController controllerImage3 = TextEditingController();
  TextEditingController controllerImage4 = TextEditingController();
  TextEditingController controllerDownloadFolder = TextEditingController();


  late double screenWidth;
  late double screenHeight;
  bool isImagesLinksOpen = true;
  List<String> imagesList= [];
  late BuildContext _context;
  bool isUpdateMode = false;
  bool isSaved = false;
  bool isFromFavoritePage = false;
  String actionDesc='';
  late Movie CurrentMovie;


  void Function(String message)? EvenDeleteSucss;
  //#endregion vars



  @override
  Widget build(BuildContext context)
  {
    this._context = context;
    MainGlobals.context = context;
    Globals.context = context;
    screenWidth = MainGlobals.getScreenSize(_context).width - 40.0;
    screenHeight = MainGlobals.getScreenSize(_context).height - 160.0;

    // Get Main object & Properties
    final args = ModalRoute.of(context)?.settings.arguments as MovieDetailsPageArguments;
    this.CurrentMovie = args.noteObject;
    final bool isUpdateMode = args.isUpdateMode;
    final theme = Theme.of(context).textTheme;
    EvenDeleteSucss = args.onEvenDeleteSucss;


    if (isUpdateMode)
    {
      setRecordToObject(this.CurrentMovie);
    }

    imagesList = this.CurrentMovie.CreateValidUrlsToShowImage();


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


              Center(
                child:

                  // Main container
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                    [
                      Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                        margin:  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,bottom: 10.0),
                        // height: screenHeight - 10.0,
                        // width:  screenWidth - 20.0,
                        decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),    //.inversePrimary
                                      border: Border.all(color: Theme.of(context).colorScheme.secondary),
                                      borderRadius: const BorderRadius.all(Radius.circular(7.0))),

                        child:
                          SingleChildScrollView(
                            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            scrollDirection: Axis.vertical,
                            child:

                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          // // 'מסך מלא' button
                                          // SizedBox(height: 34.0,
                                          //     child:
                                          //       TextButton(
                                          //         child: Text('מסך מלא', style: MainGlobals.g_styleButtonsSub),
                                          //         onPressed: ()   async
                                          //         {
                                          //           // String tmp = '';
                                          //           // if (this.isRichText)
                                          //           // {
                                          //           //   tmp = await widgetRichTextNormalScreen!.getHtmlText();
                                          //           // }
                                          //           // setState(()
                                          //           // {
                                          //           //   if (this.isRichText)
                                          //           //   {
                                          //           //     if (widgetRichTextFullScreen != null)
                                          //           //     {
                                          //           //       widgetRichTextFullScreen!.initValue = tmp;
                                          //           //       widgetRichTextFullScreen!.setHtmlText(tmp);
                                          //           //       // await setRichTextBetweenScreens(widgetRichTextFullScreen!, true);
                                          //           //     }
                                          //           //     controllerDescription.text = tmp;
                                          //           //   }
                                          //           //   // Widget of Note text page
                                          //           //   isFullScreenMode = true;
                                          //           //   isAlreadyLoadedFullScreen = false;
                                          //         }
                                          //     )
                                          //   ),

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
                                                    Navigator.pushNamed(context, '/picture_big', arguments: PicturePageArguments(moviesLinks: imagesList, movieTitle: this.CurrentMovie.Title));
                                                  })),

                                      ])),

                                  /// // Scroll Images
                                  if (!isImagesLinksOpen)
                                  Container(
                                      height: 140,
                                      width: 400,
                                      padding: const EdgeInsets.all(1.0),
                                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                          //color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                                          border: Border.all(color: Colors.black87, width: 1.0),   // Theme.of(context).colorScheme.secondary
                                          borderRadius: const BorderRadius.all(Radius.circular(10.3))),

                                      child:
                                          //if (this.CurrentMovie.Images.isNotEmpty || this.CurrentMovie.SelfLink.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                              child:
                                                ListView.builder(
                                                  itemCount: imagesList.length,
                                                  physics: const BouncingScrollPhysics(),   // ClampingScrollPhysics(),mNeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,

                                                  itemBuilder: (context, index)
                                                  {
                                                    Widget imageWidget = const SizedBox();

                                                    if (imagesList[index].isEmpty)
                                                    {
                                                      return imageWidget;
                                                    }

                                                    imageWidget = MainGlobals.extractUrl(imagesList[index], false);

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
                                                          Navigator.pushNamed(context, '/picture_big', arguments: PicturePageArguments(moviesLinks: imagesList, movieTitle: this.CurrentMovie.Title));
                                                        },
                                                      );
                                                  }
                                              ),
                                          ),
                                  ),


                                  // Change between images links

                                   SizedBox(height: 30.0,
                                    child: TextButton(
                                        onPressed: ()
                                        {
                                          isImagesLinksOpen = !isImagesLinksOpen;
                                          setState(() {});
                                        },
                                        isSemanticButton: true,
                                        child: const Row(
                                          children:
                                          [
                                            Text('More...', style: TextStyle(color: Colors.blue, fontSize: 11.0,),),
                                            Icon(Icons.read_more)
                                          ],
                                        ))),

                                  /// Get Images links
                                  if (!isImagesLinksOpen)
                                    Column(
                                      children:
                                      [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children:
                                          [
                                            SizedBox(width: 170, height: 60,
                                              child:
                                                TextField(
                                                    controller: controllerImage1,
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Image 1',
                                                    ),
                                                    style: const TextStyle(fontSize: 13.0)
                                                ),
                                            ),

                                            const SizedBox(width: 20.0,),

                                            SizedBox(width: 170, height: 60,
                                              child:
                                                TextField(
                                                    controller: controllerImage2,
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Image 2',
                                                    ),
                                                    style: const TextStyle(fontSize: 13.0)
                                                ),
                                            )
                                          ],
                                        ),

                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(width: 170, height: 60,
                                              child:
                                              TextField(
                                                  controller: controllerImage3,
                                                  keyboardType: TextInputType.text,
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                    labelText: 'Image 3',
                                                  ),
                                                  style: const TextStyle(fontSize: 13.0)
                                              ),
                                            ),
                                            const SizedBox(width: 20.0,),
                                            SizedBox(width: 170, height: 60,
                                              child:
                                              TextField(
                                                  controller: controllerImage4,
                                                  keyboardType: TextInputType.text,
                                                  decoration: const InputDecoration(
                                                    border: UnderlineInputBorder(),
                                                    labelText: 'Image 4',
                                                  ),
                                                  style: const TextStyle(fontSize: 13.0)
                                              ),
                                            )
                                          ],
                                        ),

                                        // Self Link field
                                        TextField(
                                            controller: controllerSelfLink,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Self Link',
                                            ),
                                            style: const TextStyle(fontSize: 13.0)
                                        ),

                                        // Download Folder
                                        TextField(
                                            controller: controllerDownloadFolder,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Folder',
                                            ),
                                            style: const TextStyle(fontSize: 13.0)
                                        ),
                                      ]
                                    ),

                                  const SizedBox(height: 15.0),


                                  // ---------------------------------------------------------------------- //
                                  // Show Movie Details Textbox fields under the Image
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                // Film Types
                                                SizedBox(height: 35.0, width: 140.0,
                                                  child:
                                                    WidgetComboBox(
                                                      selectionType: ComboBoxType.single,
                                                      Items: widget.filmTypes,
                                                      // TODO: controllerObjectMulti: controllerSubjects,
                                                      // Transfer the selected items from long separated by ', ' String - to List<ValueItemGlobal>
                                                      selectedValue: MainGlobals.getGlobalTablesValueToValueItemGlobals(Globals.tableFilmTypes, this.CurrentMovie.FilmTypeID),
                                                      title: 'סוג',
                                                      height: 200.0,
                                                      SelectedItemBackgroundColor: Theme.of(context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                      SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                      BackgroundColor: Theme.of(context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                      ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                      onChanged: (List<ValueItemGlobal> selectedItems)
                                                      {
                                                        controllerFilmTypes.text = selectedItems[0].value as String;
                                                      },
                                                    )),
                                                if (isUpdateMode == true)
                                                  Text('${this.CurrentMovie.MovieID}', textAlign: TextAlign.left, style: const TextStyle(fontSize: 14.0)),
                                              ],
                                            ),

                                            const SizedBox(height: 3.0),

                                            // Title field
                                            Container(
                                                padding: const EdgeInsets.only(left: 5.0, top: 0.3, right: 5.0, bottom: 0.3),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
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
                                                    fillColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
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
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children:
                                                [
                                                  Text('תיאור',textAlign: TextAlign.left, style: MainGlobals.g_styleFieldsCaptions),
                                                ],
                                              ),

                                              const SizedBox(height: 3.0),

                                              // Description field
                                              Container(
                                                padding: const EdgeInsets.only(left: 5.0, top: 3.0, right: 5.0, bottom: 3.0),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                                                    border: Border.all(color: Theme.of(context).colorScheme.secondary),
                                                    borderRadius: const BorderRadius.all(Radius.circular(9.0))),
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
                                                    style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 17, fontStyle: FontStyle.italic),
                                                    scrollPhysics: const BouncingScrollPhysics(),
                                                    maxLines: 6,
                                                    showCursor: true,
                                                    autocorrect: false,
                                                    //overflow: TextOverflow.ellipsis
                                                    //textInputAction: TextInputAction.newline,
                                                  ),
                                              //Text(this.CurrentMovie.Description, style: theme.bodyMedium, maxLines: 6),
                                            ),
                                          ]),

                                        const SizedBox(height: 15),

                                        // Director, Actors, Writer
                                        Container(
                                          padding: const EdgeInsets.only(left: 7.0, top: 7.0, right: 7.0, bottom: 7.0),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                                              border: Border.all(color: Colors.grey  /*Theme.of(context).colorScheme.secondary*/, width: 0.7),
                                              borderRadius: const BorderRadius.all(Radius.circular(7.0))),
                                          height: 140.0,
                                          child:

                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children:
                                                [
                                                  // Genre, Film Types
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    textDirection: TextDirection.rtl,
                                                    children:
                                                    [
                                                      SizedBox(height: 35.0, width: screenWidth-90.0,
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
                                                            SelectedItemBackgroundColor: Theme.of(context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                            SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                            BackgroundColor: Theme.of(context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                            ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                            onChanged: (List<ValueItemGlobal> selectedItems)
                                                            {
                                                              final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                              controllerGenre.setOptions(items);
                                                            },
                                                          )),

                                                      const SizedBox(width: 5.0),

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
                                                                  Object? resultNavigator = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
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
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  // Directors
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    textDirection: TextDirection.ltr,
                                                    children:
                                                    [
                                                      SizedBox(height: 35.0, width: screenWidth-90.0,
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
                                                            SelectedItemBackgroundColor: Theme.of(context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                            SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                            BackgroundColor: Theme.of(context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                            ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                            onChanged: (List<ValueItemGlobal> selectedItems)
                                                            {
                                                              final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                              controllerDirector.setOptions(items);
                                                            })),

                                                      const SizedBox(width: 5.0),

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
                                                                  Object? resultNavigator = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
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
                                                                    setState(()
                                                                    {});
                                                                  }
                                                                }
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  // Actors
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    textDirection: TextDirection.ltr,
                                                    children:
                                                    [
                                                      SizedBox(height: 35.0, width: screenWidth-90.0,
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
                                                            SelectedItemBackgroundColor: Theme.of(context).colorScheme.primaryContainer, // The Background color of the Selected Item in list
                                                            SelectedItemForegroundColor: Colors.black,                          // The Foreground color of the Selected Item in list
                                                            BackgroundColor: Theme.of(context).colorScheme.inversePrimary,      // The Background color of Items in list (Not selected)
                                                            ItemForegroundColor: Colors.black,                                  // The Foreground color of Items in list (Not selected)
                                                            onChanged: (List<ValueItemGlobal> selectedItems)
                                                            {
                                                              final List<ValueItem<Object?>> items = ValueItemGlobal.fromGlobalToValueItem(selectedItems);
                                                              controllerActors.setOptions(items);
                                                            },
                                                          )),

                                                      const SizedBox(width: 5.0),

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
                                                                  Object? resultNavigator = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
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
                                                                  }
                                                                }
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                        ),

                                        const SizedBox(height: 15),

                                        // Year, Language fields
                                        Container(
                                            padding: const EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                                                border: Border.all(color: Colors.grey  /*Theme.of(context).colorScheme.secondary*/, width: 0.7),
                                                borderRadius: const BorderRadius.all(Radius.circular(7.0))),
                                            height: 130.0,
                                            child:

                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:
                                                [
                                                  // Writers
                                                  SizedBox(height: 40.0,
                                                    child:
                                                      TextField(
                                                          controller: controllerWriter,
                                                          textDirection: TextDirection.rtl,
                                                          keyboardType: TextInputType.text,
                                                          decoration: const InputDecoration(
                                                              border: UnderlineInputBorder(),
                                                              labelText: 'תסריט'
                                                          ),
                                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.blueGrey)   //theme.bodyMedium
                                                      )),

                                                  // Language, Year
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children:
                                                    [
                                                      // Year
                                                      SizedBox(width: 40, height: 60,
                                                        child:
                                                          TextField(
                                                            controller: controllerYear,
                                                            // maxLength: 4,
                                                            keyboardType: TextInputType.number,
                                                            decoration: const InputDecoration(
                                                              border: UnderlineInputBorder(),
                                                              labelText: 'שנה',
                                                            ),
                                                            style: theme.bodyLarge
                                                        )),

                                                      // Language
                                                      SizedBox( height: 40, width: 200,
                                                        child:
                                                          TextField(
                                                            controller: controllerLanguage,
                                                            keyboardType: TextInputType.text,
                                                            decoration: const InputDecoration(
                                                              border: UnderlineInputBorder(),
                                                              labelText: 'שפה',
                                                            ),
                                                            style: theme.bodyLarge
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ]),
                                        ),

                                  ]),
                              ])

                          )
                      ),
                    ],),

              )

          )
    );


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
    controllerTitle.text = movie.Title;
    controllerDescription.text = movie.Description;
    controllerYear.text = movie.Year;
    controllerLanguage.text = movie.Language;
    controllerWriter.text = movie.Writer;
    controllerRate.text = movie.Rated;
    controllerSelfLink.text = movie.SelfLink;

    List<ValueItemGlobal> list = Globals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(CodeTableEn.ActorsTable, movie.Actors);
    List<ValueItem<Object?>> listNew = ValueItemGlobal.fromGlobalToValueItem(list);
    controllerActors.setOptions(listNew);
    controllerActors.setSelectedOptions(listNew);

    list = Globals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(CodeTableEn.GenresTable, movie.Genre);
    listNew = ValueItemGlobal.fromGlobalToValueItem(list);
    controllerGenre.setOptions(listNew);
    controllerGenre.setSelectedOptions(listNew);

    list = Globals.getMultiSelectedItemsSeparatedStringToValueItemGlobals(CodeTableEn.Directors, movie.Director);
    listNew = ValueItemGlobal.fromGlobalToValueItem(list);
    controllerDirector.setOptions(listNew);
    controllerDirector.setSelectedOptions(listNew);

    controllerFilmTypes.text = movie.FilmTypeID.toString();

    controllerImage1.text = (movie.ImagesLinks.length>0) ?movie.ImagesLinks[0] : '';
    controllerImage2.text = (movie.ImagesLinks.length>1) ?movie.ImagesLinks[1] : '';
    controllerImage3.text = (movie.ImagesLinks.length>2) ?movie.ImagesLinks[2] : '';
    controllerImage4.text = (movie.ImagesLinks.length>3) ?movie.ImagesLinks[3] : '';
    controllerDownloadFolder.text = MainGlobals.directoryLibrary.path;
  }

  Future<void> setObjectToRecord(Movie movie) async
  {
    movie.Title = controllerTitle.text.trim();
    movie.Description = controllerDescription.text.trim();
    movie.Director = controllerDirector.options.map((e) => e.label).join(', ');
    movie.Actors = controllerActors.options.map((e) => e.label).join(', ');
    movie.Genre = controllerGenre.options.map((e) => e.label).join(
        ', '); // controllerSubjects.options.map((e) => e.label).join(', ');
    if (controllerFilmTypes.text.isNotEmpty) {
      movie.FilmTypeID = int.parse(controllerFilmTypes.text);
    }
    movie.Year = controllerYear.text;
    movie.Language = controllerLanguage.text;
    movie.Writer = controllerWriter.text;
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