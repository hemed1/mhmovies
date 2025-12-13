

import 'dart:convert';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteChild.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/NoteImage.dart';
import 'file:///Users/meirh/Desktop/Develope/Flutter/Services/Imh_Object.dart';




class Movie       implements Imh_Object
{
  int             MovieID;
  String          Title;
  String          Description = "";
  String          Director;
  String          Actors='';
  String          Writer;
  String          Year;
  String          Country;
  String          Language;
  String          Rated;
  String          Genre;
  int?            StatusID = 1;
  String          CardBackColor = '';
  int             CreateUserID = 0;
  String          LastUpdateDate = "";
  String          FirebaseID='';
  String          SelfLink='';
  bool            IsFavorite = false;
  bool            IsSelect = false;
  int             ListIndex = 0;
  List<String>    ImagesLinks=[];
  List<NoteImage> Images = [];
  List<NoteChild> SubTasks = [];
  int             FilmTypeID = 1;


  @override
  DateTime? DateDueToDate = null;

  @override
  int get ListTypeID
  {
    return this.FilmTypeID;
  }
  @override
  set ListTypeID(int value)
  {
    this.FilmTypeID = value;
  }

  @override
  List<NoteImage> get images => this.Images;

  @override
  set images(List<NoteImage> list) => this.Images;

  @override
  set SubjectLabels(String) => this.Genre;
  @override
  String get SubjectLabels => this.Genre;



  Movie({
    this.MovieID = 0,
    required this.Title,
    this.Description = "",
    this.Director = "",
    this.Writer = "",
    this.Year = "",
    this.Country = "",
    this.Language = "",
    this.Rated = "",
    this.Genre = "",
    this.StatusID,
    this.FilmTypeID = 1,
    this.CardBackColor = "",
    this.CreateUserID = 0,
    this.LastUpdateDate = "",
    this.FirebaseID = "",
    this.Actors         = '',
    this.ImagesLinks    = const <String>[],
    this.Images         = const <NoteImage>[],
    this.SubTasks       = const <NoteChild>[],
    this.SelfLink = "",
    this.IsFavorite = false,
    this.IsSelect = false,
    this.ListIndex = 0,
    });




  /// When search in internet - Get results in Json file, parse it & Create Book object
  // @override
  factory Movie.fromJson(Map<String, Object?> json, [bool isWithFirebaseID = false])
  {


      Movie movie = Movie(
                      MovieID:      json['MovieID'] as int,
                      Title:        json['Title'] as String,
                      Year:         json['Year'] as String,
                      Description:  json['Description'] as String,
                      Director:     json['Director'] as String,
                      Rated:        json['Rated'] as String,
                      Genre:        json['Genre'] as String,
                      Writer:       json['Writer'] as String,
                      StatusID:     (json['StatusID'] != null) ? json['StatusID'] as int : 1,
                      FilmTypeID:   (json['FilmTypeID'] != null) ? json['FilmTypeID'] as int : 1,
                      Country:      (json['Country'] != null) ? json['Country'] as String : "",
                      Language:     (json['Language'] != null) ? json['Language'] as String : "",
                      SelfLink:     json['SelfLink'] as String,
                      Actors:       json['Actors'] as String,
                      // ImagesLinks:  (json['ImagesLinks'] as String).split(', '),
      );

      final String str = (json['ImagesLinks'] != null) ? json['ImagesLinks'] as String : '';
      final List<String> list = str.split(', ');
      if (str.isNotEmpty)
      {
        movie.ImagesLinks = list;
      }

      if (isWithFirebaseID)
      {
         movie.FirebaseID = json['FirebaseID'] as String;
      }

      return movie;
  }

  /// When saving to DB - Create Map with data from Book object, will looked like a record in db
  Map<String, Object?> toJson([bool isWithID = true, bool isWithUserID= true, bool isWithFirebaseID = false])
  {

    return
      {
        if (isWithID) 'MovieID': this.MovieID,
        'Title': this.Title,
        'Description': this.Description,
        'Director': this.Director,
        'Country': this.Country,
        'Language': this.Language,
        'Writer': this.Writer,
        'Year': this.Year,
        'Rated': this.Rated,
        'FilmTypeID': this.FilmTypeID,
        'Actors': this.Actors,
        'ImagesLinks': this.ImagesLinks.join(', '),
        'Genre': this.Genre,
        'SelfLink': this.SelfLink,
        'CardBackColor': this.CardBackColor,
        'IsFavorite': this.IsFavorite ? 1 : 0,
        if (isWithUserID) 'CreateUserID': this.CreateUserID,
        if (isWithFirebaseID) 'FirebaseID': this.FirebaseID,
      };

    // 'Actors': json.encode((this.Actors!=null) ? this.Actors : ''),
    //'industryIdentifiers': json.encode(this.industryIdentifiers),
  }


