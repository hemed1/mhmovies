


import './App.css';
import './styles.css';
import { useState, useMemo, useRef } from 'react';
import * as FirebaseHanle from './components/firebase.js';
import * as Globals from './globals.js';
//import { ColourOption, colourOptions } from '../data';
// https://react-select.com/home
import './components/menusComponent.css';
import * as GridHandle from './components/GridWidget.js'
import Select, { StylesConfig } from 'react-select';
import { AlignRight, Plus, Trash2/* , X, ChevronRight, Users, Subtitles, CheckLine, Check, CheckIcon, CheckLineIcon, EllipsisVertical */ } from "lucide-react";



const saveModeEn = { INSERT: 1, UPDATE: 2, DELETE: 3 };

var dataMovies = [];
var dataChilds = [];
var dataBaseTable = [];
var dataActores = [];
var dataDirector = [];
var dataFilmTypes = [];
var dataGenres = [];
var dataEditors = [];
var dataMusicians = [];
var dataWriters = [];

/// Fields controller vars
var f_update_mode = true;
var f_dataBaseIndex = 0;

let rowCounter = 0;
const newRowId = () => `row-${Date.now()}-${rowCounter++}`;




export default function App({dbData, dbIndex} )      /* initialData */ 
{
  const [selectedItem, setSelectedItem] = useState(null);
  const [data, setData] = useState(dbData);
  //const [dataOriginal, setDataOriginal] = useState(dbData);
  const [dataBaseIndex] = useState(dbIndex);
  const [isShowGrid, setIsShowGrid] = useState(false);
  const [gridData, setGridData] = useState(null);
  const [selectedCode, setSelectedCode] = useState(2);
  const [isMenuOpen1, setIsMenuOpen1] = useState(false);
  const [selectedDatabaseIndex, setSelectedDatabaseIndex] = useState(null);

  //dbData = dataOriginal;

  dataMovies = data['dataMovies'];
  dataBaseTable = data['dataBaseTable'];
  dataActores = data['dataActores'];
  dataDirector = data['dataDirector'];
  dataFilmTypes = data['dataFilmTypes'];
  dataGenres = data['dataGenres'];
  dataEditors = data['dataEditors'];
  dataMusicians = data['dataMusicians'];
  dataWriters = data['dataWriters'];
  dataChilds = data['dataChilds'];

  f_dataBaseIndex = dataBaseIndex;


  
  function toggleMenu1() 
  {
      setSelectedCode(2);
      setIsMenuOpen1(!isMenuOpen1);
  }  

  function handleSelectItem( selectedItem )
  { 
    f_update_mode = true;
    if (selectedItem !== null)
    {
      setSelectedItem((curr) => curr?.MovieID === selectedItem.MovieID ? null : selectedItem);
    }
    else
    {
      setSelectedItem(null);
    }
  }

  async function handleSelectDatabase(dbIndex)
  { 
    f_dataBaseIndex = dbIndex;
    setSelectedDatabaseIndex(dbIndex);

    await FirebaseHanle.changeDatabase(dbIndex);

    setIsShowGrid(false);
  }

   /// When save SubTasks
  function handleSaveSubTasks( notesData )
  {
      dataMovies = notesData;
      
      const newList = {...data, dataMovies: dataMovies }
      setData(newList);
      dbData = newList;
      //setDataOriginal(newList);
  }

  function handleSaveLookup(tableName, newData)
  {

    let newList;
    
    const sortedList = [...newData].sort((a, b) => String(a.label).localeCompare(String(b.label)));
    newData = sortedList;

    switch (tableName)
    {
      case 'TBL_Actors':
        dataActores = sortedList;
        newList = {...data, dataActores: dataActores }
        break;
      case 'TBL_Directors':
        dataDirector = sortedList;
        newList = {...data, dataDirector: dataDirector }
        break;
      case 'TBL_Genres':
        dataGenres = sortedList;
        newList = {...data, dataGenres: dataGenres }
        break;
      case 'TBL_Musicians':
        dataMusicians = sortedList;
        newList = {...data, dataMusicians: dataMusicians }
        break;
      case 'TBL_Writers':
        dataWriters = sortedList;
        newList = {...data, dataWriters: dataWriters }
        break;
      default:
        return;
    }
    
    setData(newList);
    dbData = newList;
    //setDataOriginal(newList);

    setSelectedItem(null);
    handleSelectItem(selectedItem);
  }

  async function onGridSaveFuncName( tableName, records)
  {
    var result = false;

    for (var i=0; i<records.length; i++)
    {
      const record = records[i];
      const values = {};    //record.itemObject;
      values[record.fieldName] = record.value;

      if (record.value !== 'deleted')
      {
        result = await FirebaseHanle.UpdateField(tableName, record.id, values);
        dataMovies = [...dataMovies].map((item) => (item.id === record.id) ? {...record.itemObject, [record.fieldName]: record.value} : item);
      }
      else
      {
        result = await FirebaseHanle.DeleteRecord(tableName, record.id);
        dataMovies = [...dataMovies].filter((item) => item.id !== record.id);
      }
    }

    const newList = {...data, dataMovies: dataMovies }
    setData(newList);
    dbData = newList;
    //setDataOriginal(newList);

    if (records.length>0)
    {
      if (result)
      {
          alert("השמירה הצליחה");
      }
      else
      {
          alert("השמירה נכשלה");
      }
    }


    switch (tableName)
    {
      case 'TBL_Databases':
        return dataBaseTable;

      case 'TBL_NotesChilds':
        return dataChilds;

      case 'TBL_Notes':
      default:
        return dataMovies;
    }
    
  }

  function showDataGridNotes()
  {
    setIsShowGrid(!isShowGrid);
    setSelectedCode(21)

    const arrayColumns = [
                        {caption: 'מזהה', fieldName: 'MovieID', type: 'number', width: '100px', color: '#303033'}, 
                        {caption: 'מזהה רשומה', fieldName: 'FirebaseID', type: 'string', width: '280px', color: '#303033'},
                        {caption: 'כותרת', fieldName: 'Title', type: 'string', width: '280px', color: '#303033'},
                        {caption: 'תיאור', fieldName: 'Description', type: 'string', width: '400px', color: '#303033'},
                       ]

    GridHandle.GridReset();
    //GridHandle.f_grid_mode = 0

    setGridData(
      <GridHandle.GridWidget  data={dataMovies} title='ניהול נתונים' tableName='TBL_Movies' arrayColumns={arrayColumns} 
                              top='190px' left='150px' width='1120px' height='900px' onSaveFuncName={onGridSaveFuncName} />
    );
  }

  function showDataGridChilds()
  {
    setIsShowGrid(!isShowGrid);
    setSelectedCode(2)

     const arrayColumns = [
                            {caption: 'מזהה רשומה', fieldName: 'FirebaseID', type: 'string', width: '280px', color: '#303033'},
                            {caption: 'מזהה פתק', fieldName: 'NoteID', type: 'number', width: '130px', color: '#303033'}, 
                            {caption: 'תוכן', fieldName: 'Title', type: 'string', width: '280px', color: '#303033'},
                            {caption: 'בוצע', fieldName: 'IsDone', type: 'bool', width: '70px', color: '#303033'},
                          ]
    GridHandle.GridReset();
    //GridHandle.f_grid_mode = 0

    setGridData(
      <GridHandle.GridWidget data={dataChilds} title='ניהול נתונים' tableName='TBL_NotesChilds' arrayColumns={arrayColumns} 
                                        top='190px' left='150px' width='820px' height='900px' onSaveFuncName={onGridSaveFuncName} />
    );
  }



  return (

    <div className='App'>
      
      <nav className="navbar">
        
                <ul className="nav-menu">
                    
                    <li key='1' className='nav-item'>
                        <a key='1' className={(selectedCode === 1) ? "active" : ""} href="#home" onClick={(e) => setIsShowGrid(false)}>Home</a>
                    </li>
                    
                    
                    {/* <!-- First Dropdown Parent --> */}
                    <li key='2'className="nav-item">
                        <a key={2} href="#services" className={`has-children ${(selectedCode === 2) ? "active" : ""}`} onClick={(e) => setSelectedCode(2)}>שרותים</a>
                    
                        {/* <!-- Level 1 Dropdown --> */}
                        <ul className="submenu">
                            <li>
                                <a href="#web-design" className="has-children" onClick={(e) => toggleMenu1()}>מסד-נתונים</a>
                                {/* <!-- Level 2 Dropdown (Submenu) --> */}
                                <ul className="submenu">
                                    <li>
                                      <a key={21} href='#note'  className='has-children'>החלפת מסד</a>
                                        <ul className="submenu" value={selectedDatabaseIndex}  style={{listStyleType: 'none', direction: 'ltr', textAlign: 'left', backgroundColor: '#edcb8b'}}  onChange={(e) => handleSelectDatabase(Number(e.target.value))} >
                                        {
                                            FirebaseHanle.DataBasesConfigList.map((item, index) =>
                                            (
                                                <li key={index} style={{width: '200px'}} onClick={(e) => handleSelectDatabase(index)}>
                                                  <a href={`#${index}`} > {`${index+1} - ${item.projectId}`} </a> 
                                                </li>
                                            ))
                                        }
                                        </ul>
                                    </li>
                                    
                                    <li><a key={22} href="#child" onClick={(e) => showDataGridChilds()}>צמצום מזההי פתקים</a></li>
                                    {/* <li><a key={23} href="#database" onClick={(e) => showDataGridDatabase()}>טבלת מסד-נתונים</a></li> */}
                                </ul>
                            </li>
                                
                            {/* <!-- Nested Submenu Parent --> */}
                            <li>
                                <a href='#development' className="has-children">ניהול נתונים</a>
                                <ul className="submenu">
                                    <li><a key={21} href='#note' onClick={(e) => showDataGridNotes()} className='has-children'>טבלת פתקים</a></li>
                                    <li><a key={22} href="#child" onClick={(e) => showDataGridChilds()}>טבלת בנים</a></li>
                                    {/* <li><a key={23} href="#database" onClick={(e) => showDataGridDatabase()}>טבלת מסד-נתונים</a></li> */}
                                    {/* <li><a key={23} href="#database-main" onClick={(e) => showDataGridMainDatabase()}>טבלת מסד-נתונים מרכזי</a></li> */}
                                </ul>
                            </li>
                            
                            <li><a href="#marketing">שוק</a></li>
                        </ul>
                    </li>
        
                 
                    <li key='3' className="nav-item">
                        <a key='3' className={(selectedCode === 3) ? "active" : ""} onClick={(e) => setSelectedCode(3)} href="#contact">Contact</a>
                    </li>
        
        
                    {/* <!-- Second Dropdown Parent --> */}
                    <li key='4' className="nav-item">
                        <a key='4' className={"has-children" + (selectedCode === 4 ? " active" : "")} href="#about"  onClick={(e) => setSelectedCode(4)}>About</a>
                        <ul className="submenu">
                            <li><button>Our Team</button></li>
                            <li><button>Company History</button></li>
                        </ul>
                    </li>   
        
                </ul>
                
      </nav>


      {!isShowGrid && 
        <div className="app">
          <ListData 
              data={dataMovies} 
              selectedItem ={selectedItem} 
              onSelectedItem={handleSelectItem}
              sortByField="title" />

          {selectedItem && 
            <NoteScreen 
                selectedItem={selectedItem} 
                onSelectedItem={handleSelectItem}
                onSaveSubTasks={handleSaveSubTasks}
                onSaveLookup={handleSaveLookup}
                /* onDeleteSubTask={handleDeleteSubTask} */ />
          }
        </div>
      }

      { isShowGrid && gridData }   

    </div>

  );

}

