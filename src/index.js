/* eslint-disable no-unused-vars */
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import * as FirebaseHanle from './components/firebase.js';
//import {PublicFileComponent} from './components/FileReader.js';



var dataMovies = [];
var dataBaseTable = [];
var dataChilds = [];
var dataListTypes = [];
var dataActores = [];
var dataDirector = [];
var dataFilmTypes = [];
var dataGenres = [];
var dataEditors = [];
var dataMusicians = [];
var dataWriters = [];
var dataSubject = [];
var dbData = {};


async function initApp() 
{

  
  try 
  {
    <h1>אנא המתן...</h1>
    
    const dbIndex = FirebaseHanle.dataBaseIndex; 

    // טעינת הנתונים לפני ש-React מתחילה
    //const dbData = {};
    await getData();
    
    dbData = {'dataMovies': dataMovies, 'dataBaseTable': dataBaseTable, 'dataChilds': dataChilds, 
              'dataActores': dataActores, 'dataDirector': dataDirector, 'dataFilmTypes': dataFilmTypes, 'dataGenres': dataGenres, 
              'dataEditors': dataEditors, 'dataMusicians': dataMusicians, 'dataWriters': dataWriters, 'dataListTypes': dataListTypes};

    //handleData();

    const root = ReactDOM.createRoot(document.getElementById('root'));
    
    // מעבירים את הנתונים כ-Props לקומפוננטה הראשית
    root.render(
      <React.StrictMode>
        <App dbData={dbData} dbIndex={dbIndex} />     {/* initialData={dbData, dbIndex} */}
      </React.StrictMode>
    );
  } 
  catch (error) 
  {
    console.error("נכשלה טעינת האפליקציה: ", error);
    // כאן אפשר לרנדר מסך שגיאה ייעודי במקום שהאפליקציה תקרוס
  }
}

initApp();


function handleData()
{
  const dataNew = FirebaseHanle.GetTableDataAsync("TBL_Notes");

  if (dataNew.length)
  {
    const updateData = {...dbData, dataMovies: dataNew};
  }
}

async function getDatabaseIndex( fileName ) 
{
  const response = await fetch("/" + fileName);

  if (!response.ok) 
  {
    throw new Error(`Failed to load launch.json: ${response.statusText}`);
  }

  const obj = await response.json();
  const dbIndex = Number(obj.DatabaselistIndex); 
  
  return dbIndex;
}

async function getData() 
{
  dataBaseTable = await FirebaseHanle.GetTableDataSync("TBL_Databases");

  dataMovies = await  FirebaseHanle.GetTableDataSync("TBL_Movies");

  
 
  //dataListTypes = /* await */ mapToLookupObject('TBL_ListTypes');
  dataActores = await  mapToLookupObject('TBL_Actors');
  dataDirector = await  mapToLookupObject('TBL_Directors');
  dataEditors = await  mapToLookupObject('TBL_Editors');
  dataFilmTypes = await  mapToLookupObject('TBL_FilmTypes');
  dataGenres = await  mapToLookupObject('TBL_Genres');
  dataMusicians = await  mapToLookupObject('TBL_Musicians');
  dataWriters = await  mapToLookupObject('TBL_Writers');
  
 
  dataChilds = await FirebaseHanle.GetTableDataSync("TBL_NotesChilds");
  const subsSorted = [...dataChilds].sort((a, b) => a.NoteID - b.NoteID);

  for (var i = 0; i < subsSorted.length; i++)
  {
    const sub = subsSorted[i];
    const noteID = sub.NoteID;
    const note = dataMovies.find((n) => n.MovieID === noteID);
    // var subList = [];
    // while (sub.NoteID === noteID)
    // {
    //   subList.push(sub);
    // }
    const subList = subsSorted.filter((sub) => sub.NoteID === noteID);
    i = i + subList.length - 1;
    if (note)
    {
      if (subList.length > 0)
        note.SubTasks = subList;
      else
        note.SubTasks = [];
    }
  }

  //dataListTypes = await  mapToLookupObject('TBL_ListTypes');
  
  
  return dataMovies;
}

async function mapToLookupObject(tableName)
{
  const date = await FirebaseHanle.GetTableDataSync(tableName);

  const dataTable = date.map((item) => 
                  {
                    return {
                      label: item.Description,
                      value: item.ID
                    };
                  });

  const result = [...dataTable].sort((a, b) => String(a.label).localeCompare(String(b.label))); 

  return ( result );
}