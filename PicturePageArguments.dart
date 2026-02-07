
import '../models/Movie.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteImage.dart';


class PicturePageArguments
{
  final Movie             movie;
  /*final*/ List<NoteImage>   images;
  final String            movieTitle;

  PicturePageArguments({required this.movieTitle, required this.images, required this.movie});

}