// async function init(){

//   await getData();

// }

// async function getData() {

//   dataMovies = /* await */ GetTableData("TBL_Movies");

//   dataBaseTable = /* await */ GetTableData("TBL_Databases");

//   //dataListTypes = /* await */ mapToLookupObject('TBL_ListTypes');
//   dataActores = /* await */ mapToLookupObject('TBL_Actors');
//   dataDirector = /* await */ mapToLookupObject('TBL_Directors');
//   dataEditors = /* await */ mapToLookupObject('TBL_Editors');
//   dataFilmTypes = /* await */ mapToLookupObject('TBL_FilmTypes');
//   dataGenres = /* await */ mapToLookupObject('TBL_Genres');
//   dataMusicians = /* await */ mapToLookupObject('TBL_Musicians');
//   dataWriters = /* await */ mapToLookupObject('TBL_Writers');
//   dataMusicians = /* await */ mapToLookupObject('TBL_Musicians');

//   return dataMovies;
// }

// function mapToLookupObject(tableName)
// {
//   const date = /* await */ GetTableData(tableName);

  
//   const dataTable = date.map((item) => 
//                   {
//                     //const finalScore = num * 10; // Extra logic here
//                     return {
//                       label: item.Description,
//                       value: item.ID
//                     };
//                   });

//                   //dataSubject = dateS.map((item, index) => ({ label: item.Description, value: item.ID }));
//   const result = [...dataTable].sort((a, b) => String(a.label).localeCompare(String(b.label))); 

//   return ( result );
// }

