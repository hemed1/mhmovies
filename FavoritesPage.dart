

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/MovieDetailsPageArguments.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataProvider.dart';
import '../enums/Enums.dart';
import '../models/Movie.dart';
import '../utils/Globals.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteDetailsPageArguments.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetListView.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';




class FavoritesPage extends StatefulWidget
{
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}


class _FavoritesPageState extends State<FavoritesPage>
{
  Map<String, dynamic> list  = {};
  List<Movie>  notes = [];
  bool isFirstTime = true;
  late BuildContext _context = context;
  late double deviceHeight;  // AppBar width, down buttons width
  late double deviceWidth;



  @override
  void initState()
  {
    super.initState();
    MainGlobals.g_physicalScreenSize = MainGlobals.getScreenSize(_context);      //WidgetsBinding.instance.window.physicalSize;
    deviceWidth = MainGlobals.g_physicalScreenSize.width;
    deviceHeight = MainGlobals.g_physicalScreenSize.height - 285.0;
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
      //readFavorite(context);
    }


    return
      Consumer<DataProvider<Movie>>(
          builder: (BuildContext context, DataProvider<Movie> notesProvider, Widget? child)
          {
            _context = context;
            return
              Scaffold(
                  appBar:
                  AppBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      title: const Text('פריטים מועדפים', style: TextStyle(color: Colors.white), textDirection: TextDirection.rtl, textAlign: TextAlign.right)),


                  body:
                  Directionality(
                      textDirection: TextDirection.rtl,

                      child:
                      Center(

                          child:
                          FutureBuilder<List<Movie>>(
                              future: getObjects(),
                              builder: (context, snapshot)
                              {
                                Widget widgetFuture = const SizedBox();

                                // If the connection is done,
                                if (snapshot.connectionState == ConnectionState.done)
                                {
                                  if (snapshot.hasData)
                                  {
                                    _context = context;
                                    notes = this.dataProvider.favoriteList as List<Movie>;   //snapshot.requireData;
                                    list = transferData(notes);

                                    widgetFuture =
                                    // Main Column
                                    Column(
                                        textDirection: TextDirection.rtl,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children:
                                        [
                                          // For the ListBox
                                          Container(
                                            alignment: Alignment.topRight,
                                            padding: const EdgeInsets.all(1.0),
                                            margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 5.0),
                                            width: deviceWidth,
                                            height: deviceHeight + 0,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                                                border: Border.all(color: Theme.of(context).colorScheme.secondary),
                                                borderRadius: const BorderRadius.all(Radius.circular(10.3))),

                                            child:
                                            SingleChildScrollView(
                                              child:
                                              Column(
                                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children:
                                                  [
                                                    notes.isNotEmpty

                                                        ? WidgetListView(
                                                              ListItems: list,     //getNewData(),        //notesProvider.favoriteList as List<Movie>
                                                              IsExternalListItemTile: true,
                                                              //ExtractListItemFieldsFunc: getCardFieldsValues,
                                                              CreateListItemTileFunc: CreateListItemTileFunc,
                                                              CreateAdditionalInfoFunc: _createAdditionalInfoFunc,
                                                              ItemTitleForegroundColor: Theme.of(context).colorScheme.primary,
                                                              CardBackgroundColor: Colors.white)

                                                        : const Text('אין מועדפים')
                                                  ]
                                              ),

                                            ),
                                          )
                                        ]
                                    );
                                  }
                                }

                                return widgetFuture;
                              }
                          )

                      )
                  )

              );
          }
      );

  }

  Future<List<Movie>>? getObjects() async
  {
    return this.notes;
  }

  Future<List<Movie>> readFavorite(BuildContext context) async
  {
    notes = await this.dataProvider.readFavorite() as List<Movie>;

    list = transferData(notes);

    //setState(() {});

    return notes;
  }

  /// Property of Provider
  DataProvider get dataProvider
  {
    DataProvider<Movie> notesProvider = Provider.of<DataProvider<Movie>>(_context, listen: false);
    //notesProvider.isEarlyAlarm = isEarlyAlarm;
    notesProvider.context = _context;
    // notesProvider.onNotificationActionReceived = this.onNotificationActionReceived;
    // notesProvider.onNotificationDisplayed = this.onNotificationDisplayed;
    //notesProvider.onShowMessage = ShowMessage;

    return notesProvider;
  }

  Map<String, dynamic> getNewData()
  {
    // list = transferData(notes);

    return list;
  }

  Map<String, dynamic> transferData(List<Movie> list)
  {
    Map<String, dynamic> listTmp = {};

    for (var i = 0; i < list.length; i++)
    {
      Movie object = list[i];
      listTmp['$i'] = object;
    }

    return listTmp;
  }

  Widget CreateListItemTileFunc(BuildContext context, dynamic object)
  {
    Widget tileObject = const Text('');
    bool isShowDetails;
    Widget titleWidget;
    Widget subTitleWidget;
    Widget leadingImageWidget;
    Widget trailingWidget;
    Movie objectInstant = object as Movie;
    late final Widget FavoriteWidget;



    isShowDetails = objectInstant.Description.isNotEmpty;

    subTitleWidget =
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children:
          [
            if (objectInstant.Description.isNotEmpty)
              Text(
                  objectInstant.Description,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontStyle: (objectInstant.IsSelect) ? FontStyle.italic : FontStyle.normal, fontSize: 16,
                            decoration: (objectInstant.StatusID == NoteStatusEn.Completed.value) ? TextDecoration.lineThrough : TextDecoration.none),
                  maxLines: 2,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right),

            const SizedBox(height: 30.0),

            Text(objectInstant.Genre + ", " + objectInstant.Year, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 12),
                 maxLines: 1,
                 textDirection: TextDirection.rtl,
                 textAlign: TextAlign.right),
          ],
        );

    Widget image = Globals.getImageByListType(objectInstant);

    leadingImageWidget =
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child:
          SizedBox(
              width: 50.0,
              height: 50.0,
              child:
                CircleAvatar(child: image)    //backgroundImage: NetworkImage(url)/*, minRadius: 1.0,*/)
          ),
        );

    // Favorite icon
    FavoriteWidget =
        SizedBox(width: 28.0, height: 20.0,
          child:
            IconButton(
                color: Theme.of(context).colorScheme.primary,
                hoverColor: Colors.red,
                icon: Icon(((objectInstant.IsFavorite) ? Icons.favorite : Icons.favorite_border), color: Theme.of(context).colorScheme.primary, size: 28.0, fill: 1.0, textDirection: TextDirection.rtl),
                onPressed: () async
                {
                  await this.dataProvider.saveFavorite(objectInstant);
                }
            ));

    titleWidget = Text(objectInstant.Title,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontStyle: (objectInstant.IsSelect) ? FontStyle.italic : FontStyle.normal, fontSize: 17.0, decoration: (objectInstant.StatusID == NoteStatusEn.Completed.value) ? TextDecoration.lineThrough : TextDecoration.none),
                    maxLines: (objectInstant.Description.isEmpty ? 3 : 2) as int?,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right);

    // Put Title and trailing Image in same row
    titleWidget =
        Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            [
              SizedBox(width: deviceWidth-200, /*height: 25.0,*/
                child:
                titleWidget,
              ),

              FavoriteWidget
            ]);


    if (isShowDetails)
    {
      tileObject =
          ExpansionTile(
            title:    titleWidget,

            subtitle: subTitleWidget,

            //trailing: trailingWidget,

            leading: leadingImageWidget,
            childrenPadding: const EdgeInsets.all(0),
            tilePadding: const EdgeInsets.all(0),

            children:
            [
              _createAdditionalInfoFunc(context, objectInstant)
            ],
          );
    }
    else
    {

      tileObject =
          ListTile(
            title:   titleWidget,

            subtitle: subTitleWidget,

            //trailing: trailingWidget,

            leading: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: leadingImageWidget,
            ),

            isThreeLine: false,

            contentPadding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 2.0, bottom: 0.0),         //all(1.0),
            //titleTextStyle: TextStyle(fontSize: 15, color: Colors.blue), subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.blue),
            style:          ListTileStyle.list,
            titleAlignment: ListTileTitleAlignment.titleHeight,
            visualDensity:  VisualDensity.comfortable,
            iconColor:      Colors.blue,
            selectedColor:  Colors.deepPurpleAccent,
            hoverColor:     Colors.orange,
            focusColor:     Colors.red,
            selectedTileColor: Colors.blue,
            enabled: true,
            dense: false,
            onTap: () async
            {
              await this.onTap(objectInstant);
            },
            // onFocusChange: onFocusChange,
            // onLongPress: onLongPress,
          );
    }



    // tileObject = GestureDetector(
    //   onTap: () async
    //   {
    //     Object? resultNavigator = await Navigator.pushNamed(context, '/details', arguments: NoteDetailsPageArguments<Movie>(noteObject: objectInstant as T, isUpdateMode: true, isFromFavoritePage: true));
    //   },
    //
    //   child: tileObject,
    // );


    return tileObject;
  }

  Future<void> onTap(Object item)  async
  {
    Movie note = item as Movie;
    NoteDetailsPageArguments noteDetailsPageArguments = NoteDetailsPageArguments<Movie>(noteObject: note, isUpdateMode: true);

    Object? resultNavigator = await Navigator.pushNamed(context, '/details', arguments: NoteDetailsPageArguments<Movie>(noteObject: note, isUpdateMode: true, isFromFavoritePage: true));
  }

  String getCardFieldsValues(dynamic obj)
  {
    Movie movie = obj as Movie;
    return "${movie.Title}#${movie.Director}#${(movie.Images!=null && movie.Images!.isNotEmpty) ? movie.Images![0] : ''}";
  }

  Widget _createAdditionalInfoFunc(BuildContext context, dynamic object)
  {
    Widget result;
    Movie movie = object as Movie;


    result =
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),

          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,

            //textDirection: TextDirection.ltr,

            children: [

              RichText(
                  text: TextSpan(style: DefaultTextStyle.of(context).style,
                      children:
                      [
                        TextSpan(text: "Genre: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Genre} \n"),

                        TextSpan(text: "Actors: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Actors} \n"),

                        TextSpan(text: "Year: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Year} \n"),

                        TextSpan(text: "Writers: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Writer} \n"),
                      ]
                  )
              ),

              /// Navigate to the Object Details page
              TextButton(child: const Text('Read more ...'),
                  onPressed: ()
                  {
                    Navigator.pushNamed(context, '/details', arguments: MovieDetailsPageArguments(noteObject: movie, isUpdateMode: true));
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie)),
                    // );
                  }
              )
            ],
          ),
        );

    return result;
  }



