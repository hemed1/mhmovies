

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/DataProvider.dart';
import '../utils/MovieDetailsPageArguments.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Widgets/WidgetListView.dart';
import '../models/Movie.dart';




class FavoritesPage extends StatefulWidget
{
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}


class _FavoritesPageState extends State<FavoritesPage>
{
  Map<String, dynamic> list  = {};
  List<Movie>  _movies = [];
  bool isFirstTime = true;
  late BuildContext _context;


  @override
  Widget build(BuildContext context)
  {
    _context = context;


    if (isFirstTime)
    {
      getDataAsync();
      isFirstTime = false;
    }

    list = transferData(_movies);

    return
      Scaffold(

        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text('Favorites', style: TextStyle(color: Colors.white),)
        ),

        body:
          Center(
            child:

            Column(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                [

                    // For the ListBox
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.all(10.0),
                      width:  300,
                      height: 630,   //double.infinity,
                      decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                                    border: Border.all(color: Theme.of(context).colorScheme.secondary),
                                    borderRadius: const BorderRadius.all(Radius.circular(10.3))),

                      child:
                        // You cannot use Expanded in Column if it has a parent SingleChildScrollView because When you use column it tries to be in screen height and when use expanded inside,
                        // The column will allocate remaining space to the child of the expanded widget,
                        // Now if you use SingleChildScrollView It will try to expand(by direction, vertically in your case) as long as possible
                        // but as you're using the Expanded which tries to take remaining space, So it goes infinite thus throws that error,
                        // So Either remove SingleChildScrollView and use Column and expanded or remove the Expanded and Use SingleChildScrollView also make sure ShrinkWrap in ListView to true.
                        SingleChildScrollView(

                          child:
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              //mainAxisSize: MainAxisSize.max,
                              children:
                              [
                                // FutureBuilder(
                                //     future: readFavorite(),
                                //     builder: (context, snapshot)
                                //     {
                                //       Widget result;
                                //
                                //       if (snapshot.connectionState == ConnectionState.waiting)
                                //       {
                                //         result = const Center(child: CircularProgressIndicator());
                                //       }
                                //       else if (snapshot.hasError)
                                //       {
                                //         result = Center(child: Text('Error: ${snapshot.error}'));
                                //       }
                                //       else if (snapshot.hasData && snapshot.data!.isNotEmpty)
                                //       {
                                //         _movies = snapshot.data!;
                                //         list = transferData(_movies);
                                (_movies.isNotEmpty)

                                        // Generic ListView
                                        ? WidgetListView(ListItems: list,
                                                        IsExternalListItemTile: false,
                                                        ExtractListItemFieldsFunc: getCardFieldsValues,
                                                        CreateAdditionalInfoFunc: getAdditionalData,
                                                        CardBackgroundColor: Colors.white)

                                        //result =    //Text('${_movies.length} Favorite');
                                        //? WidgetListView(movies: _movies,)
                                        : const Text('No Favorite movies')
                                    //   }
                                    //   else
                                    //   {
                                    //     result = const Text('No Favorite movies');
                                         //const Center(child: CircularProgressIndicator()),
                                    //   }
                                    //
                                    //   return result;
                                    // }
                                //)
                              ]
                           ),
                        ),
                    )
                ]
          )
      )
    );
  }




  void getDataAsync(/*BuildContext context*/) async
  {
    _movies = await readFavorite();
    // bool res = await DatabaseHelper.instance.backupDB();
    list = transferData(_movies);
    setState(() {});
  }

  Future<List<Movie>> readFavorite() async
  {
    List<Movie> movies = await this.dataProvider.readFavorite() as List<Movie>;

    return movies;
  }

  Map<String, dynamic> transferData(List<Movie> list)
  {
    Map<String, dynamic> listTmp = {};

    for (var i = 0; i < list.length; i++)
    {
      Movie movie = list[i];
      listTmp['$i'] = movie;
    }

    return listTmp;
  }

  /// Property of Provider
  DataProvider get dataProvider
  {
    DataProvider<Movie> notesProvider = Provider.of<DataProvider<Movie>>(this._context, listen: false);
    notesProvider.context = this._context;
    return notesProvider;
  }

  String getCardFieldsValues(dynamic obj)
  {
    Movie movie = obj as Movie;
    return "${movie.Title}#${movie.Director}#${(movie.Images!=null && movie.Images!.isNotEmpty) ? movie.Images![0] : ''}";
  }

  Widget getAdditionalData(BuildContext context, dynamic object)
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
                      children: [
                        TextSpan(text: "Year: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Year} \n"),

                        TextSpan(text: "Actors: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Actors} \n"),

                        TextSpan(text: "Writers: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Writer} \n"),

                        TextSpan(text: "Genre: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(text: "${movie.Genre} \n")
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


}

