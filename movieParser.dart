
import 'dart:convert';
import '../models/movie.dart';


class MovieParser
{

  static List<Movie> parse(String jsonStrings)
  {
    final List<dynamic> paresJsonList = json.decode(jsonStrings);
    final List<Movie> movies = paresJsonList.map((jsonItem) => Movie.fromJson(jsonItem as Map<String, dynamic>)).toList();

    return movies;
  }
}