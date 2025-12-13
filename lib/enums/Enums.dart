
enum NoteFilterModeEn
{
  all('הכל'),
  allWithOutArchive("הכל - בלי ארכיון"),
  today('להיום'),
  dateDue('מתוזמנות'),
  specificDay('לתאריך מסויים'),
  dateDueWithOut('לא מתוזמנות'),
  statusNoDone('לא בוצעו'),
  statusPartCompleted('בוצעו חלקית'),
  statusCompleted('הושלמו'),
  statusInArchive('בארכיון'),
  typeTask('משימה'),
  typeReminder('תזכורת'),
  typeNote('פתק'),
  typeShopList('רשימת-קניות'),
  typeRecipe('מתכון'),
  typeWork('קשור לעבודה'),
  typeCalendar('אירוע ביומן'),
  subjects('תוויות');

  final String value;
  const NoteFilterModeEn(String this.value);
}

enum NoteStatusEn
{
  Open(1),
  PartialCompleted(2),
  Completed(3),
  InArchive(4);
  final int value;
  const NoteStatusEn(this.value);
}

enum NoteListTypeTypesEn
{
  Reminder(1),
  Note(2),
  Task(3),
  Work(4),
  Calendar(5),
  ShopList(6),
  Recipe(7);
  final int value;
  const NoteListTypeTypesEn(this.value);
}

enum NotePrioritiesEn
{
  Low(1),
  Normal(2),
  High(3);
  final int value;
  const NotePrioritiesEn(this.value);
}

enum NotesOrderByEn
{
  Title,
  DateDue,
  Description,
  Status,
  ListType,
  Priority,
  Subject,
  LastUpdateDate
}

enum NotesOrderDirectionByEn
{
  ascending,
  descending,
}



// enum AlertDialogOptionEn
// {
//   Close,
//   YesNo,
//   AcceptDinied
// }

// enum AlertDialogResultEn
// {
//   OK,
//   Yes,
//   No,
//   Close,
//   Cancel,
//   Accept,
//   Dinied
// }

enum CodeTableEn
{
  StatuseTable,
  FilmTypesTable,
  ActorsTable,
  GenresTable,
  Directors
}

