
import '../models/Movie.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


class MovieDetailsPageArguments<T>
{
  final T                 noteObject;
  bool                    isUpdateMode;
  bool                    isEarlyAlarm = false;
  bool                    isFromFavoritePage = false;

  final Function(String message)?     onEvenDeleteSucss;
  final ReceivedAction?               onNotificationActionReceived;
  final ReceivedNotification?         onNotificationDisplayed;


  MovieDetailsPageArguments({required this.noteObject, required this.isUpdateMode, this.onEvenDeleteSucss, this.onNotificationActionReceived, this.onNotificationDisplayed, this.isFromFavoritePage = false, this.isEarlyAlarm = false});   //, required this.isFromSavedScreen});

}