function ListData({data, selectedItem, onSelectedItem, sortByField}) 
{
  const [selectedIndex, setSelectedIndex] = useState(null);
  const [sortBy, setSortBy] = useState('titlee'); 
  const [searchText, setSearchText] = useState('');
  
  

  
  // Compute the sorted array dynamically 
  const sortedProducts = useMemo(() => 
                          {
                            switch (sortBy)
                            {
                              // case 'date_update':
                              //   //const sorted = [...data].sort((a, b) => (new Date(b.LastUpdateDate)) - (new Date(a.LastUpdateDate)));
                              //   //const sorted = data.toSorted((a, b) => (new Date(b.LastUpdateDate))/* .getTime() */ - (new Date(a.LastUpdateDate))/* .getTime() */);
                              //   return [...data].sort((a, b) => 
                              //                     (
                              //                       ((b.LastUpdateDate) 
                              //                       ? (new Date(String(b.LastUpdateDate.substring(0, 16).replace('T', ' ').replace(', ', ' '))))
                              //                       : "")
                              //                       - 
                              //                       ((a.LastUpdateDate)
                              //                       ? (new Date(String(a.LastUpdateDate.substring(0, 16).replace('T', ' ').replace(', ', ' '))))
                              //                       : "")
                              //                     ));
                              //   break;
                            
                              case 'actor':
                                return [...data].sort((a, b) => b.Actors - a.Actors);

                              case 'rated':
                                return [...data].sort((a, b) => b.Rated - a.Rated);

                              case 'year':
                                //const sorted = [...data].sort((a, b) => (new Date(a.DateDue)) - (new Date(b.DateDue)));
                                //const sorted = data.toSorted((a, b) => (new Date(a.DateDue))/* .getTime() */ - (new Date(b.DateDue))/* .getTime() */);
                                return [...data].sort((a, b) => b.Year - a.Year);
                                break;
                            
                              case 'title': 
                              default:
                                return [...data].sort((a, b) => String(a.Title).localeCompare(String(b.Title)));
                                break;
                          }
                        }, [data, sortBy]);



  function handleChangeSort(e, text)
  {
    e.preventDefault();
    setSortBy(text);
  }

  async function handleInsert()
  {
    const itemObject = Movie();
    onSelectedItem(itemObject);
  }

   /// Just for update 'selectedIndex' var
  function handleChangeSelect(itemObject, index)
  {
    setSelectedIndex(index);
    onSelectedItem(itemObject);
  }


  return (
    
        <div style={{display: 'flex', flexDirection: 'column', rowGap: '6px', marginTop: '10px', marginRight: '50px'}}>

          <div style={{display: 'flex', flexDirection: 'column', gap: '10px'}}>
            <div style={{display: 'flex', flexDirection: 'row', gap: '40px', justifyContent: 'space-between'}}>
              <div style={{display: 'flex', flexDirection: 'row', gap: '10px'}}>
                <button type='button' onClick={(e, text) => handleChangeSort(e, 'title')}>כותרת</button>
                <button type='button' onClick={(e, text) => handleChangeSort(e, 'year')}>שנה</button>
                <button type='button' onClick={(e, text) => handleChangeSort(e, 'actor')}>שחקן</button>
                <button type='button' onClick={(e, text) => handleChangeSort(e, 'rated')}>להיום</button>
              </div>
              <button type='button' style={{width: '60px', backgroundColor: 'green', color: 'white'}}  onClick={handleInsert}>חדש</button>
            </div>
            <input type='text' value={searchText} placeholder='חפש...'  onChange={(e) => setSearchText(e.target.value)}   style={{height: '40px', width: '700px'}}></input>
          </div>

          <form className="accordion">
            <ul className='list' key="friend-list">
            {
              sortedProducts
                        .filter(item => 
                            (String(searchText) !== '')  
                            ? ((String(item.Title).indexOf(searchText)>-1) || (String(item.Description).indexOf(searchText)>-1))
                            : true
                        )
                        .map((item, index) => 
                        (
                          <ListDataItem   index={index}
                                          itemObject={item}
                                          selectedIndex={selectedIndex}
                                          selectedItem={selectedItem}
                                          onSelectedItem={handleChangeSelect}
                                          key={index}
                          >
                              {item.Description}
                          </ListDataItem>
                        ))
            }
            </ul>
          </form>

        </div>
      
  );



}
 
function ListDataItem({index, selectedIndex, itemObject, selectedItem, onSelectedItem, children}) 
{

  const isSelected = (selectedItem?.MovieID === itemObject.MovieID);
  const [isOpen, setIsOpen] = useState(false);

  //console.log(index, selectedIndex, selectedItem?.Title, itemObject.Title);


  return(
   
    <li className={`item ${ isSelected ? "open" : ""}`} onClick={() => onSelectedItem(itemObject, index)}>
      <p className='number'>{(index < 9) ? `0${index+1}` : index+1}</p>
      <p className='title'>{itemObject.Title}</p>
      { children !== '' &&
            <button type="button" className='icon' onClick={(e) => 
                                              {
                                                e.stopPropagation();
                                                setIsOpen(!isOpen);
                                              }}>
                { isOpen ? '-' : '+' }
            </button>
      }
      
      {isOpen && children !=='' &&
          <textarea readOnly='true' className='content-box' >{children}</textarea>
      }
    </li>
  );

}

