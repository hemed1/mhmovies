
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/Movie.dart';
import '../utils/Globals.dart';
import '../utils/PicturePageArguments.dart';
//import 'package:multiselect_dropdown/multiselect_dropdown.dart';
// import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
// import 'package:multiselect/multiselect.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteImage.dart';



class PicturePage extends StatefulWidget
{
  const PicturePage({super.key});

  @override
  State<PicturePage> createState() => _PicturePageState();
}


class _PicturePageState extends State<PicturePage>
{
  late ScrollController scrollControllerList;
  late double screenHeight;
  late double screenWidth;
  late double scrollerOffset = 0;
  int scrollerIndex = 0;


  @override
  void initState()
  {
    super.initState();
    scrollControllerList = ScrollController();
    scrollControllerList.addListener(()
    {
      final itemSize = screenWidth - 20;
      scrollerIndex = (scrollControllerList.offset / itemSize).round() + 0;
      scrollerOffset = scrollControllerList.offset;
      //print(scrollerOffset); // <-- This is it.
      //print(scrollerIndex);
    });
  }

  @override
  void dispose()
  {
    scrollControllerList.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context)
  {
    final args = ModalRoute.of(context)?.settings.arguments as PicturePageArguments;
    final Movie movie = args.movie;
    final List<String> moviesLinks = args.moviesLinks;
    final String movieTitle= args.movieTitle;

    Size size = MainGlobals.getScreenSize(context);
    screenHeight = size.height - 230.0;   // AppBar width, down buttons width
    screenWidth = size.width - 35.0;

    return
      Scaffold(
          appBar: AppBar(title: Text(movieTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),

          body:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
              [
                // Add/Delete buttons
                SizedBox(height: 80.0, //width: 110.0,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                    [
                      // Add Image button
                      Column(
                        children:
                        [
                          IconButton(
                              onPressed: () async
                              {
                                Map<String, Object?>? image = await MainGlobals.pickImageFromLibrary();
                                if (image != null)
                                {
                                  final String path = image['key'] as String;
                                  final Uint8List? imageBytes = image['value'] as Uint8List;

                                  if (imageBytes == null)
                                  {
                                    return;
                                  }

                                  setState(()
                                  {
                                    final NoteImage noteImage = NoteImage(NoteID: movie.ObjectID, Image: imageBytes, FirebaseID: '');
                                    movie.Images.add(noteImage);
                                    //args.images = note.images;
                                    //scrollControllerList.jumpTo(scrollControllerList.position.minScrollExtent);
                                    scrollControllerList.animateTo(/*scrollerOffset*/ scrollControllerList.position.maxScrollExtent + 380, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
                                  });
                                }
                              },
                              color: Theme.of(context).colorScheme.primary,
                              icon: const Icon(Icons.add_a_photo_outlined, size: 30.0)),

                          Text('בחר תמונה', style: MainGlobals.g_styleFieldsCaptions)
                        ],
                      ),

                      // Delete Image button
                      Column(
                        children:
                        [
                          IconButton(
                              onPressed: () async
                              {
                                if (scrollerIndex < movie.images.length)
                                {
                                  NoteImage noteImage = movie.images.elementAt(scrollerIndex);
                                  setState(()
                                  {
                                    movie.images.remove(noteImage);
                                    // args.images = note.images;
                                  });
                                }
                              },
                              color: Theme.of(context).colorScheme.primary,
                              icon: const Icon(Icons.delete_forever, size: 30.0)),

                          Text('מחק תמונה', style: MainGlobals.g_styleFieldsCaptions)
                        ],
                      ),
                    ],
                  ),
                ),


                Container(
                  padding: const EdgeInsets.all(0.1),
                  margin: const EdgeInsets.all(5.0),
                  width: 300,
                  height: 650,
                  //double.infinity,
                  decoration: BoxDecoration(
                      color:  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3.0),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),

                  child:
                    ListView.builder(
                      itemCount: moviesLinks.length,
                      physics: const BouncingScrollPhysics(),
                      // ClampingScrollPhysics(),mNeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      controller: scrollControllerList,
                      itemBuilder: (context, index)
                      {
                        Widget imageWidget = MainGlobals.extractUrl(moviesLinks[index], true);

                        return
                          Card(
                              elevation: 4.0,
                              child:
                                SizedBox(
                                  width: 390,
                                  height: 250,  //double.infinity,
                                  child:

                                    imageWidget
                                )
                          );
                      }
                  ),

                )
              ]
          )
      );
  }
}