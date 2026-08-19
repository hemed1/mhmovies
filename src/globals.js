
//import { exp } from 'firebase/firestore/pipelines';
import React from 'react';
import { useState, useRef, useEffect } from 'react';
import {DeleteAllRecords, InsertRecord} from './components/firebase.js';
import { Plus, Trash2/* , X, ChevronRight, Users, Subtitles, CheckLine, Check, CheckIcon, CheckLineIcon, EllipsisVertical */ } from "lucide-react";



export function dateSetFormat(date)
{
   var result = new Date(date)

   // console.log(result.toLocaleString());
   // console.log(result.toDateString());
   
   //var result = date.toLocaleDateString('en-US', { weekday: 'long' }); 
   //var result = date.toLocaleString().substring(0, 16).replace(', ', ' ')/* .replace(".", "-",) */;

   var res = String(result.getFullYear()) + '-' + String(result.getMonth() + 1).padStart(2, '0') + '-' + result.getDate();
   res += ' ' + String(result.getHours()) + ':' + String(result.getMinutes());


   return res;
}

export function InputBox(
                  { 
                     label, 
                     type = 'text', 
                     value, 
                     onChange, 
                     placeholder, 
                     error, 
                     ...props 
                  })

{
      return (
         <div style={{ display: 'flex', flexDirection: 'column', marginBottom: '1rem', gap: '0.5rem' }}>
            {label && <label style={{ fontWeight: '600', fontSize: '14px' }}>{label}</label>}
            
            <input
               type={type}
               value={value}
               onChange={onChange}
               placeholder={placeholder}
               style={{
                  padding: '10px',
                  borderRadius: '4px',
                  border: error ? '1px solid red' : '1px solid #ccc',
                  fontSize: '16px',
                  outline: 'none'
               }}
               {...props}
            />
            
            {error && <span style={{ color: 'red', fontSize: '12px' }}>{error}</span>}
         </div>
      );
};

export function FieldInScreen({ captionText, fieldID, control, width })
{

  return (
      
      <div style={{display: 'flex', flexDirection: 'column', rowGap: '6px', width: `${(width) ? `${width}%`: null}`}}>
        <label htmlFor={fieldID}>{captionText}</label>
        {control}
      </div>
  );
}

export function FillCombox({data, defaultValue, style, onChangeFunc})
{
  //const [currentValue, setCurrentValue] = useState(defaultValue);
  
  
  function handleChange(e)
  {
    onChangeFunc(Number(e.target.value));
    //setCurrentValue(e.target.value);
  }


  return (
    <select value={defaultValue} onChange={(e) => handleChange(e)} style={style}>
    {
        data.map((e) => (
                          <option value={e.value} key={e.value}>                       
                              {e.label}
                          </option>
                        ))
    }
    </select> 
  );

}

export async function ShowMessageBox(title, defaultValue, withTextbox) 
{
//   const [isOpen, setIsOpen] = useState(false);
//   const [inputValue, setInputValue] = useState(defaultValue);
//   const [answer, setAnswer] = useState(null);
   const dialogRef = useRef(null);
   const isOpen = true;

  // const openPrompt = () => {
  //     //setIsOpen(true);
  //     // Focus the dialog seamlessly when it opens
  //     setTimeout(() => dialogRef.current?.showModal(), 0);
  // };

  const handleClose = (action) => {
      //setIsOpen(false);
      dialogRef.current?.close();

      if (action === 'yes') 
      {
         //setAnswer(inputValue);
      } 
      else 
      {
         //setInputValue('no'); 
      }
      return action;
  };

  return (

    <div >
      {/* <button onClick={openPrompt}>Open Prompt</button> */}

      {isOpen && (
        <dialog ref={dialogRef} style={{ width: '200px', height: '80px', padding: '20px', borderRadius: '20px', display: 'flex', flexDirection: 'column', gap: '10px' }}>
          <h3>{title}</h3>
          
          { withTextbox && <input 
                              type="text" 
                              value={""} 
                              style={{backgroundColor: '#aba1ab', color: 'white'}}
                              /* onChange={(e) => setInputValue(e.target.value) }*/ 
                              />
          }

          <div style={{ marginTop: '15px', display: 'flex', flexDirection: 'row', gap: '20px' }}>
            <button style={{height: '30px', fontSize: '16px', paddingTop: '26px'}} onClick={() => handleClose('no')}>ביטול</button>
            <button style={{height: '30px', fontSize: '16px', paddingTop: '26px'}} onClick={() => handleClose('yes')}>אישור</button>
          </div>
        </dialog>
      )}

      {/* {answer && <p>You entered: {answer}</p>} */}
    </div>

  );
}