function NoteScreen({ selectedItem, onSelectedItem, onSaveSubTasks, onSaveLookup }) 
{

    /// Controls values states
    const [title, setTitle] = useState(selectedItem?.Title || '');
    const [desc, setDesc] = useState(selectedItem?.Description || '');
    const [filmTypeID, setFilmTypeID] = useState(selectedItem?.ListTypeID || 3);
    const [rated, setRated] = useState(selectedItem?.StatusID || 1);
    const [year, setYear] = useState('');
    const [genres, setGenre] = useState('');
    const [actores, setActores] = useState('');
    const [director, setDirector] = useState('');
    const [writer, setWriter] = useState('');
    const [editor, setEditor] = useState('');
    const [selfLink, setSelfLink] = useState('');
    const [music, setMusic] = useState('');
    const [country, setCountry] = useState('');
    const [language, setLanguage] = useState('');
    
    const [actoresArray, setActoresArray] = useState([]);
    const [directorArray, setDirectorArray] = useState([]);
    const [writersArray, setWritersArray] = useState([]);
    const [genresArray, setGenresArray] = useState([]);
    const [musiciansArray, setMusiciansArray] = useState([]);
    const [lastUpdate] = useState(selectedItem?.LastUpdateDate);

    /// General stateas
    //const [isSearchable, setIsSearchable] = useState(true);
    const [saveMode, setSaveMode] = useState((selectedItem?.MovieID===0) ? saveModeEn.INSERT : saveModeEn.UPDATE);
    const [firstSubTasks, setFirstSubTasks] = useState(selectedItem?.SubTasks || []);
    const [selectedObject, setSelectedObject] = useState(selectedItem);
    const [showSubTasksScreen, setShowSubTasksScreen] = useState(false);
    const [showLookupScreen, setShowLookupScreen] = useState(false);
    const [lookupTitle, setLookupTitle] = useState(false);
    const [lookupTableName, setLookupTableName] = useState(false);
    const [lookupData, setLookupData] = useState(false);


    


     /// Handle Sub Tasks
    var keepSubs = [];
    const updateSons = (noteID, newSons) => 
                       {
                          if (saveMode === saveModeEn.UPDATE)
                          {
                            dataMovies = dataMovies.map((note) => (note.MovieID === noteID ? {...note, SubTasks: newSons } : note))
                            const item = dataMovies.find((c) => c.MovieID === noteID);
                            setSelectedObject(item);
                          }
                          else
                          {
                            const item = { ...selectedObject, SubTasks: newSons };
                            setSelectedObject(item);
                          }
                       };
    //console.log(subjectsArray);

// Add field 'SubTasks' to Object
    if (selectedObject['SubTasks'] === undefined)
    {
      setSelectedObject(  {...selectedObject, SubTasks: []} );
    }


    // const ColourOption = [
    //   { value: 'rgba(28, 14, 185, 0.47)', label: 'blue' },
    //   { value: '#564586', label: 'Purple' },
    //   { value: '#888769', label: 'blue' },
    //   { value: '#987654', label: 'black' }
    // ]

    const colourStyles = {
      control: (styles) => ({ ...styles, backgroundColor: 'rgb(254, 254, 255)', height: '26px', width: '500px', color: 'blue', fontSize: '20px', textAlign: 'right', direction: 'rtl' }),
      option: (styles, { data, isDisabled, isFocused, isSelected }) => {
        //const color = '#c1b1d1';    // '#263375'
        return {
          ...styles, /* backgroundColor: 'red', */ fontSize: '21px', height: '30px',
         
          /// BackColor of List
          // backgroundColor: isDisabled
          //                     ? undefined
          //                     : isSelected
          //                       ? data.color
          //                       : isFocused
          //                         ? color    // Items in list backColor on Active
          //                         : undefined,
       /*    color: isDisabled                 // Items in list ForeColor 
                    ? '#ccc'
                    : isSelected
                      ? isFocused        //chroma.contrast(color, 'white') > 2
                        ? '#ccc'
                        : 'black'
                    : data.color,    // Items in  /*list ForColor*/
                    
          cursor: isDisabled ? 'not-allowed' : 'default',
          
          // Mouse Down colors
          ':active': {
            ...styles[':active'],
                  color: '#fff',                         /// Mouse Down ForeColor      
                  backgroundColor: !isDisabled
                                      ? isSelected
                                        ? '#fff'
                                        : '#3958b778'   /// Mouse Down BackColor
                                      : undefined,
          },
        };
      },
      multiValue: (styles, { data }) => {
        const color = 'rgb(224, 222, 214)';
        return {
          ...styles,
          backgroundColor: color,
          color: 'blue'
          /* width: '100px' */
        };
      },
      multiValueLabel: (styles, { data }) => ({
        ...styles,
        color: '#f56996',   /// Selected items in row ForeColor
      }),
      multiValueRemove: (styles, { data }) => ({
        ...styles,
        color: '#9888',
        ':hover': {
          backgroundColor: '#3c6c31',
          color: 'white',
        },
      }),
    };

   
    if (f_update_mode)
    {
      f_update_mode = false;
      setGenresArray(null); // Clears the component state
      setActoresArray(null);
      setDirectorArray(null);
      setWritersArray(null);
      setMusiciansArray(null);

      setTitle(selectedItem?.Title);
      setDesc(selectedItem?.Description);
      setFilmTypeID(selectedItem?.FilmTypeID);
      setRated(selectedItem?.Rated);
      setCountry(selectedItem?.Country);
      setYear(selectedItem?.Year);
      setLanguage(selectedItem?.Language);
      setSelfLink(selectedItem?.SelfLink);
      setEditor(selectedItem?.Editor);

      var arrayItems = Globals.seperatedStringToLookupObject(selectedItem.Genre, dataGenres);
      setGenresArray(arrayItems);
      var result = Globals.lookupObjectToSeperatedString(arrayItems);
      setGenre(result);
      
      arrayItems = Globals.seperatedStringToLookupObject(selectedItem.Actors, dataActores);
      setActoresArray(arrayItems);
      result = Globals.lookupObjectToSeperatedString(arrayItems);
      setActores(result);
      
      arrayItems = Globals.seperatedStringToLookupObject(selectedItem.Director, dataDirector);
      setDirectorArray(arrayItems);
      result = Globals.lookupObjectToSeperatedString(arrayItems);
      setDirector(result);
      
      arrayItems = Globals.seperatedStringToLookupObject(selectedItem.Writer, dataWriters);
      setWritersArray(arrayItems);
      result = Globals.lookupObjectToSeperatedString(arrayItems);
      setWriter(result);
      
      arrayItems = Globals.seperatedStringToLookupObject(selectedItem.Music, dataMusicians);
      setMusiciansArray(arrayItems);
      result = Globals.lookupObjectToSeperatedString(arrayItems);
      setMusic(result);
    

      setSaveMode((selectedItem?.MovieID===0) ? saveModeEn.INSERT : saveModeEn.UPDATE);
      setFirstSubTasks(selectedItem?.SubTasks || []);
      setSelectedObject( selectedItem );
      // if ( selectedItem['SubTasks'] !== undefined && selectedItem.SubTasks.length > 0)
      // {
      //     setShowSubTasksScreen(true);
      // }
    }



    async function handleSubmit(e)
    {
      e.preventDefault();
      //return <ShowMessageBox2 title="האם אתה בטוח?" defaultValue="" withTextbox={false} />;
      // if ( aaa === 'yes')
      // {
        await saveObject(e);
      //}
      
    }

    async function handleDelete(e)
    {
      //e.preventDefault();
      /* if (Globals.ShoeMessageBox(false) === 'yes')
      { */
      setSaveMode(saveModeEn.DELETE);

      await saveObject(saveModeEn.DELETE);
      //}
    }

    function handleChange(e, mode)
    {
      switch (mode)
      {
        case 1:
        {
          setGenresArray(e);
          /// Transfer from combo objects to seperated string
          const result = Globals.lookupObjectToSeperatedString(e);
          setGenre(result);
          break;
        }

        case 2:
        {
          setDirectorArray(e);
          /// Transfer from combo objects to seperated string
          const result = Globals.lookupObjectToSeperatedString(e);
          setDirector(result);
          break;
        }
          
        case 3:
        {
          setActoresArray(e);
          /// Transfer from combo objects to seperated string
          const result = Globals.lookupObjectToSeperatedString(e);
          setActores(result);
          break;
        }
            
        case 4:
        {
          setWritersArray(e);
          /// Transfer from combo objects to seperated string
          const result = Globals.lookupObjectToSeperatedString(e);
          setWriter(result);
          break;
        }
            
        case 5:
        {
          setMusiciansArray(e);
          /// Transfer from combo objects to seperated string
          const result = Globals.lookupObjectToSeperatedString(e);
          setMusic(result);
          break;
        }

        default:
          break;
              
      }
    }

    async function saveObject( modeSave )
    {
     var save = saveMode || saveModeEn.UPDATE;

      if (isNaN(modeSave) === false && modeSave !== null)
      {
        save = modeSave;
      }

      var message = '';
      var result = null;
      

      var values = selectedObject;

      
      // Remove field 'SubTasks' before Save action
      keepSubs = selectedObject.SubTasks;
      if (values['SubTasks'] !== undefined)
      {
        const { SubTasks, ...otherAnimals } = values;
        values = otherAnimals;
      }


      switch (save)
      {
        case saveModeEn.INSERT:
          values = await valuesToObject(values);

          values.FirebaseID='';
          const noteID = Number(dataBaseTable[0].NumeratorNotesID)+1;
          values['MovieID'] = noteID;
          selectedObject.MovieID = noteID;
          selectedItem.MovieID = noteID;
          
          result = await FirebaseHanle.InsertRecord("TBL_Movies", values);
          
          result = await FirebaseHanle.UpdateField('TBL_Databases', dataBaseTable[0].FirebaseID, {NumeratorNotesID: noteID});

          /// Save the Sub-Task
          result = await saveSubTasks();

          if (result)
          {
            dataBaseTable[0].NumeratorNotesID = noteID;
            const newArray = [...dataMovies];
            selectedObject.LastUpdateDate = values.LastUpdateDate;
            selectedObject.FirebaseID = values.FirebaseID;
            newArray.push({...selectedObject});
            dataMovies = newArray;
            const objUpdated = dataMovies.find((item) => item.MovieID === noteID);
            message = `הפריט נוסף בהצלחה! (${objUpdated.MovieID.toLocaleString()})`;
          }
          else
          {
            message = "שגיאה בהוספת הפריט!";
          } 

          setSaveMode(2);
          break;

        case saveModeEn.UPDATE:
          values = await valuesToObject(values);
          
          result = await FirebaseHanle.UpdateRecord("TBL_Movies", selectedItem.FirebaseID, values);
          
          /// Save the Sub-Task
          result = await saveSubTasks();

          if (result)
          {
            const index = dataMovies.findIndex(task => task.MovieID === selectedObject.MovieID);
            const newArray = [...dataMovies];
            selectedItem.LastUpdateDate = values.LastUpdateDate;
            newArray[index] = {...selectedObject}; 
            dataMovies = newArray;
            const objUpdated = dataMovies.find((item) => item.MovieID === selectedObject.MovieID);
            message = `עידכון הפריט עבר בהצלחה! (${objUpdated.MovieID.toLocaleString()})`;
          }
          else
          {
            message =  "שגיאה בעידכון הפריט!";
          } 
          break;

        case saveModeEn.DELETE:
          result = await FirebaseHanle.DeleteRecord("TBL_Movies", selectedObject.FirebaseID);

          result = await deleteSubTasks();

          if (result)
          {
            selectedItem.SubTasks = [];
            selectedObject.SubTasks = [];
            setSelectedObject(selectedObject);
             // Predicate function: removes the item matching the given ID
            const handleRemove = (idToRemove) => {
              return ([...dataMovies].filter(item => item.MovieID !== idToRemove));
            };
            dataMovies = handleRemove(selectedObject.MovieID);
            alert("הפריט נמחק בהצלחה!");
          }
          else
          {
            alert("שגיאה בפעולת המחיקה!");
          } 

          setSaveMode(2);
          break;

        default:
          break;
      }


      // Add back the field 'SubTaasks' to object (removed before save to 'TBL_Notes' table)
      if (selectedObject['SubTasks'] === undefined)
      {
        setSelectedObject( {...selectedObject, SubTasks: keepSubs} );
      }

      /// Refresh Note data table
      onSaveSubTasks(dataMovies);

      /// After Refresh records, Point to the Updated note
      if (saveMode === saveModeEn.INSERT || saveMode === saveModeEn.UPDATE)
      {
          onSelectedItem(values);
      }
      else{
          onSelectedItem(null);
      }

      if (message.trim() !== '')
      {
          alert(message);
      }


    }

    async function saveSubTasks() 
    {
      var result = true;
      var values = selectedObject;


      // Add back the field 'SubTaasks' to object
      if (values['SubTasks'] === undefined)
      {
        setSelectedObject( {...values, SubTasks: keepSubs} );
      }

      if (firstSubTasks.length === 0 && values.SubTasks.length===0)
      {
        return result;
      }

      if (firstSubTasks.length === values.SubTasks.length)
      {
        // Checks if at least one item is missing
        const isMissing1 = firstSubTasks.some((item) => !values.SubTasks.some((e) => e.Title === item.Title) || 
                                                        !values.SubTasks.some((e) => e.IsDone === item.IsDone && e.FirebaseID === item.FirebaseID));
        const isMissing2 = values.SubTasks.some((item) => !firstSubTasks.some((e) => e.Title === item.Title) || 
                                                          !firstSubTasks.some((e) => e.IsDone === item.IsDone && e.FirebaseID === item.FirebaseID))
        if (!isMissing1 && !isMissing2)
        {
          return result;
        }
      }

      /// Set All SubTasks with parent 'NoteID'
      values.SubTasks.map((item) => item.NoteID = selectedObject.MovieID);
      setSelectedObject(values);


      /// Delete Old records
      result = await deleteSubTasks();

      if (!result)
      {
        alert("שגיאה בעידכון תתי-המשימות!");
      }

      /// Save the New records
      for (let i = 0; i < values.SubTasks.length; i++)
      {
          const item = values.SubTasks[i];
          result = await FirebaseHanle.InsertRecord("TBL_NotesChilds", item);
      }

      if (!result)
      {
        alert("שגיאה בעידכון תתי-המשימות!");
      }


      return result;
    }

    async function deleteSubTasks() 
    {
      var result = true;
      
      /// Delete Old record
      const dataSubs = await FirebaseHanle.GetQuerySync("TBL_NotesChilds", "NoteID", selectedObject.MovieID);
      
      for (let i = 0; i < dataSubs.length; i++) 
      {
        const item = dataSubs[i];
        result = await FirebaseHanle.DeleteRecord("TBL_NotesChilds", item.FirebaseID);
      }

      if (!result)
      {
        alert("שגיאה במחיקת תתי-המשימות!");
      }


      return result;
    }

    function valuesToObject( values)
    {
      values['Title'] = String(title).trim();
      values['Description'] = String(desc).trim();
      values.FilmTypeID = filmTypeID;
      values.Rated = rated;
      values.Genre = genres;
      values.Actors = actores;
      values.Director = director;
      values.Country = country;
      values.Year = year;
      values.Language = language;
      values.Music = music;
      values.Editor = editor;
      values.Writer = writer;
      values.SelfLink = selfLink;
      values.LastUpdateDate = '';

      selectedObject['Title'] = String(title).trim();
      selectedObject['Description'] = String(desc).trim();
      selectedObject.FilmTypeID = filmTypeID;
      selectedObject.Rated = rated;
      selectedObject.Genre = genres;
      selectedObject.Actors = actores;
      selectedObject.Director = director;
      selectedObject.Country = country;
      selectedObject.Year = year;
      selectedObject.Language = language;
      selectedObject.Music = music;
      selectedObject.Editor = editor;
      selectedObject.Writer = writer;
      selectedObject.SelfLink = selfLink;
      selectedObject.LastUpdateDate = '';

      return values;
    }
  
    function handleShowSubTasksScreen()
    {
      setShowSubTasksScreen(!showSubTasksScreen);
    }

    function handleAddSubLine()
    {
      f_update_mode = 1;
      const noteChildbject = NoteChild();
      noteChildbject.Title = 'שורה חדשה';
      noteChildbject.IsDone = false;
      // const newLine =     //CreateSubNewline('שורה חדשה', false, null, subObjectsList.length, selectedItem);
      //         <CreateSubNewline 
      //                       key={subObjectsList.length}
      //                       itemObject={selectedItem}
      //                       defaultTitle={'שורה חדשה'} 
      //                       defaultIsDone={false} 
      //                       onDeleteLine={null} 
      //                       lineIndex={subObjectsList.length} />
      //setSubObjectsList([...subObjectsList, noteChildbject]);

      //return newLine
    };

    function handleAddLookupItem(title, tableName, data)
    {
      setLookupTitle(title);
      setLookupTableName(tableName);
      setLookupData(data);

      setShowLookupScreen(true);
    }

    



    return (

        <form className="form_note_screen" onSubmit={(e) => handleSubmit(e)}>
          
          <div className='div_items_fields'>
            
            <div className='div_items_fields1'>
              <input    id='txtTitle' name='txtTitle' value={title} placeholder='הקלד כותרת'  style={{fontSize: '23px', fontWeight: 'Bold'}} type='text'  onChange={(e) => setTitle(e.target.value)}/>
              <textarea id='txtDesc'  name='txtDesc'  value={desc}  placeholder='הקלד הערות'  style={{fontSize: '24px', height: '100%'}} onChange={(e) => setDesc(e.target.value)}> </textarea>
            </div>


            <div className='div_items_fields2'>

              <div style={{display: 'flex', flexDirection: 'row', gap: '16px', justifyContent: 'space-evenly'}}>
                <button type='button' style={{backgroundColor: 'rgb(45, 31, 172)', color: 'white', height: '30px'}} onClick={(e) => handleShowSubTasksScreen()}>תת-משימות</button>
                <button type='button' style={{backgroundColor: 'rgb(45, 31, 172)', color: 'white', height: '30px'}} onClick={(e) => handleAddSubLine()}>תמונות</button>
              </div>

              <div style={{display: 'flex', flexDirection: 'row', rowGap: '6px', justifyContent: 'space-between'}}>
                <Globals.FieldInScreen  captionText="סוג פריט"  fieldID="txt_filmTypeID" 
                  control={<Globals.FillCombox id="txt_filmTypeID"  data={dataFilmTypes} defaultValue={filmTypeID} style={{width: '250px', fontSize: 19}} onChangeFunc={setFilmTypeID}/>}
                />

                <Globals.FieldInScreen  captionText="דירוג"  fieldID="txt_statusID"
                  control={<input name='txtRated' value={rated} placeholder='הקלד דירוג' type='number'  onChange={(e) => setRated(e.target.value)}/>}
                />
              </div>

              {/* Multi Select Combos */}
              <div style={{display: 'flex', flexDirection: 'row', gap: '0px', justifyContent: 'right'}}>
                <Globals.FieldInScreen  captionText="ג׳נר"  fieldID="txt_statusID" width={100} control={
                  <Select 
                    name="genres"
                    value={genresArray}
                    options={dataGenres} 
                    defaultValue={genresArray}
                    isMulti 
                    closeMenuOnSelect={false} 
                    //styles={colourStyles}
                    onChange={(e) => handleChange(e, 1)}
                    isRtl={true}
                    // className="basic-single"
                    // classNamePrefix="select"
                    // isDisabled={isDisabled}
                    // isLoading={isLoading}
                    isClearable={true}
                    //isSearchable={isSearchable}
                  />}
                />
                <button type='button'  style={{width: '11px', height: '10px', alignSelf: 'AlignLeft'}} onClick={(e) => handleAddLookupItem('ג׳אנרים', 'TBL_Genres', dataGenres)}>+</button>
              </div>

              <div style={{display: 'flex', flexDirection: 'row', gap: '16px', justifyContent: 'right'}}>
                <Globals.FieldInScreen  captionText="שחקנים"  fieldID="txt_statusID" width={100} control={
                    <Select 
                      name="actor"
                      value={actoresArray}
                      options={dataActores} 
                      defaultValue={actoresArray}
                      isMulti 
                      closeMenuOnSelect={false} 
                      //styles={colourStyles}
                      onChange={(e) => handleChange(e, 3)}
                      // className="basic-single"
                      // classNamePrefix="select"
                      // isDisabled={isDisabled}
                      // isLoading={isLoading}
                      isClearable={true}
                      isRtl={true}
                      //isSearchable={isSearchable}
                    />}
                />
                <button type='button'  style={{width: '11px', height: '10px', alignSelf: 'AlignLeft'}} onClick={(e) => handleAddLookupItem('שחקנים', 'TBL_Actors', dataActores)}>+</button>
              </div>

              <div style={{display: 'flex', flexDirection: 'row', gap: '16px', justifyContent: 'right'}}>
                <Globals.FieldInScreen  captionText="במאים"  fieldID="txt_statusID" width={100} 
                  control={
                    <Select 
                      name="director"
                      value={directorArray}
                      options={dataDirector} 
                      defaultValue={directorArray}
                      isMulti 
                      closeMenuOnSelect={false} 
                      //styles={colourStyles}
                      onChange={(e) => handleChange(e, 2)}
                      // className="basic-single"
                      // classNamePrefix="select"
                      // isDisabled={isDisabled}
                      // isLoading={isLoading}
                      isClearable={true}
                      isRtl={true}
                      //isSearchable={isSearchable}
                    />
                  }
                />
                <button type='button'  style={{width: '11px', height: '10px', alignSelf: 'AlignLeft'}} onClick={(e) => handleAddLookupItem('במאים', 'TBL_Directors', dataDirector)}>+</button>
              </div>
              
              <div style={{display: 'flex', flexDirection: 'row', gap: '16px', justifyContent: 'right'}}>      
                <Globals.FieldInScreen  captionText="כותבים"  fieldID="txt_statusID" width={100} control={
                    <Select 
                      name="writers"
                      value={writersArray}
                      options={dataWriters} 
                      defaultValue={writersArray}
                      isMulti 
                      closeMenuOnSelect={false} 
                      //styles={colourStyles}
                      onChange={(e) => handleChange(e, 4)}
                      // className="basic-single"
                      // classNamePrefix="select"
                      // isDisabled={isDisabled}
                      // isLoading={isLoading}
                      isClearable={true}
                      isRtl={true}
                      //isSearchable={isSearchable}
                    />}
                />
                <button type='button'  style={{width: '11px', height: '10px', alignSelf: 'AlignLeft'}} onClick={(e) => handleAddLookupItem('כותבים', 'TBL_Writers', dataWriters)}>+</button>
              </div>

              <div style={{display: 'flex', flexDirection: 'row', gap: '16px', justifyContent: 'right'}}>   
                <Globals.FieldInScreen  captionText="מוזיקה"  fieldID="txt_statusID" width={100} control={
                    <Select 
                      name="music"
                      value={musiciansArray}
                      options={dataMusicians} 
                      defaultValue={musiciansArray}
                      isMulti 
                      closeMenuOnSelect={false} 
                      styles={colourStyles}
                      onChange={(e) => handleChange(e, 5)}
                      // className="basic-single"
                      // classNamePrefix="select"
                      // isDisabled={isDisabled}
                      // isLoading={isLoading}
                      isClearable={true}
                      isRtl={true}
                      //isSearchable={isSearchable}
                    />}
                />
                <button type='button'  style={{width: '11px', height: '10px', alignSelf: 'AlignLeft'}} onClick={(e) => handleAddLookupItem('מוזיקאים', 'TBL_Musicians', dataMusicians)}>+</button>  
              </div>


              <div style={{display: 'flex', flexDirection: 'row', rowGap: '6px', justifyContent: 'space-between'}}>
                <Globals.FieldInScreen  captionText="מדינה"  fieldID="txtCountry" control={
                  <input name='txtCountry' value={country} placeholder='הקלד מדינה' type='text'  onChange={(e) => setCountry(e.target.value)}/>}
                />
                <Globals.FieldInScreen  captionText="שפה"  fieldID="txtLanguage" control={
                  <input name='txtLanguage' value={language} placeholder='הקלד שפה' type='text'  onChange={(e) => setLanguage(e.target.value)}/>}
                />
              </div>

              <div style={{display: 'flex', flexDirection: 'row', rowGap: '6px', justifyContent: 'space-between'}}>
                <Globals.FieldInScreen  captionText="שנה"  fieldID="txtYear" control={
                  <input name='txtYear'  value={year}   placeholder='הקלד שנה' type='text'  onChange={(e) => setYear(e.target.value)}/>}
                />
                <Globals.FieldInScreen  captionText="עורכים"  fieldID="txtEditor" control={
                  <input name='txtEditor' value={editor} placeholder='הקלד עורך' type='text'  onChange={(e) => setEditor(e.target.value)}/>}
                />
              </div>

              <Globals.FieldInScreen  captionText="לינק מרכזי"  fieldID="txtSelfLink" control={
                <input name='txtSelfLink' value={selfLink} placeholder='הקלד לינק' type='text'  onChange={(e) => setSelfLink(e.target.value)}/>}
              />


            </div>

          </div>


          <div className='div_buttons_row'>
            <div>
              <button type='button' style={{backgroundColor: 'red', color: 'white'}} onClick={(e) => handleDelete(e)}>מחיקה</button>
              <label style={{color: '#B4B7BC', fontSize: '16px', paddingTop: '0px', paddingRight: '20px'}}>נערך לאחרונה: {lastUpdate}</label>
            </div>
            <button type='button' className='button_save' onClick={saveObject}>שמירה</button>
          </div>
    

          {showSubTasksScreen   /* || (selectedObject && selectedObject.SubTasks && selectedObject.SubTasks.length > 0) */  &&
                  <SonsPanel  noteObject={selectedObject} onClose={() => setShowSubTasksScreen(false)} onUpdateSubTasks={updateSons}/>
                    // <ShowSubLines  itemObject={selectedItem} subTaskList=§{subObjectsList} /*onDeleteSubTask={onDeleteSubTask}*//>
          }


          {showLookupScreen &&
                  <Globals.LookupManage title={lookupTitle} tableName={lookupTableName} originalData={lookupData} onClose={(e) => setShowLookupScreen(false)} onSaveLookup={onSaveLookup} />
          }


        </form>
        
    );
}

