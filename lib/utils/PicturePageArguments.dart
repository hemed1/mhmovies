
import '../models/Movie.dart';


class PicturePageArguments
{
  final Movie         movie;
  final List<String>  moviesLinks;
  final String        movieTitle;

  PicturePageArguments({required this.movieTitle, required this.moviesLinks, required this.movie});

}