  /// When read data from db - From db record in Json format, Create a New Book object
  factory Movie.fromJsonDatabase(Map<String, dynamic> jsonObject)
  {

    Movie movie = Movie(
              MovieID: jsonObject['MovieID'] as int,
              Title: jsonObject['Title'] as String,
              Description: jsonObject['Description'] as String,
              Director: jsonObject['Director'] as String,
              Country: (jsonObject['Country'] != Null) ? jsonObject['Country'] as String : "",
              Language: (jsonObject['Language'] != Null) ? jsonObject['Language'] as String : "",
              Actors: jsonObject['Actors'] as String,
              //ImagesLinks: (jsonObject['ImagesLinks'] is String) ? (jsonObject['ImagesLinks'] as String).split(', ') as List).map((e) => e as String).toList() : [],
              //ImagesLinks: (jsonObject['ImagesLinks'] is String) ? (json.decode(jsonObject['ImagesLinks']) as List).map((e) => e as String).toList() : [],
              SelfLink: jsonObject['SelfLink'] as String,
              Writer: jsonObject['Writer'] as String,
              Genre: jsonObject['Genre'] as String,
              Rated: jsonObject['Rated'] as String,
              FilmTypeID: jsonObject['FilmTypeID'] as int,
              Year: jsonObject['Year'] as String,
              CardBackColor: jsonObject['CardBackColor'] as String,
              IsFavorite: (jsonObject['IsFavorite'] is int) ? (jsonObject['IsFavorite'] as int) == 1 : false,
          );

    final String str = (jsonObject['ImagesLinks'] != null) ? jsonObject['ImagesLinks'] as String : '';
    final List<String> list = str.split(', ');
    if (str.isNotEmpty)
    {
      movie.ImagesLinks = list;
    }

    return movie;
  }


  List<String> stringToList(String separatedString)
  {
    // List<String> actors = separatedString.split(';');
    List<String> result = separatedString.split(';');;

    // for (var item in actors)
    // {
    //   result.add(item);
    // }

    return result;
  }

  @override
  String toString()
  {
    return "${this.Title}";
  }

  List<String> CreateValidUrlsToShowImage()
  {
    List<String> imagesList = [];

    // if (this.SelfLink.isNotEmpty && this.SelfLink.lastIndexOf('/') > -1)
    // {
    //     this.SelfLink = this.SelfLink.substring(0, this.SelfLink.length - 1);
    // }
    if (this.isUrlValid(this.SelfLink))
    {
      imagesList.add(this.SelfLink);
    }

    for (String item in this.ImagesLinks)
    {
      // if (item.isNotEmpty && item.lastIndexOf('/') > -1)
      // {
      //   item = this.SelfLink.substring(0, this.SelfLink.length - 1);
      // }
      if (this.isUrlValid(item))
      {
        imagesList.add(item);
      }
    }

    return imagesList;
  }

  bool isUrlValid(String url)
  {
    bool result = true;

    url = url.toLowerCase().trim();

    if (url.isEmpty) {
      result = false;
    }
    else if (url.startsWith('http') || url.startsWith('www.')) {

      try
      {
        //bool valid = await Network.isValid(url);
        //url = url.replaceAll('https://', '');
        bool valid = Uri.parse(url).host.isNotEmpty; //.tryParse(url);    //.https(url);    // ;
        result = valid;
      }
      catch (e)
      {
        return false;
      }
    }
    else if (url.startsWith('file') || url.startsWith('/'))
    {
      //bool fileFound = File(url).existsSync();
      Uri? uri = Uri.file(url);
      if (uri.host.isEmpty) //  /data/data/com.example.mhmovies/files/images/The_lord_of_the_ring-1.jpeg
        //if (!fileFound)
       {
        result = true;  //false;
      }
      else
      {
        result = true;
      }
    }

    return result;
  }

  @override
  int get ObjectID
  {
    return MovieID;
  }
  @override
  set ObjectID(int value)
  {
    MovieID = value;
  }








}