/// ---- Detail panel (the "Sons" form) -----------------------------------
function SonsPanel({ noteObject, onClose, onUpdateSubTasks }) 
{
  const subTasks = noteObject.SubTasks;


  const addRow = () => 
  {
    const id = newRowId();
    onUpdateSubTasks(noteObject.MovieID, [...subTasks, { id: id,  FirebaseID: id, NoteID: noteObject.NoteID, IsDone: false, Title: "" }]);
    handleScrollToControl();
  };

  const deleteRow = (rowId) => {
    onUpdateSubTasks(noteObject.MovieID, subTasks.filter((subTask) => subTask.FirebaseID !== rowId));
  };

  const toggleChecked = (rowId) => {
    onUpdateSubTasks(noteObject.MovieID, subTasks.map((subTask) => (subTask.id === rowId ? { ...subTask, IsDone: !subTask.IsDone } : subTask)));
  };

  const updateText = (rowId, value) => {
    onUpdateSubTasks(noteObject.MovieID, subTasks.map((subTask) => (subTask.id === rowId ? { ...subTask, Title: value } : subTask)))
  };

  const targetControlRef = useRef(null);
    const handleScrollToControl = () => 
    {
      if (targetControlRef && targetControlRef.current)
      {
        // Smoothly scroll the container to make the target control visible
        targetControlRef.current?.scrollIntoView({
          behavior: 'smooth', 
          block: 'nearest', // Aligns element within the scrollable area
        });
        // Scroll manuali
          // Moves the inner scrollbar down by 100 pixels
          //targetControlRef.current.scrollTop = 30;
          //targetControlRef.current.scrollTop = targetControlRef.current.scrollHeight;
        }
    };


  return (

    <div
      style={{
        position: "fixed",
        inset: 0,
        zIndex: 50,
        display: "flex",
        justifyContent: "flex-end",
        fontFamily: "'sans-serif, Segoe UI', -apple-system, BlinkMacSystemFont",
        left: 10
      }}
    >

      {/* overlay */}
      <div
        onClick={onClose}
        style={{
          position: "absolute",
          inset: 0,
          background: "rgba(20, 28, 46, 0.45)",
        }}
      />

      {/* drawer */}
      <div
        style={{
          position: "relative",
          width: "min(480px, 92vw)",
          height: "100%",
          background: "#e5e1d8",
          boxShadow: "-12px 0 32px rgba(20,28,46,0.18)",
          display: "flex",
          flexDirection: "column",
          animation: "slideIn 0.22s ease-out",
        }}
      >
        <style>{`
          @keyframes slideIn {
            from { transform: translateX(24px); opacity: 0.6; }
            to { transform: translateX(0); opacity: 1; }
          }
        `}</style>

        {/* header */}
        <div
          style={{
            padding: "22px 24px",
            borderBottom: "1px solid #E4E0D8",
            display: "flex",
            flexDirection: 'column',
            alignItems: "start",
            //justifyContent: "space-between",
            background: "#1B2A4A",
          }}
        >
    
          <div style={{display: 'flex', flexDirection: 'row', width: '100%', /* gap: '60px', */ justifyContent: 'space-between'/* , alignItems: 'space-between' */}}>
            <div
              style={{
                fontSize: 20,
                letterSpacing: "0.08em",
                textTransform: "uppercase",
                color: "#C9A15A",
                fontWeight: 700,
                marginBottom: 4,
                //display: 'flex',
                //flexDirection: 'row',
                //alignItems: 'center',
                //justifyContent: 'flex-end'
              }}
            >
              תתי-משימות
            </div>

            {/* <div style={{ fontSize: 19, fontWeight: 700, color: "#FBFAF8" }}>
              {noteObject.Title}
            </div> */}

            <button
              onClick={onClose}
              type='button'
              style={{
                background: "rgba(255,255,255,0.1)",
                border: "none",
                borderRadius: 8,
                width: 29,
                height: 29,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                cursor: "pointer",
                color: "#FBFAF8",
              }}
              aria-label="סגור"
            >
              X
              {/* <X size={18} /> */}
            </button>
          </div>

          <br/>

          <div
            style={{
              display: "flex",
              justifyContent: "start",
              alignItems: "center",
              marginBottom: 14,
            }}
            >
              <span style={{fontSize: 15, color: "#FBFAF8", fontWeight: 600, letterSpacing: "0.03em"}}>
                {subTasks.length} {"פריטים"}
              </span>
          </div>

        </div>



        {/* Main Rows Div */}
        <div style={{ flex: 1, overflowY: "auto", padding: "18px 24px" }}>
          
          {/* Sub Headers */}
          {subTasks.length === 0 && (
            <div
              style={{
                textAlign: "center",
                padding: "36px 12px",
                color: "#9CA3AF",
                fontSize: 14,
                border: "1.5px dashed #E4E0D8",
                borderRadius: 10,
              }}
            >
              אין תתי-משימות. לחץ על ׳הוסף׳
            </div>
          )}



          {/* Field Rowד entry */}
          <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
            {subTasks.map((item, index) => (
              <div
                key={item.FirebaseID}
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 10,
                  background: "#fff",
                  border: "1px solid #E4E0D8",
                  borderRadius: 10,
                  padding: "10px 12px",
                }}
              >
                <input
                  type="checkbox"
                  checked={item.IsDone}
                  onChange={() => toggleChecked(item.id)}
                  style={{
                    width: 18,
                    height: 18,
                    accentColor: "#1B2A4A",
                    cursor: "pointer",
                    flexShrink: 0,
                  }}
                />

                <input
                  type="text"
                  value={item.Title}
                  onChange={(e) => updateText(item.id, e.target.value)}
                  placeholder="הקלד טקסט..."
                  style={{
                    flex: 1,
                    border: "1px solid transparent",
                    background: "#F7F5F1",
                    borderRadius: 6,
                    padding: "7px 10px",
                    fontSize: 23,
                    color: "#1F2937",
                    outline: "none",
                  }}
                  ref={(index===subTasks.length-1) ? targetControlRef : null}
                  onFocus={(e) => (e.target.style.borderColor = "#1B2A4A")}
                  onBlur={(e) => (e.target.style.borderColor = "transparent")}
                />

                <button
                  onClick={() => deleteRow(item.FirebaseID)}
                  type='button'
                  style={{
                    border: "none",
                    background: "transparent",
                    cursor: "pointer",
                    color: "#B0473F",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    padding: 6,
                    borderRadius: 6,
                    flexShrink: 0,
                    boxShadow: '0px 0px 0px transparent'
                  }}
                  aria-label="מחק שורה"
                  title="מחק שורה"
                >
                  <Trash2 size={17} />
                </button>
              </div>
            ))}
          </div>

        </div>

        {/* footer */}
        <div style={{ padding: "16px 24px", borderTop: "1px solid #E4E0D8" }}>
          <button
            onClick={addRow}
            type='button'
            style={{
              width: "100%",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              gap: 8,
              background: "#1B2A4A",
              color: "#FBFAF8",
              border: "none",
              borderRadius: 9,
              padding: "11px 0",
              fontSize: 14,
              fontWeight: 600,
              cursor: "pointer",
            }}
          >
            <Plus size={17} />
            הוסף שורה
          </button>
        </div>
      </div>
    </div>
  );
}


