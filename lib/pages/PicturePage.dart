

import 'package:flutter/material.dart';
import '../utils/Globals.dart';
import '../utils/PicturePageArguments.dart';
//import 'package:multiselect_dropdown/multiselect_dropdown.dart';
// import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
// import 'package:multiselect/multiselect.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/MainGlobals.dart';




class PicturePage extends StatefulWidget
{
  const PicturePage({super.key});

  @override
  State<PicturePage> createState() => _PicturePageState();
}


class _PicturePageState extends State<PicturePage>
{


  @override
  Widget build(BuildContext context)
  {
    final args = ModalRoute.of(context)?.settings.arguments as PicturePageArguments;
    final List<String> moviesLinks = args.moviesLinks;
    final String movieTitle= args.movieTitle;


    return
      Scaffold(
          appBar: AppBar(title: Text('Pictures from $movieTitle', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),

          body:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
              [
                Container(
                  padding: const EdgeInsets.all(0.1),
                  margin: const EdgeInsets.all(5.0),
                  width: 300,
                  height: 570,
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