// Widget getAdditionalData(dynamic object, BuildContext context)
// {
//   Widget result;
//   Note note = object as Note;
//
//
//   result =
//       Container(
//         alignment: Alignment.topRight,
//         padding: const EdgeInsets.only(left: 10),
//
//         child:
//         Column(
//           textDirection: TextDirection.rtl,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.start,
//
//           children: [
//
//             RichText(
//               textDirection: TextDirection.rtl,
//                 textAlign: TextAlign.right,
//                 text: TextSpan(style: DefaultTextStyle.of(context).style,
//                     children: [
//                       TextSpan(text: "DateDue: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
//                       TextSpan(text: "${note.DateDue} \n"),
//
//                       TextSpan(text: "Status: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
//                       TextSpan(text: "${Globals.getCodeTableDesc(note.StatusID, CodeTableEn.StatuseTable)} \n"),
//
//                       TextSpan(text: "List type: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
//                       TextSpan(text: "${Globals.getCodeTableDesc(note.ListTypeID, CodeTableEn.ListTypesTable)} \n"),
//
//                       TextSpan(text: "Priority: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
//                       TextSpan(text: "${Globals.getCodeTableDesc(note.PriorityID!, CodeTableEn.PrioritiesTable)} \n")
//                     ]
//                 )
//             ),
//
//             /// Navigate to the Object Details page
//             TextButton(child: const Text('Read more ...'),
//                 onPressed: ()
//                 {
//                   Navigator.pushNamed(context, '/details', arguments: MovieDetailsPageArguments(item: note, isUpdateMode: true));
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) => MovieDetailsPage(note: note)),
//                   // );
//                 }
//             )
//           ],
//         ),
//       );
//
//   return result;
// }



}