function Movie()
{
  
  var movie =
      {
        MovieID: 0,
        Title: "",
        Description: "",
        Director: "",
        Actors:'',
        Writer: "",
        Editor: "",
        Year: '',
        Country: "",
        Language: "",
        Music: "",
        Rated: '',
        Genre: "",
        StatusID: 1,
        CardBackColor: '',
        CreateUserID: 0,
        LastUpdateDate: "",
        FirebaseID:'',
        SelfLink:'',
        IsFavorite: false,
        IsSelect: false,
        ListIndex: 0,
        ImagesLinks: [],
        Images: [],
        SubTasks: [],
        FilmTypeID: 1,
      };

  return movie;
}

function NoteChild()
{
  var noteChild =
  {
      NoteID: 0,
      Title: '',
      IsDone: false,
      FirebaseID: ''
  };

  return noteChild;
}

// function ShowMessageBox2({title, defaultValue, withTextbox}) 
// {
//   const [isOpen, setIsOpen] = useState(false);
//   const [inputValue, setInputValue] = useState(defaultValue);
//   const [answer, setAnswer] = useState(null);
//   const dialogRef = useRef(null);
//   //const isOpen = true;


//   if (f_update_mode)
//   {
//       f_update_mode = false;
//       // Focus the dialog seamlessly when it opens
//       setTimeout(() => dialogRef.current?.showModal(), 0);
//   }

