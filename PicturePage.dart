
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/Movie.dart';
import '../utils/Globals.dart';
import '../utils/PicturePageArguments.dart';
// 'package:multiselect_dropdown/multiselect_dropdown.dart';
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
  late Movie CurrentMovie;

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
    this.CurrentMovie = args.movie;
    final List<NoteImage> imagesList = args.images;
    final String movieTitle= args.movieTitle;

    Size size = MainGlobals.getScreenSize(context);
    screenHeight = size.height - 230.0;   // AppBar width, down buttons width
    screenWidth = size.width - 35.0;

    // imagesList.addAll(this.CurrentMovie.Images);

    return
      Scaffold(
          appBar: AppBar(title: Text(movieTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),

          body:
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    final NoteImage noteImage = NoteImage(NoteID: this.CurrentMovie.ObjectID, Image: imageBytes, FirebaseID: '');
                                    this.CurrentMovie.Images.add(noteImage);
                                    imagesList.add(noteImage);
                                    args.images = imagesList;
                                    scrollControllerList.animateTo(/*scrollerOffset*/ scrollControllerList.position.maxScrollExtent + 380, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
                                    //scrollControllerList.jumpTo(scrollControllerList.position.minScrollExtent);
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
                                if (scrollerIndex < imagesList.length)
                                {
                                  setState(()
                                  {
                                    if (imagesList[scrollerIndex].Image.isNotEmpty)
                                    {
                                      NoteImage noteImage = this.CurrentMovie.Images.firstWhere((e) => e.Image.length == imagesList[scrollerIndex].Image.length);
                                      this.CurrentMovie.Images.remove(noteImage);
                                      imagesList.removeAt(scrollerIndex);
                                    }
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
                  padding: const EdgeInsets.all(1.0),
                  margin: const EdgeInsets.all(9.0),
                  width: screenWidth - 100,
                  height: screenHeight - 40,
                  decoration: BoxDecoration(
                      color:  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.0),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),

                  child:
                    ListView.builder(
                      itemCount: imagesList.length,
                      physics: const BouncingScrollPhysics(),
                      // ClampingScrollPhysics(),mNeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      controller: scrollControllerList,
                      itemBuilder: (context, index)
                      {
                        Widget? imageWidget = const SizedBox();
                        if (imagesList[index].Image.isEmpty && MainGlobals.isUrlValid(imagesList[index].ImageName))
                        {
                          imageWidget = MainGlobals.extractUrl(imagesList[index].ImageName, true);
                        }
                        else if (imagesList[index].Image.length > 0)
                        {
                          imageWidget = Image.memory(imagesList[index].Image);
                        }

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


  // List<NoteImage> CreateValidUrlsToShowImage()
  // {
  //   List<NoteImage> imagesList = [];
  //
  //
  //   if (MainGlobals.isUrlValid(this.CurrentMovie.SelfLink))
  //   {
  //     List<int> image = [];
  //     NoteImage noteImage =NoteImage(NoteID: this.CurrentMovie.MovieID, Image: Uint8List.fromList(image), FirebaseID: this.CurrentMovie.FirebaseID, ImageName: this.CurrentMovie.SelfLink);
  //     imagesList.add(noteImage);
  //   }
  //
  //   for (String item in this.CurrentMovie.ImagesLinks)
  //   {
  //     if (MainGlobals.isUrlValid(item))
  //     {
  //       List<int> image = [];
  //       NoteImage noteImage =NoteImage(NoteID: this.CurrentMovie.MovieID, Image: Uint8List.fromList(image), FirebaseID: this.CurrentMovie.FirebaseID, ImageName: item);
  //       imagesList.add(noteImage);
  //
  //     }
  //
  //     // for (NoteImage noteImage in this.CurrentMovie.Images)
  //     // {
  //     //   imagesList.add(noteImage);
  //     // }
  //   }
  //
  //   return imagesList;
  // }
}