//// Transfer from Seperate string, to Lookup Array
export function seperatedStringToLookupObject(fieldValue, lookupValues)
{
  var elements = [];
  
  if (String(fieldValue).trim() === '')
  {
    return elements;
  }

  const strList = String(fieldValue).split(', ')
  for (let i = 0; i < strList.length; i++) 
  {
    const foundList = [...lookupValues].filter((item) => String(item.label) === String(strList[i]));
    if (foundList.length>0)
    {
      //elements = ([foundList[0], ...elements]);
      elements.push(foundList[0]);
    }
  }


  return elements;
}

/// Transfer From combo objects to seperated string
export function lookupObjectToSeperatedString(lookupObject)
{
    const strList = lookupObject.map((item) =>  String(item.label) );
    const result = strList.join(", ");

    return result;
}

export function GridEdited(id, rowIndex, colIndex, value, itemObject, fieldName) 
{
   var edit = {id: id, row: rowIndex, col: colIndex, value: value, itemObject: itemObject, fieldName: fieldName};
   return edit;
}

export function LookupManage({ title, tableName, originalData, onClose, onSaveLookup }) 
{
  const [data, setData] = useState(originalData);
  const [lblMessage, setLblMessage] = useState(`${data.length} פריטים`);




  const addRow = () => 
  {
    // Finf the max ID + 1
    const tmpList = data.map((e) => e.value);
    const max = Math.max(...tmpList); 
    const newItem = {label: '', value: max + 1};
    const list = [...data];
    list.push(newItem);
    setData(list);
    handleScrollToControl();
    //handleFocus();
  };

  const deleteRow = (id) => {
    const newList = [...data].filter((item, index) => index !== id);
    setData(newList);
  };

  const setID = (oldIndex, newID) => {
    const newList = [...data].map((item, index) => (index === oldIndex ? { ...item, value: newID } : item));
    setData(newList);
  };

  const updateText = (oldIndex, value) => {
    const newList = [...data].map((item, index) => (index === oldIndex ? {...item, label: value } : item));
    setData(newList);
  };

  async function handleSaveLookup()
  {
    await saveLookups();

    onSaveLookup(tableName, data); 
    onClose();
  }

  async function saveLookups()
  {
    var result = false;

    setLblMessage('אנא המתן לשמירת נתונים ...');

    result = await DeleteAllRecords(tableName);

    for (const item of data) 
    {
      const obj = {ID: item.value , Description: String(item.label).trim()};
      result = await InsertRecord(tableName, obj);
    }

    setLblMessage(`${data.length} פריטים`);

    if (result)
    {
      alert("הפריטים נשמרו בהצלחה!");
    }
    else
    {
      alert("שגיאה בשמירת הנתונים!");
    } 
    
  }

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
  // const inputRef = useRef(null);
  // const handleFocus = () => 
  // {
  //   // 3. Access the DOM node and trigger focus
  //   if (inputRef.current) 
  //   {
  //     inputRef.current.focus();
  //   };
  // };
  // useEffect(() => 
  // {
  //   // Triggers automatically once the component mounts
  //   if (inputRef.current) 
  //   {
  //     inputRef.current.focus();
  //   }
  // }, []); // Empty dependency array ensures this runs only once

  //const containerRef = useRef(null);






  return (

    <div
      style={{
        position: "absolute",
        left: '200px',
        inset: 0,
        zIndex: 50,
        display: "flex",
        justifyContent: "flex-end",
        fontFamily: "'sans-serif, Segoe UI', -apple-system, BlinkMacSystemFont",
      }}
    >

      {/* overlay */}
      <div
        style={{
          position: 'absolute',
          left: '300px',
          top: '250px',
          inset: 0,
          background: "rgba(20, 28, 46, 0.45)",
        }}
      />

      {/* drawer */}
      <div
        style={{
          position: 'fixed',
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
            padding: "23px 20px",
            borderBottom: "1px solid #E4E0D8",
            display: "flex",
            flexDirection: 'column',
            alignItems: "start",
            justifyContent: "space-between",
            background: "#1B2A4A",
          }}
        >
    
          <div style={{display: 'flex', flexDirection: 'row', /* gap: '60px', */ justifyContent: 'space-between', width: '100%', fontWeight: 700, marginBottom: '30px', color: "#C9A15A"}}>
            
              {title}

              <div style={{display: 'flex', flexDirection: 'row', gap: '20px', justifyContent: 'left'}}>
                <button
                  onClick={onClose}
                  type='button'
                  style={{
                    background: "rgba(223, 16, 16, 1.0)",
                    //border: "1px solid #E4E0D8",
                    borderRadius: '5px',
                    width: '60px',
                    height: '30px',
                    display: "flex",
                    fontSize: '18px',
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    color: "#FBFAF8",
                  }}
                  aria-label="בטל"
                >
                  ביטול
                  {/* <X size={18} /> */}
                </button>

                <button
                  onClick={handleSaveLookup}
                  type='button'
                  style={{
                    background: "#1ea70c",
                    //border: "1px solid #E4E0D8",
                    borderRadius: '5px',
                    width: '60px',
                    height: '30px',
                    display: "flex",
                    fontSize: '18px',
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer",
                    color: "#FBFAF8",
                  }}
                  aria-label="אישור"
                >
                  אישור
                  {/* <X size={18} /> */}
                </button>
              </div>

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
              <span style={{fontSize: '18px', color: "#FBFAF8", fontWeight: 600, letterSpacing: "0.03em"}}>
                {lblMessage}
              </span>
          </div>
        </div>



        {/* Main Rows Div */}
        <div style={{ flex: 1, overflowY: "auto", padding: "18px 18px" }}>
          
          {/* Sub Headers */}
          {data.length === 0 && (
            <div
              style={{
                textAlign: "center",
                padding: "36px 12px",
                color: "#676b73",
                fontSize: '20px',
                border: "1.5px dashed #E4E0D8",
                borderRadius: 10,
              }}
            >
              אין {title}. לחץ על ׳הוסף שורה׳
            </div>
          )}



          {/* Field Rowד entry */}
          <div /* ref={targetControlRef} */ style={{ display: "flex", flexDirection: "column", gap: '8px' }}>
            {data.map((item, index) => (
              <div
                key={index}
                style={{
                  display: "flex",
                  flexDirection: "row",
                  gap: '20px',
                  alignItems: "center",
                  background: "#fff",
                  border: "1px solid #E4E0D8",
                  borderRadius: 8,
                  padding: "10px 12px",
                }}
              >

                <input
                  type="text"
                  value={item.value}
                  onChange={(e) => setID(Number(index), Number(e.target.value))}
                  style={{
                    border: "1px solid 'blue'",
                    width: '40px',
                    height: '40px',
                    borderRadius: 6,
                    fontSize: '23px',
                    background: "#F7F5F1",
                    color: "#1F2937",
                    flexShrink: 0,
                  }}
                />

                <input
                  type="text"
                  value={item.label}
                  onChange={(e) => updateText(index, e.target.value)}
                  placeholder="הקלד טקסט..."
                  style={{
                    border: "1px solid 'blue'",
                    borderRadius: 6,
                    padding: "7px 10px",
                    fontSize: '23px',
                    background: "#F7F5F1",
                    color: "#1F2937",
                    outline: "none",
                    width: '100%',
                  }}
                  ref={(index===data.length-1) ? targetControlRef : null}
                  onFocus={(e) => (e.target.style.borderColor = "#1B2A4A")}
                  onBlur={(e) => (e.target.style.borderColor = "transparent")}
                />

                <button
                  onClick={() => deleteRow(index)}
                  type='button'
                  style={{
                    border: "none",
                    background: "transparent",
                    cursor: "pointer",
                    color: "#B0473F",
                    display: "flex",
                    //alignItems: "left",
                    justifyContent: "left",
                    padding: 6,
                    borderRadius: 6,
                    flexShrink: 0,
                    boxShadow: '0px 0px 0px transparent'
                  }}
                  aria-label="מחק שורה"
                  title="מחק שורה">
                  <Trash2 size={17} />
                </button>
              </div>
            ))}
          </div>

        </div>


        {/* footer */}
        <div style={{ padding: "16px 24px", borderTop: "1px solid #E4E0D8" }}>
          <button
            onClick={(e) => addRow()}
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