//   // const openPrompt = () => {
//   //     setIsOpen(true);
//   //     // Focus the dialog seamlessly when it opens
//   //     setTimeout(() => dialogRef.current?.showModal(), 0);
//   // };

//   const handleClose = (action) => {
//       setIsOpen(false);
//       dialogRef.current?.close();

//       if (action === 'yes') 
//       {
//          setAnswer(inputValue);
//       } 
//       else 
//       {
//          setInputValue('no'); 
//       }
//       return action;
//   };

//   return (

//     <div >
//       {/* <button onClick={openPrompt}>Open Prompt</button> */}

//       {isOpen && (
//         <dialog ref={dialogRef} style={{ width: '400px', height: '200px', padding: '20px', borderRadius: '20px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
//           <h3>{title}</h3>
          
//           { withTextbox && <input 
//                               type="text" 
//                               value={""} 
//                               style={{backgroundColor: '#aba1ab', color: 'white'}}
//                               onChange={(e) => setInputValue(e.target.value) } 
//                               />
//           }

//           <div style={{ marginTop: '15px', display: 'flex', flexDirection: 'row', gap: '20px' }}>
//             <button style={{height: '30px', fontSize: '16px', paddingTop: '26px'}} onClick={() => handleClose('no')}>ביטול</button>
//             <button style={{height: '30px', fontSize: '16px', paddingTop: '26px'}} onClick={() => handleClose('yes')}>אישור</button>
//           </div>
//         </dialog>
//       )}

//       {/* {answer && <p>You entered: {answer}</p>} */}
//     </div>

//   );
// }



// function ShowInput()
// {
//   const [username, setUsername] = useState('');
//   const [error, setError] = useState('');



//   // const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
//   //   const value = e.target.value;
//   //   setUsername(value);

//   //   // Dynamic simple validation
//   //   if (value.length < 3) {
//   //     setError('Username must be at least 3 characters long.');
//   //   } else {
//   //     setError('');
//   //   }
//   // };


//   return (
//     <div style={{ maxWidth: '400px', margin: '50px auto', padding: '20px' }}>
//       <h2>Sign Up Form</h2>
      
//       <InputBox
//         id="username"
//         label="Username"
//         type="text"
//         placeholder="Enter your username"
//         value={username}
//         onChange= {null}      //{handleChange}
//         error={error}
//       />

//       <p>Current State Value: <strong>{username}</strong></p>
//     </div>
//   );
// }
