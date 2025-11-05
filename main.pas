PROGRAM main;

  USES
    CRT,SYSUTILS,VPUTILS;

  TYPE
    loginrecord=RECORD
                  password:STRING;
                END;
    loginfiletype= FILE of loginrecord;

    patientrecord=RECORD
                nhsid:STRING[4];
                forename:STRING;
                surname:STRING;
                dob:TDATETIME;
                emergencycontact:STRING[11];
                address:STRING;
                email:STRING;
                  END;
    patientfiletype= FILE of patientrecord;

    illnessrecord=RECORD
                    illnessid:STRING[4];
                    illnessname:STRING;
                    illnessdescription:STRING;
                  END;
    illnessfiletype=FILE of illnessrecord;

    medicationrecord=RECORD
                      medicationid:STRING[4];
                      medicationame:STRING;
                      medicationdescription:STRING;
                     END;
    medicationfiletype= FILE of medicationrecord;

    patientmedicationrecord=RECORD
                              nhsid:STRING[4];
                              medicationid:STRING[4];
                              medicationdosage:STRING;
                            END;
    patientmedicationfiletype= FILE of patientmedicationrecord;

    medicationillnessrecord=RECORD
                              medicationid:STRING[4];
                              illnessid:STRING[4];
                            END;
    medicationillnessfiletype= FILE of medicationillnessrecord;

    timetablerecord=RECORD
                      date:TDATETIME;
                      meetingtype:CHAR;
                      starttime:TDATETIME;
                      endtime:TDATETIME;
                    END;
    timetablefiletype= FILE of timetablerecord;

    employeerecord=RECORD
                      empid:STRING[4];
                      forename:STRING;
                      surname:STRING;
                   END;
    employeefiletype= FILE of employeerecord;

    timetableemployeerecord=RECORD
                        date:TDATETIME;
                        starttime:TDATETIME;
                        empid:STRING[4];
                      END;
    timetableemployeefiletype=FILE of timetableemployeerecord;

    timetablepatientrecord=RECORD
                            date:TDATETIME;
                            starttime:TDATETIME;
                            nhsid:STRING[4];
                          END;
    timetablepatientfiletype=FILE of timetablepatientrecord;

    patientillnessrecord=RECORD
                          nhsid:STRING[4];
                          illnessid:STRING[4];
                        END;
    patientillnessfiletype=FILE of patientillnessrecord;

  VAR
    login:loginrecord;
    loginfile:loginfiletype;
    patient:patientrecord;
    patientfile:patientfiletype;
    illness:illnessrecord;
    illnessfile:illnessfiletype;
    medication:medicationrecord;
    medicationfile:medicationfiletype;
    medicationillness:medicationillnessrecord;
    medicationillnessfile:medicationillnessfiletype;
    timetable,foundappointment:timetablerecord;
    timetablefile:timetablefiletype;
    employee:employeerecord;
    employeefile:employeefiletype;
    timetableemployee:timetableemployeerecord;
    timetableemployeefile:timetableemployeefiletype;
    timetablepatient:timetablepatientrecord;
    timetablepatientfile:timetablepatientfiletype;
    patientillness:patientillnessrecord;
    patientillnessfile:patientillnessfiletype;
    patientmedication:patientmedicationrecord;
    patientmedicationfile:patientmedicationfiletype;

  FUNCTION PickDrive:CHAR;
    VAR // function that validates drive input
      drive,drivechar:CHAR;
      drives:DRIVESET;
    BEGIN
      GETVALIDDRIVES(drives);
      WRITELN('Valid Drives: ');
      FOR drive:='A' TO 'Z' DO
        IF drive IN drives THEN
          WRITELN(drive,': '); // displays all valid drives
      WRITELN;
      REPEAT
        WRITELN('Please enter a drive: ');
        drivechar:=UPCASE(READKEY);
        WRITELN(drivechar);
        IF NOT(drivechar IN drives) THEN // if the input is not a valid drive then an error message is displayed
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN('Please enter a valid drive.');
            WRITELN;
            TEXTCOLOR(white);
          END;
      UNTIL drivechar IN drives; // repeats until a valid drive is inputted
      PickDrive:=drivechar;
    END;

  PROCEDURE InitialiseFiles;

    VAR // opens all files
      directory:STRING;
    BEGIN
      directory:=PickDrive+':\COMPUTER SCIENCE\coursework\';

      ASSIGN(loginfile,directory+'login.dta');
      RESET(loginfile);

      ASSIGN(patientfile,directory+'patient.dta');
      RESET(patientfile);

      ASSIGN(illnessfile,directory+'illness.dta');
      RESET(illnessfile);

      ASSIGN(medicationfile,directory+ 'medication.dta');
      RESET(medicationfile);

      ASSIGN(patientmedicationfile,directory+ 'patientmedicationresolver.dta');
      RESET(patientmedicationfile);

      ASSIGN(medicationillnessfile,directory+'medicationillnessresolver.dta');
      RESET(medicationillnessfile);

      ASSIGN(timetablefile,directory+'timetable.dta');
      RESET(timetablefile);

      ASSIGN(employeefile,directory+'employee.dta');
      RESET(employeefile);

      ASSIGN(timetableemployeefile,directory+'timetableemployee.dta');
      RESET(timetableemployeefile);

      ASSIGN(timetablepatientfile,directory+'timetablepatientresolver.dta');
      RESET(timetablepatientfile);

      ASSIGN(patientillnessfile,directory+'patientillnessresolver.dta');
      RESET(patientillnessfile);
    END;

  FUNCTION CheckDate(bookingdate:TDATETIME):BOOLEAN;
    VAR // checks for if an appointment is to be booked before the current date
      currentdate:TDATETIME;
    BEGIN
      currentdate:=Date;
      IF currentdate>bookingdate THEN // if the appointment is booked before the current date then an error message is to be displayed
        BEGIN
          CheckDate:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('You cannot book an appointment before the current date');
          TEXTCOLOR(white);
        END
      ELSE
        CheckDate:=TRUE;
    END;

  FUNCTION TestDate(datestr:STRING):BOOLEAN;
    VAR // function that tests to see if the user has inputted a valid date
      valdate:TDATETIME;
    BEGIN
      TRY
        valdate:=STRTODATE(datestr);
        TestDate:=TRUE; // true if the user has inputted a valid date
      EXCEPT
        ON E:ECONVERTERROR DO
          BEGIN
            TestDate:=FALSE; // false if the user has not inputted a valid date and provides error message
            TEXTCOLOR(lightred);
            WRITELN('Please enter a date in the valid format');
            WRITELN('For example: 21/08/2017'); // gives an example to prevent further invalid inputs
            TEXTCOLOR(white);
          END;
      END;
    END;

  FUNCTION TestPassword(currentpassword:STRING):BOOLEAN;
    VAR // tests if the current password and login password are the same when changing passwords
      keyentered:CHAR;
    BEGIN
      RESET(loginfile);
      READ(loginfile,login);
      IF login.password<>currentpassword THEN
        BEGIN
          TestPassword:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('Incorrect password entered. Please re-enter the current password.');
          TEXTCOLOR(white);
          WRITELN('Press any key to exit.');
          keyentered:=READKEY;
          CLRSCR;
        END
      ELSE
        TestPassword:=TRUE;
    END;

  FUNCTION TestPassword2(newpassword,newpassword2:STRING):BOOLEAN;
    VAR // tests if the newpasswords are the same
      keyentered:CHAR;
    BEGIN
      IF newpassword<>newpassword2 THEN
        BEGIN
          TestPassword2:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('New passwords do not match. Please re-enter the new passwords.');
          TEXTCOLOR(white);
          WRITELN('Press any key to exit.');
          keyentered:=READKEY;
          CLRSCR;
        END
      ELSE
        TestPassword2:=TRUE;
    END;

  FUNCTION TestPasswordDiff(currentpassword,newpassword:STRING):BOOLEAN;
    VAR // tests if the current password and the newpassword are the same
      keyentered:CHAR;
    BEGIN
      IF newpassword=currentpassword THEN
        BEGIN
          TestPasswordDiff:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('The new password you have entered has not changed. Please re-enter a different password.');
          TEXTCOLOR(white);
          WRITELN('Press any key to exit.');
          keyentered:=READKEY;
          CLRSCR;
        END
      ELSE
        TestPasswordDiff:=TRUE;
    END;

  FUNCTION TestTime(timestr:STRING):BOOLEAN;
    VAR // function that tests to see if the user has inputted a valid time
      valtime:TDATETIME;
    BEGIN
      TRY
        valtime:=STRTOTIME(timestr);
        TestTime:=TRUE; // true if the user has inputted a valid time
      EXCEPT
        ON E:ECONVERTERROR DO
          BEGIN
            TestTime:=FALSE; // false if the user has not inputted a valid time and provides error message
            TEXTCOLOR(lightred);
            WRITELN('Please enter a time in the valid format');
            WRITELN('For example: 13:00'); // gives an example to prevent further invalid inputs
            TEXTCOLOR(white);
          END;
      END;
    END;

  FUNCTION CheckMinTimes(starttime,endtime:TDATETIME):BOOLEAN;
    VAR // function that checks to see if the user has not inputted an appointment time an hour or greater
      timediffminutes,minminutes:LONGINT;
    BEGIN
      minminutes:=60;
      timediffminutes:=ROUND((endtime-starttime)*1440); // multiplying by 1440 as 1440 is the minutes in a day, then converts to nearest integer
      IF timediffminutes<minminutes THEN // if the time difference is less than 60 (an hour) then the function returns false
        BEGIN
          CheckMinTimes:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('The minimum time for an appointment must be an hour.');
          TEXTCOLOR(white);
        END
      ELSE
        CheckMinTimes:=TRUE; // otherwise the function returns true
    END;

  FUNCTION CheckTimes(starttime,endtime:TDATETIME):BOOLEAN;
    BEGIN // function that checks to see if the start time is greater than the end time
      IF starttime>endtime THEN // if the start
        BEGIN
          CheckTimes:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('The start time of the appointment must not be greater than the end time of the appointment.');
          TEXTCOLOR(white);
        END
      ELSE
        CheckTimes:=TRUE;
    END;

  FUNCTION TestPresence(nhsid:STRING):BOOLEAN;
    BEGIN // tests to see if the string is empty
      IF LENGTH(nhsid) = 0 THEN // tests to see if the the user has inputted a value into nhsid
        BEGIN
          TestPresence:=FALSE; // returns false if the string is empty
          TEXTCOLOR(lightred);
          WRITELN('You have not entered a valid input.');
          WRITELN('Please re-enter.');
          TEXTCOLOR(white);
        END
      ELSE
        TestPresence:=TRUE;
    END;

  FUNCTION TestIfLengthValid(emergencycontact:STRING):BOOLEAN;
    BEGIN // tests to see if the emergency contact is 11 digits
      IF (LENGTH(emergencycontact) <> 11) THEN // if the emergency contact isn't 11 digits then the function returns false
        BEGIN
          TestIfLengthValid:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('Emergency contact entered is not 11 digits. Invalid');
          TEXTCOLOR(white);
        END
      ELSE
        TestIfLengthValid:=TRUE;
    END;

  FUNCTION TestifContactValid(emergencycontact:STRING):BOOLEAN;
    BEGIN // tests to see if the emergency contact starts with '07', if it does not then it is not a valid contact
      IF (COPY(emergencycontact,1,2)<>'07')  THEN // takes a substring of the first 2 characters in the emergency contact and compares it to 07
        BEGIN
          TestifContactValid:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('That is not a United Kingdom personal contact number');
          WRITELN('Please re-enter the emergency contact');
          TEXTCOLOR(white);
        END
      ELSE
        TestifContactValid:=TRUE;
    END;

  FUNCTION TestPrimaryKey(nhsid:STRING):BOOLEAN;
    VAR // checks if the following characters after 'N' are integers, if not returns an error message
      times,endtimes,inc:LONGINT;
      valid:BOOLEAN;
    BEGIN
      inc:=2; // the subscipt of a string where the following after should be integers (starting from 1)
      endtimes:=3;
      valid:=TRUE;
      FOR times:=1 TO endtimes DO
        BEGIN
          IF (ORD(nhsid[inc])<48) OR (ORD(nhsid[inc])>57) THEN // if the ord(nhsid[inc])<48 AND ord(nhsid[inc]>57) then they are not integers
            BEGIN
              valid:=FALSE;
            END;
            inc:=inc+1;
        END;
      IF NOT valid THEN // as they are not integers, and error message is dislpayed
        BEGIN
          TEXTCOLOR(lightred);
          WRITELN('After the first character, there should only be numbers.');
          TEXTCOLOR(white);
        END;
      TestPrimaryKey := valid; // assigned valid as valid determines whether or not the characters are integers
    END;

  FUNCTION TestFirstChar(nhsid:STRING):BOOLEAN;
    BEGIN // tests if the first character of nhsid is 'N'. if it is not an error message is returned
      IF (COPY(nhsid,1,1)='N') OR (COPY(nhsid,1,1)='n') THEN
        TestFirstChar:=TRUE
      ELSE
        BEGIN
          TestFirstChar:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('The first character should be an ''N''');
          TEXTCOLOR(white);
        END;
    END;

  FUNCTION StartWorkingHrs(VAR starttime:TDATETIME):BOOLEAN;
    VAR
      starthr,lasthr:TDATETIME;
    BEGIN
      starthr:=STRTOTIME('08:00'); // start time of my client's shift
      lasthr:=STRTOTIME('16:00'); // latest time to book an appointment as it will take an hour
      IF starttime<starthr THEN // if the new start time is before 08:00 an error message is displayed
        BEGIN
          StartWorkingHrs:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('This is before your shift starts. Invalid start time.');
          TEXTCOLOR(white);
        END;
      IF starttime>lasthr THEN // if the new start time is after 16:00 an error message is displayed
        BEGIN
          StartWorkingHrs:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('You will not have enough time to finish this appointment. Invalid start time.');
          TEXTCOLOR(white);
        END;
      IF (starttime>=starthr) AND (starttime<=lasthr) THEN
        StartWorkingHrs:=TRUE;
    END;

  FUNCTION EndWorkingHrs(VAR endtime:TDATETIME):BOOLEAN;
    VAR
      endhr:TDATETIME;
    BEGIN
      endhr:=STRTOTIME('17:00'); // end time of my client's shift
      IF endtime>endhr THEN // if the new endtime time is after 16:00 an error message is displayed
        BEGIN
          EndWorkingHrs:=FALSE;
          TEXTCOLOR(lightred);
          WRITELN('This is after your shift ends. Invalid start time.');
          TEXTCOLOR(white);
        END;
      IF (endtime<=endhr) THEN
        EndWorkingHrs:=TRUE;
    END;

  FUNCTION HasAt(email:STRING):BOOLEAN;
    VAR // function that tests if the sting has an '@'
      i:LONGINT;
      foundat:BOOLEAN;
    BEGIN
      foundat:=FALSE;
      FOR i:=1 TO LENGTH(email) DO // loops through and tests if any substring has an '@'
        BEGIN
          IF email[i]='@'THEN
            foundat:=TRUE;
        END;
      HasAt:=foundat;
      IF NOT foundat THEN
        BEGIN
          TEXTCOLOR(lightred);
          WRITELN('You cannot have an email without an ''@''.');
          WRITELN('Please re-enter email');
          TEXTCOLOR(white);
        END;
    END;

  PROCEDURE DisplayPatients;
    BEGIN // displays all patients and the illness/illnesses associated with the patient using the patientillnessfile
      RESET(patientfile);
      WHILE NOT EOF(patientfile) DO
        BEGIN
          READ(patientfile,patient);
          WITH patient DO
            BEGIN
              TEXTCOLOR(lightgreen);
              WRITELN(nhsid);
              WRITELN(forename);
              WRITELN(surname);
              WRITELN(DATETOSTR(dob));
              WRITELN(emergencycontact);
              WRITELN(address);
              WRITELN(email);
              TEXTCOLOR(white);
              RESET(patientillnessfile);
              WHILE NOT EOF(patientillnessfile) DO  // loops to the end of the file
                BEGIN
                  READ(patientillnessfile,patientillness);
                  IF patientillness.nhsid=patient.nhsid THEN  // tests to see if the patientillness.nhsid is the same as patient.nhsid
                    BEGIN
                      RESET(illnessfile); // opens the illnessfile if condition has been met
                      WHILE NOT EOF(illnessfile) DO
                        BEGIN
                          READ(illnessfile,illness);
                          IF illness.illnessid=patientillness.illnessid THEN
                            BEGIN
                              WRITELN('Illness/es: ');
                              TEXTCOLOR(lightblue);
                              WRITELN(illness.illnessname);
                              TEXTCOLOR(white)
                            END;
                        END;
                    END;
                END;
              RESET(patientmedicationfile);
              WRITELN('Medication/s: ');
              WHILE NOT EOF(patientmedicationfile) DO
                BEGIN
                  READ(patientmedicationfile,patientmedication);
                  IF patientmedication.nhsid=patient.nhsid THEN
                    BEGIN
                      RESET(medicationfile);
                      WHILE NOT EOF(medicationfile) DO
                        BEGIN
                          READ(medicationfile,medication);
                          IF medication.medicationid=patientmedication.medicationid THEN
                            BEGIN
                              TEXTCOLOR(yellow);
                              WRITELN(medication.medicationame);
                              WRITELN(patientmedication.medicationdosage);
                              TEXTCOLOR(white);
                            END;
                        END;
                    END;
                END;
              WRITELN;
            END;
        END;
    END;

  PROCEDURE DisplayIllnesses;
    BEGIN // displays all illnesses and medication associated with the illness using the medicationillnessfile
      RESET(illnessfile);
      WHILE NOT EOF(illnessfile) DO
        BEGIN
          READ(illnessfile,illness);
          WITH illness DO
            BEGIN
              TEXTCOLOR(lightgreen);
              WRITELN(illnessid);
              WRITELN(illnessname);
              WRITELN(illnessdescription);
              TEXTCOLOR(white);
              WRITELN('This illness is treated by: ');
              RESET(medicationillnessfile);
              WHILE NOT EOF(medicationillnessfile) DO
                BEGIN
                  READ(medicationillnessfile,medicationillness);
                  IF medicationillness.illnessid=illness.illnessid THEN
                    BEGIN
                      RESET(medicationfile);
                      WHILE NOT EOF(medicationfile) DO
                        BEGIN
                          READ(medicationfile,medication);
                          IF medication.medicationid=medicationillness.medicationid THEN
                            BEGIN
                              TEXTCOLOR(lightblue);
                              WRITELN(medication.medicationame,': ',medication.medicationdescription);
                              TEXTCOLOR(white);
                            END;
                        END;
                    END;
                END;
              WRITELN;
            END;
        END;
    END;

  PROCEDURE DisplayEmployees;
    BEGIN // displays all employees
      RESET(employeefile);
      WHILE NOT EOF(employeefile) DO
        BEGIN
          READ(employeefile,employee);
          WITH employee DO
            BEGIN
              TEXTCOLOR(lightgreen);
              WRITELN(empid);
              WRITELN(forename,' ',surname);
              TEXTCOLOR(white);
              WRITELN;
            END;
        END;
    END;

  PROCEDURE DisplayPatIll;
    BEGIN // displays all patientillness records
      RESET(patientillnessfile);
      WHILE NOT EOF(patientillnessfile) DO
        BEGIN
          READ(patientillnessfile,patientillness);
          WITH patientillness DO
            BEGIN
              WRITELN(illnessid);
              WRITELN(nhsid);
              WRITELN;
            END;
        END;
    END;

  PROCEDURE DisplayMedications;
    BEGIN // displays all medication records
      RESET(medicationfile);
      WHILE NOT EOF(medicationfile) DO
        BEGIN
          READ(medicationfile,medication);
          WITH medication DO
            BEGIN
              TEXTCOLOR(lightgreen);
              WRITELN(medicationid);
              WRITELN(medicationame);
              WRITELN(medicationdescription);
              TEXTCOLOR(white);
              WRITELN;
            END;
        END;
    END;

  PROCEDURE displaymedres;
    BEGIN // displays all patientmedication records
      RESET(patientmedicationfile);
      WHILE NOT EOF(patientmedicationfile) DO
        BEGIN
          READ(patientmedicationfile,patientmedication);
          WITH patientmedication DO
            BEGIN
              WRITELN(medicationid);
              WRITELN(nhsid);
              WRITELN;
            END;
        END;
    END;

  PROCEDURE DisplayTimetable;
    BEGIN // displays all timetable records and displays the patient associated with the appointment using the timetablepatientfile
      RESET(timetablefile);
      READ(timetablefile,timetable);
      WHILE NOT EOF(timetablefile) DO
        BEGIN
          READ(timetablefile,timetable);
          WITH timetable DO
            BEGIN
              IF meetingtype='P' THEN
                BEGIN
                  TEXTCOLOR(lightgreen);
                  WRITELN(DATETOSTR(date));
                  WRITELN(meetingtype);
                  WRITELN(TIMETOSTR(starttime));
                  WRITELN(TIMETOSTR(endtime));
                  TEXTCOLOR(white);
                  RESET(timetablepatientfile);
                  WHILE NOT EOF(timetablepatientfile) DO
                    BEGIN
                      READ(timetablepatientfile,timetablepatient);
                      IF (timetablepatient.date+timetablepatient.starttime) = (timetable.date+timetable.starttime) THEN
                        BEGIN
                          RESET(patientfile);
                          REPEAT
                            READ(patientfile,patient);
                          UNTIL (patient.nhsid=timetablepatient.nhsid);
                          TEXTCOLOR(lightblue);
                          WRITELN(patient.forename,' ',patient.surname);
                          TEXTCOLOR(white);
                        END;
                    END;
                END;
              IF meetingtype='C' THEN
                BEGIN
                  TEXTCOLOR(lightgreen);
                  WRITELN(DATETOSTR(date));
                  WRITELN(meetingtype);
                  WRITELN(TIMETOSTR(starttime));
                  WRITELN(TIMETOSTR(endtime));
                  TEXTCOLOR(white);
                  RESET(timetableemployeefile);
                  WHILE NOT EOF(timetableemployeefile) DO
                    BEGIN
                      READ(timetableemployeefile,timetableemployee);
                      IF (timetableemployee.date+timetableemployee.starttime) = (timetable.date+timetable.starttime) THEN
                        BEGIN
                          RESET(employeefile);
                          REPEAT
                            READ(employeefile,employee);
                          UNTIL (employee.empid=timetableemployee.empid);
                          TEXTCOLOR(lightblue);
                          WRITELN(employee.forename,' ',employee.surname);
                          TEXTCOLOR(white);
                        END;
                    END;
                END;
            WRITELN;
            END;
        END;
    END;

  PROCEDURE DisplayTimetablePatient;
    VAR
      count:LONGINT;
    BEGIN // displays all timetable patient records
      count:=0;
      RESET(timetablepatientfile);
      WHILE NOT EOF(timetablepatientfile) DO
        BEGIN
          READ(timetablepatientfile,timetablepatient);
          WITH timetablepatient DO
            BEGIN
              count:=count+1;
              WRITELN(count);
              WRITELN(timetablepatient.nhsid);
              WRITELN(DATETOSTR(timetablepatient.date));
              WRITELN(TIMETOSTR(timetablepatient.starttime));
              WRITELN;
            END;
        END;
    END;

  PROCEDURE FindPatient;
    VAR // this procedure performs a real time search, providing records and updating them with every character inputted
      searched,patname:STRING;
      inp,exitkey:CHAR;
      value:LONGINT;
      found:BOOLEAN;
    PROCEDURE SearchPatient;
      BEGIN
        searched:=''; // an empty string prepared for the characters that the user inputs
        WRITELN('Enter the full name of the patient you would like to search for.');
        REPEAT
          inp:=READKEY;
          value:=ORD(inp); // turns the input into ASCII to deal with any backspaces or an enter
          IF (value<>13) AND (value<>8) THEN
            BEGIN
              searched:=searched+inp; // if the user does not press enter and does not press backspace, then it means they are still searching for the user in which the string is added onto itself and the new input
            END
          ELSE
            IF (value=8) AND (LENGTH(searched)>0) THEN // tests to see if the see if the user backspaces
              DELETE(searched,LENGTH(searched),1);
          CLRSCR;
          found:=FALSE;
          WRITELN('Enter the full name of the patient you would like to search for.');
          WRITELN(searched);
          RESET(patientfile);
          WHILE (NOT EOF(patientfile)) AND (NOT found) DO
            BEGIN
              patname:=''; // an empty string that allows me to compare the first character of each patient and compare to the first character of the inputted patient
              READ(patientfile,patient);
              patname:=patient.forename+' '+patient.surname;
              IF POS(UPPERCASE(searched),UPPERCASE(patname))=1 THEN
                BEGIN
                  WITH patient DO
                    BEGIN //displays all relevant patient information
                      WRITELN;
                      TEXTCOLOR(lightgreen);
                      WRITELN('NHSID: ',nhsid);
                      WRITELN('Patient Name: ',forename,' ',surname);
                      WRITELN('Date of Birth: ',DATETOSTR(patient.dob));
                      WRITELN('Emergency Contact: ',emergencycontact);
                      WRITELN('Address: ',address);
                      WRITELN('Email: ',email);
                      WRITELN;
                      TEXTCOLOR(white);
                      found:=TRUE;
                    END;
                END;
            END;
        UNTIL value = 13; // search ends once user presses enter
      END;
    PROCEDURE DisplayPatientData;
      BEGIN
        IF found THEN
          BEGIN
            CLRSCR;
            WITH patient DO
              BEGIN
                TEXTCOLOR(lightgreen);
                WRITELN;
                WRITELN('NHSID: ',nhsid);
                WRITELN('Patient Name: ',forename,' ',surname);
                WRITELN('Date of Birth: ',DATETOSTR(patient.dob));
                WRITELN('Emergency Contact: ',emergencycontact);
                WRITELN('Address: ',address);
                WRITELN('Email: ',email);
                WRITELN;
                TEXTCOLOR(white);
              END;
            WRITELN('Illness/es: ');
            RESET(patientillnessfile);
            WHILE NOT EOF(patientillnessfile) DO  // loops to the end of the file
              BEGIN
                READ(patientillnessfile,patientillness);
                IF patientillness.nhsid=patient.nhsid THEN  // tests to see if the patientillness.nhsid is the same as patient.nhsid
                  BEGIN
                    RESET(illnessfile); // opens the illnessfile if condition has been met
                    WHILE NOT EOF(illnessfile) DO
                      BEGIN
                        READ(illnessfile,illness);
                        IF illness.illnessid=patientillness.illnessid THEN
                          BEGIN
                            TEXTCOLOR(lightblue);
                            WRITELN(illness.illnessname);
                            TEXTCOLOR(white)
                          END;
                      END;
                  END;
              END;
            RESET(patientmedicationfile);
            WRITELN('Medication/s: ');
            WHILE NOT EOF(patientmedicationfile) DO
              BEGIN
                READ(patientmedicationfile,patientmedication);
                IF patientmedication.nhsid=patient.nhsid THEN
                  BEGIN
                    RESET(medicationfile);
                    WHILE NOT EOF(medicationfile) DO
                      BEGIN
                        READ(medicationfile,medication);
                        IF medication.medicationid=patientmedication.medicationid THEN
                          BEGIN
                            TEXTCOLOR(yellow);
                            WRITELN(medication.medicationame,' - ',patientmedication.medicationdosage);
                            TEXTCOLOR(white);
                          END;
                      END;
                  END;
              END;
            WRITELN('Press any key to exit.');
            exitkey:=READKEY;
            CLRSCR;
          END;
        IF NOT found THEN
          BEGIN // error message is displayed if the patient is not found
            TEXTCOLOR(lightred);
            WRITELN('Patient not found.');
            TEXTCOLOR(white);
          END;
      END;
    BEGIN
      REPEAT
        SearchPatient;
        DisplayPatientData;
      UNTIL found;
    END;

  PROCEDURE FindIllness;
    VAR // real time search that searches for an illness
      searched,illname:STRING;
      inp,exitkey:CHAR;
      value:LONGINT;
      found:BOOLEAN;
    PROCEDURE SearchIllness;
      BEGIN
        searched:=''; // starts off as an empty string which will be added to itself an inputs
        WRITE('Enter the full name of the illness: ');
        REPEAT
          inp:=READKEY;
          value:=ORD(inp);
          IF (value<>13) AND (value<>8) THEN // if the enter or backspace is not entered then inp is added to the empty string
            BEGIN
              searched:=searched+inp;
            END
          ELSE
            IF value=8 THEN // if a backspace is entered, deletes last character
              BEGIN
                IF LENGTH(searched)>0 THEN // if the string is not empty, as you cannot backspace an empty string
                  DELETE(searched,LENGTH(searched),1);
              END;
          CLRSCR;
          WRITELN('Enter the full name of the illness: ');
          WRITELN(searched);
          RESET(illnessfile);
          found:=FALSE;
          WHILE (NOT EOF(illnessfile)) AND (NOT found) DO
            BEGIN
              illname:=''; // starts off an empty string
              READ(illnessfile,illness);
              illname:=illness.illnessname; // assigned illness.illnessname as there will be comparisons between illness.illnessname and searched
              IF POS(UPPERCASE(searched),UPPERCASE(illname))=1 THEN
                BEGIN
                  WRITELN;
                  WITH illness DO
                    BEGIN // displays necessary illness information
                      TEXTCOLOR(lightgreen);
                      WRITELN('Illness ID: ',illnessid);
                      WRITELN('Illness Name: ',illnessname);
                      WRITELN('Illness Description: ',illnessdescription);
                      WRITELN;
                      TEXTCOLOR(white);
                      found:=TRUE;
                    END;
                END;
            END;
        UNTIL value=13; // repeats until enter key is pressed
      END;
    PROCEDURE DisplayIllnessData;
      BEGIN
        IF found THEN
          BEGIN
            CLRSCR;
            WITH illness DO
              BEGIN
                TEXTCOLOR(lightgreen);
                WRITELN('Illness ID: ',illness.illnessid);
                WRITELN('Illness Name: ',illness.illnessname,' - ',illness.illnessdescription);
                TEXTCOLOR(white);
              END;
            WRITELN('Medication/s: ');
            RESET(medicationillnessfile);
            WHILE NOT EOF(medicationillnessfile) DO
              BEGIN
                READ(medicationillnessfile,medicationillness);
                IF medicationillness.illnessid=illness.illnessid THEN
                  BEGIN
                    RESET(medicationfile);
                    WHILE NOT EOF(medicationfile) DO
                      BEGIN
                        READ(medicationfile,medication);
                        IF medication.medicationid=medicationillness.medicationid THEN
                          BEGIN
                            TEXTCOLOR(lightblue);
                            WRITELN(medication.medicationame,' - ',medication.medicationdescription);
                            TEXTCOLOR(white);
                          END;
                      END;
                  END;
              END;
            WRITELN('Press any key to exit.');
            exitkey:=READKEY;
            CLRSCR;
          END;
        IF NOT found THEN
          BEGIN // displays error message if illness not found
            TEXTCOLOR(lightred);
            WRITELN;
            WRITELN('Illness not found.');
            TEXTCOLOR(white);
          END;
      END;
    BEGIN
      REPEAT
        SearchIllness;
        DisplayIllnessData;
      UNTIL found;
    END;

  PROCEDURE FindMedication;
    VAR // real time search that searches for an illness
      searched,medname:STRING;
      inp,exitkey:CHAR;
      value:LONGINT;
      found:BOOLEAN;
    PROCEDURE SearchMedication;
      BEGIN
        searched:=''; // starts off as an empty string which will be added to itself an inputs
        WRITE('Enter the full name of the medication: ');
        REPEAT
          inp:=READKEY;
          value:=ORD(inp);
          IF (value<>13) AND (value<>8) THEN // if the enter or backspace is not entered then inp is added to the empty string
            BEGIN
              searched:=searched+inp;
            END
          ELSE
            IF value=8 THEN // if a backspace is entered, deletes last character
              BEGIN
                IF LENGTH(searched)>0 THEN // if the string is not empty, as you cannot backspace an empty string
                  DELETE(searched,LENGTH(searched),1);
              END;
          CLRSCR;
          WRITELN('Enter the full name of the medication: ');
          WRITELN(searched);
          RESET(medicationfile);
          found:=FALSE;
          WHILE (NOT EOF(medicationfile)) AND (NOT found) DO
            BEGIN
              medname:=''; // starts off an empty string
              READ(medicationfile,medication);
              medname:=medication.medicationame; // assigned medication.medicationname as there will be comparisons between medication.medicationname and searched
              IF POS(UPPERCASE(searched),UPPERCASE(medname))=1 THEN
                BEGIN
                  WRITELN;
                  WITH medication DO
                    BEGIN // displays necessary medication information
                      TEXTCOLOR(lightgreen);
                      WRITELN('Medication ID: ',medicationid);
                      WRITELN('Medication Name: ',medicationame);
                      WRITELN('Medication Description: ',medicationdescription);
                      WRITELN;
                      TEXTCOLOR(white);
                      found:=TRUE;
                    END;
                END;
            END;
        UNTIL value=13; // repeats until enter key is pressed
      END;

    PROCEDURE DisplayMedicationData;
      BEGIN
        IF found THEN
          BEGIN
            CLRSCR;
            WITH medication DO
              BEGIN
                TEXTCOLOR(lightgreen);
                WRITELN('Medication ID: ',medicationid);
                WRITELN('Medication Name: ',medicationame,' - ',medicationdescription);
                TEXTCOLOR(white);
              END;
            WRITELN('Illness/es: ');
            RESET(medicationillnessfile);
            WHILE NOT EOF(medicationillnessfile) DO
              BEGIN
                READ(medicationillnessfile,medicationillness);
                IF medicationillness.medicationid=medication.medicationid THEN
                  BEGIN
                    RESET(illnessfile);
                    WHILE NOT EOF(illnessfile) DO
                      BEGIN
                        READ(illnessfile,illness);
                        IF illness.illnessid=medicationillness.illnessid THEN
                          BEGIN
                            TEXTCOLOR(lightblue);
                            WRITELN(illness.illnessname,' - ',illness.illnessdescription);
                            TEXTCOLOR(white);
                          END;
                      END;
                  END;
              END;
            WRITELN('Press any key to exit.');
            exitkey:=READKEY;
            CLRSCR;
          END;
        IF NOT found THEN
          BEGIN // displays error message if medication not found
            TEXTCOLOR(lightred);
            WRITELN;
            WRITELN('Medication not found.');
            TEXTCOLOR(white);
          END;
      END;
    BEGIN
      REPEAT
        SearchMedication;
        DisplayMedicationData;
      UNTIL found;
    END;

  PROCEDURE PatientObtainData(VAR newpatient:patientrecord);
    VAR // obtains new patient information when adding a new patient to the patient record
      birthdate:STRING;
      uniquenhsid:BOOLEAN;
    BEGIN
      WITH newpatient DO
        BEGIN
          REPEAT
            REPEAT
              WRITE('Enter NHS id: ');
              READLN(nhsid);
              nhsid:=UPPERCASE(nhsid);
            UNTIL (TestPresence(nhsid)) AND (TestPrimaryKey(nhsid)) AND (TestFirstChar(nhsid)); // makes sure something is entered, if after 'N' there are numbers, and first char is
            RESET(patientfile);
            uniquenhsid:=TRUE; // Assume unique initially
            WHILE NOT EOF(patientfile) DO
              BEGIN
                READ(patientfile, patient);
                IF patient.nhsid=nhsid THEN // if the user inputs an nhsid that is already in my patient file then that is invalid as my user is adding a person that already exists
                  BEGIN
                    uniquenhsid:=FALSE; // set false if duplicate found
                  END;
              END;
            IF NOT uniquenhsid THEN
              BEGIN
                TEXTCOLOR(lightred);
                WRITELN('NHSID already in use. Please enter a new NHS ID.'); // if a duplicate is found an error message is displayed
                TEXTCOLOR(white);
              END;
          UNTIL (uniquenhsid); // repeats until nhsid is not already in my patientfile
          REPEAT
            WRITE('Enter forename: ');
            READLN(forename);
          UNTIL (TestPresence(forename)); // repeats until the user inputs something into the forename variable
          REPEAT
            WRITE('Enter surname: ');
            READLN(surname);
          UNTIL (TestPresence(surname)); // repeats until user inputs something into the surname variable
          REPEAT
            WRITE('Enter date of birth (d/m/y): ');
            READLN(birthdate);
          UNTIL (TestDate(birthdate));
          dob:=STRTODATE(birthdate);
          REPEAT
            WRITE('Enter emergency contact: ');
            READLN(emergencycontact);
          UNTIL (TestIfLengthValid(emergencycontact)) AND (TestifContactValid(emergencycontact)) AND (TestPresence(emergencycontact)); // repeats until user enters character with 11 digits and contact starts with 07
          REPEAT
            WRITE('Enter address: ');
            READLN(address);
          UNTIL (TestPresence(address));
          REPEAT
            WRITE('Enter email: ');
            READLN(email);
          UNTIL (TestPresence(email)) AND (HasAt(email));
        END;
    END;

  PROCEDURE AddMedicationPatient;
    VAR //adds a medication to a patient in the patientmedication resolver file
      medresponse,patforename,recdosage:STRING;
      existingmed:BOOLEAN;
    BEGIN
      REPEAT
        existingmed:=FALSE;
        FindPatient;
        FindMedication;
        patforename:=patient.forename;
        patforename:=LOWERCASE(patforename);
        patforename:=COPY(UPPERCASE(patforename),1,1)+COPY(LOWERCASE(patforename),2,LENGTH(patforename)-1);
        medresponse:=medication.medicationame;
        medresponse:=LOWERCASE(medresponse);
        medresponse:=COPY(UPPERCASE(medresponse),1,1)+COPY(LOWERCASE(medresponse),2,LENGTH(medresponse)-1);
        RESET(patientmedicationfile);
        WHILE NOT (EOF(patientmedicationfile)) AND (NOT existingmed) DO
          BEGIN
            READ(patientmedicationfile,patientmedication);
            IF (patientmedication.nhsid=patient.nhsid) AND (patientmedication.medicationid=medication.medicationid) THEN
              existingmed:=TRUE;
          END;
        IF existingmed THEN
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN(patforename,' has already has been prescribed ',medresponse,'.');
            TEXTCOLOR(white);
            RESET(patientfile);
          END
        ELSE // this loop goes through if the patient doees not have the medication prescribed to be removed
          BEGIN
            WRITELN('What is the dosage you would like to provide ',patforename,'?');
            READLN(recdosage);
            SEEK(patientmedicationfile,FILESIZE(patientmedicationfile)); // moves to end of file
            patientmedication.nhsid:=patient.nhsid; // the following lines assign patientmedication to the matching records to then add to the end of file
            patientmedication.medicationid:=medication.medicationid;
            patientmedication.medicationdosage:=recdosage;
            WRITE(patientmedicationfile,patientmedication);
            TEXTCOLOR(lightgreen);
            WRITELN(patforename,' has now been prescribed ',medresponse,'.'); // informs medication has been added
            TEXTCOLOR(white);
            RESET(patientfile);
          END;
      UNTIL (NOT existingmed);
    END;

  PROCEDURE UpdateMedication;
    VAR // updates a medication a patient has been prescribed to
      patforename:STRING;
      onmedication,medfound:BOOLEAN;
    BEGIN
      FindPatient; // searches and returns the patientid
      patforename:=patient.forename;
      patforename:=LOWERCASE(patforename);
      patforename:=COPY(UPPERCASE(patforename),1,1)+COPY(LOWERCASE(patforename),2,LENGTH(patforename)-1);
      REPEAT
        onmedication:=TRUE;
        FindMedication;
        medfound:=TRUE;
        RESET(patientmedicationfile);
        REPEAT
          READ(patientmedicationfile,patientmedication); // linear search on patientmedication to find a connection to medication file
        UNTIL (patient.nhsid=patientmedication.nhsid) AND (medication.medicationid=patientmedication.medicationid) OR (EOF(patientmedicationfile));
        IF (patient.nhsid<>patientmedication.nhsid) OR (medication.medicationid<>patientmedication.medicationid) THEN
          BEGIN // if there is no patient on this medication this loop goes through
            onmedication:=FALSE;
            TEXTCOLOR(lightred);
            WRITELN(patforename,' is not on this medication.');
            WRITELN('Please enter a valid medication.');
            TEXTCOLOR(white);
          END
        ELSE // else there is a patient on this medication in which this loop goes through
          BEGIN
            medfound:=TRUE;
            WRITELN('Please enter the new dosage: ');
            READLN(patientmedication.medicationdosage);
            SEEK(patientmedicationfile,FILEPOS(patientmedicationfile)-1); // file pointer goes back one to overwrite existing medication
            WRITE(patientmedicationfile,patientmedication);
            TEXTCOLOR(lightgreen);
            WRITELN('Dosage successfully updated.'); // informs of successful update
            TEXTCOLOR(white);
          END;
      UNTIL (onmedication);
    END;

  PROCEDURE AddIllnessPatient;
    VAR // adds a illness to a patient in the patientillness resolver file
      patforename,diagill:STRING;
      existingill:BOOLEAN;
      response:CHAR;
    PROCEDURE SearchNewIllness;
      BEGIN
        FindPatient;
        FindIllness;
        diagill:=illness.illnessname;
        existingill:=FALSE;
        CLRSCR;
        patforename:=patient.forename;
        patforename:=COPY(UPPERCASE(patforename),1,1)+COPY(LOWERCASE(patforename),2,LENGTH(patforename)-1);
        diagill:=COPY(UPPERCASE(diagill),1,1)+COPY(LOWERCASE(diagill),2,LENGTH(diagill)-1);
        RESET(patientillnessfile);
        WHILE NOT (EOF(patientillnessfile)) AND (NOT existingill) DO
          BEGIN
            READ(patientillnessfile,patientillness);
            IF (patientillness.nhsid=patient.nhsid) AND (patientillness.illnessid=illness.illnessid) THEN
              existingill:=TRUE;
          END;
        IF existingill THEN
          BEGIN
            CLRSCR;
            TEXTCOLOR(lightred);
            WRITELN(patforename,' has already has been diagnosed with ',diagill,'.');
            TEXTCOLOR(white);
          END;
      END;
    PROCEDURE AddNewIllness;
      BEGIN
        IF NOT existingill THEN
          BEGIN
            patientillness.nhsid:=patient.nhsid; // the following lines assign patientillness to the matching records to then add to the end of file
            patientillness.illnessid:=illness.illnessid;
            WRITE(patientillnessfile,patientillness);
            TEXTCOLOR(lightgreen);
            WRITELN(patforename,' has been successfully diagnosed ',diagill,'.'); // informs user illness has been added
            TEXTCOLOR(white);
            IF (COPY(patient.nhsid,3,3)='0') AND (COPY(patient.nhsid,2,2)='0') THEN
              BEGIN
                REPEAT
                  WRITELN('Would you like to prescribe ',patforename,' medication? (Y/N)');
                  response:=READKEY;
                  response:=UPCASE(response);
                  IF response='Y' THEN
                    BEGIN // if the input is 'Y' then addmedicationprocedure is called and adds to patientmedication file
                      RESET(patientfile);
                      AddMedicationPatient;
                    END
                  ELSE
                    IF response='N' THEN
                      CLRSCR
                  ELSE // goes through and gives error response if input is not 'Y' or 'N'
                    BEGIN
                      TEXTCOLOR(lightred);
                      WRITELN('You did not enter a valid response.');
                      WRITELN('Please re-enter response.');
                      TEXTCOLOR(white);
                    END;
                UNTIL (response='Y') or (response='N'); // repeats until user gives a clear answer
              END;
          END;
      END;
    BEGIN
      REPEAT
        SearchNewIllness;
        AddNewIllness;
      UNTIL (NOT existingill);
    END;

  PROCEDURE DeleteIllnessPatient;
    VAR // deletes a patient diagnosed with a specific illness from the patientillnessfile
      illresponse,patforename:STRING;
      existingill:BOOLEAN;
    BEGIN
      REPEAT
        FindPatient;
        FindIllness; // searches and returns the illnessid
        existingill:=FALSE;
        patforename:=patient.forename;
        patforename:=LOWERCASE(patforename);
        patforename:=COPY(UPPERCASE(patforename),1,1)+COPY(LOWERCASE(patforename),2,LENGTH(patforename)-1);
        RESET(patientillnessfile);
        REPEAT
          READ(patientillnessfile,patientillness); // linear search to check if illness is in resolver file to be deleted
          IF (patientillness.illnessid=illness.illnessid) AND (patientillness.nhsid=patient.nhsid) THEN
            existingill:=TRUE; // returns true if illness is assigned to patient
        UNTIL (existingill) OR (EOF(patientillnessfile)); // exits once existingill is found else there was no illness to be deleted
        IF existingill THEN
          BEGIN // if illness is assigned to patient deletion can take place
            WHILE FILEPOS(patientillnessfile)<>FILESIZE(patientillnessfile) DO
              BEGIN
                READ(patientillnessfile,patientillness);
                SEEK(patientillnessfile,FILEPOS(patientillnessfile)-2);
                WRITE(patientillnessfile,patientillness);
                SEEK(patientillnessfile,FILEPOS(patientillnessfile)+1);
              END;
            IF FILEPOS(patientillnessfile)=FILESIZE(patientillnessfile) THEN // if the file pointer is at the end after shuffling
              BEGIN
                SEEK(patientillnessfile,FILEPOS(patientillnessfile)-1);
                TRUNCATE(patientillnessfile);
              END
            ELSE
              TRUNCATE(patientillnessfile);
            TEXTCOLOR(lightgreen);
            WRITELN('Illness removed from patient.'); // informs user deletion was completed
            TEXTCOLOR(white);
          END;
        IF NOT existingill THEN
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN(patforename,' is not diagnosed with this illness, and can therefore not be removed from the patient.'); // informs otherwise
            TEXTCOLOR(white);
          END;
      UNTIL (existingill); // repeats until patient is found, an existing illness is true so that deletions can take place
    END;

  PROCEDURE DeletePatient;
    VAR // performs a cascading deletion on a patient
      patforename:STRING;
    PROCEDURE DeleteTimetables;
      BEGIN
        FindPatient;
        patforename:=patient.forename;
        patforename:=LOWERCASE(patforename);
        patforename:=COPY(UPPERCASE(patforename),1,1)+COPY(LOWERCASE(patforename),2,LENGTH(patforename)-1);
        RESET(timetablepatientfile);
        WHILE NOT EOF(timetablepatientfile) DO
          BEGIN
            READ(timetablepatientfile,timetablepatient);
            IF timetablepatient.nhsid=patient.nhsid THEN
              BEGIN // if a match is found then it successfully opens the timetable file to delete from there
                RESET(timetablefile);
                WHILE NOT EOF(timetablefile) DO
                  BEGIN
                    READ(timetablefile,timetable);
                    IF (timetable.date+timetable.starttime)=(timetablepatient.date+timetablepatient.starttime) THEN
                      BEGIN
                        WHILE FILEPOS(timetablefile)<>FILESIZE(timetablefile) DO
                          BEGIN
                            READ(timetablefile,timetable);
                            SEEK(timetablefile,FILEPOS(timetablefile)-2);
                            WRITE(timetablefile,timetable);
                            SEEK(timetablefile,FILEPOS(timetablefile)+1);
                          END;
                        IF FILEPOS(timetablefile)=FILESIZE(timetablefile) THEN // if the file pointer is at the end after shuffling
                          BEGIN
                            SEEK(timetablefile,FILEPOS(timetablefile)-1);
                            TRUNCATE(timetablefile); // deletes appointment
                          END
                        ELSE
                          TRUNCATE(timetablefile);
                      END;
                  END;
              END;
          END;
      END;
    PROCEDURE DeleteTimetablePatient;
      BEGIN
        RESET(timetablepatientfile);
        WHILE NOT EOF(timetablepatientfile) DO
          BEGIN
            READ(timetablepatientfile,timetablepatient);
            IF timetablepatient.nhsid=patient.nhsid THEN // if a match is found then it successfully opens the timetablepatient file to delete from there
              BEGIN
                WHILE FILEPOS(timetablepatientfile)<>FILESIZE(timetablepatientfile) DO
                  BEGIN
                    READ(timetablepatientfile,timetablepatient);
                    SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-2);
                    WRITE(timetablepatientfile,timetablepatient);
                    SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)+1);
                  END;
                IF FILEPOS(timetablepatientfile)=FILESIZE(timetablepatientfile) THEN // if the file pointer is at the end after shuffling
                  BEGIN
                    SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-1);
                    TRUNCATE(timetablepatientfile); // deletes appointment
                    RESET(timetablepatientfile);
                  END
                ELSE
                  BEGIN
                    TRUNCATE(timetablepatientfile); // deletes appointment
                    RESET(timetablepatientfile);
                  END;
              END;
          END;
      END;
    PROCEDURE DeletePatientMedication;
      BEGIN
        RESET(patientmedicationfile);
        WHILE NOT EOF(patientmedicationfile) DO
          BEGIN
            READ(patientmedicationfile,patientmedication);
            IF patientmedication.nhsid=patient.nhsid THEN // if a match is found then it successfully opens the patientmedication file to delete from there
              BEGIN
                WHILE FILEPOS(patientmedicationfile)<>FILESIZE(patientmedicationfile) DO
                  BEGIN
                    READ(patientmedicationfile,patientmedication);
                    SEEK(patientmedicationfile,FILEPOS(patientmedicationfile)-2);
                    WRITE(patientmedicationfile,patientmedication);
                    SEEK(patientmedicationfile,FILEPOS(patientillnessfile)+1);
                  END;
                IF FILEPOS(patientmedicationfile)=FILESIZE(patientmedicationfile) THEN // if the file pointer is at the end after shuffling
                  BEGIN
                    SEEK(patientmedicationfile,FILEPOS(patientmedicationfile)-1);
                    TRUNCATE(patientmedicationfile);
                  END
                ELSE
                  TRUNCATE(patientmedicationfile);
              END;
          END;
      END;
    PROCEDURE DeletePatientIllness;
      BEGIN
        RESET(patientillnessfile);
        WHILE NOT EOF(patientillnessfile) DO
          BEGIN
            READ(patientillnessfile,patientillness);
            IF patientillness.nhsid=patient.nhsid THEN // if a match is found then it successfully opens the patientillness file to delete from there
              BEGIN
                WHILE FILEPOS(patientillnessfile)<>FILESIZE(patientillnessfile) DO
                  BEGIN
                    READ(patientillnessfile,patientillness);
                    SEEK(patientillnessfile,FILEPOS(patientillnessfile)-2);
                    WRITE(patientillnessfile,patientillness);
                    SEEK(patientillnessfile,FILEPOS(patientillnessfile)+1);
                  END;
                IF FILEPOS(patientillnessfile)=FILESIZE(patientillnessfile) THEN // if the file pointer is at the end after shuffling
                  BEGIN
                    SEEK(patientillnessfile,FILEPOS(patientillnessfile)-1);
                    TRUNCATE(patientillnessfile);
                  END
                ELSE
                  TRUNCATE(patientillnessfile);
              END;
          END;
      END;
    PROCEDURE DeleteThePatient;
      BEGIN
        WHILE FILEPOS(patientfile)<>FILESIZE(patientfile) DO
          BEGIN
            READ(patientfile,patient);
            SEEK(patientfile,FILEPOS(patientfile)-2);
            WRITE(patientfile,patient);
            SEEK(patientfile,FILEPOS(patientfile)+1);
          END;
        IF FILEPOS(patientfile)=FILESIZE(patientfile) THEN // if the file pointer is at the end after shuffling
          BEGIN
            SEEK(patientfile,FILEPOS(patientfile)-1);
            TRUNCATE(patientfile);
          END
        ELSE
          TRUNCATE(patientfile);
        TEXTCOLOR(lightgreen);
        WRITELN(patforename,' removed successfully.'); // informs user of successful deletion
        TEXTCOLOR(white);
      END;
    BEGIN
      DeleteTimetables;
      DeleteTimetablePatient;
      DeletePatientMedication;
      DeletePatientIllness;
      DeleteThePatient;
    END;

  PROCEDURE TimetableObtainData(VAR newbooking:timetablerecord);
    VAR // obtains the new data for the newbooking of an appointment
      appdate,appstarttime,appendtime:STRING;
      tempdate,tempstarttime,tempendtime:TDATETIME;
    BEGIN
      REPEAT
        REPEAT
          WRITE('Enter date of appointment (D/M/Y) ');
          READLN(appdate);
        UNTIL TestDate(appdate); // validates for a sytactic input
        tempdate:=STRTODATE(appdate);
      UNTIL (CheckDate(tempdate)); // validates to check whether the date inputted is after or the current date
      REPEAT
        REPEAT
          REPEAT
            WRITE('Enter the start time: ');
            READLN(appstarttime);
          UNTIL (TestTime(appstarttime)); // validates for a sytactic input
          tempstarttime:=STRTOTIME(appstarttime);
        UNTIL (StartWorkingHrs(tempstarttime)); // checks to see if the input is after or 08:00 and if the input is before or 16:00
        REPEAT
          REPEAT
            WRITE('Enter the end time: ');
            READLN(appendtime);
          UNTIL (TestTime(appendtime)); // validates for a sytactic input
          tempendtime:=STRTOTIME(appendtime);
        UNTIL (EndWorkingHrs(tempendtime)); // checks to see if the input is before 17:00
      UNTIL (CheckTimes(tempstarttime,tempendtime)) AND (CheckMinTimes(tempstarttime,tempendtime));
      FindPatient;
      newbooking.date:=tempdate;
      newbooking.meetingtype:='P';
      newbooking.starttime:=tempstarttime;
      newbooking.endtime:=tempendtime;
    END;

  PROCEDURE PatientApptName(VAR newbooking:timetablerecord);
    BEGIN
      SEEK(timetablepatientfile,FILESIZE(timetablepatientfile));  // moves the file pointer to the end of the timetablepatient file
      WITH timetablepatient DO
        BEGIN
          date:=newbooking.date;
          starttime:=newbooking.starttime;
          nhsid:=patient.nhsid;
        END;
      WRITE(timetablepatientfile,timetablepatient);  // writes nhs of the patient into the resolver file
    END;

  PROCEDURE DeleteMedicationPatient;
    VAR // deletes medication from assigned patient
      medresponse,patforename:STRING;
      found,existingmed:BOOLEAN;
    BEGIN
      REPEAT
        existingmed:=FALSE;
        FindPatient;
        FindMedication;
        patforename:=patient.forename;
        patforename:=LOWERCASE(patforename);
        patforename:=COPY(UPPERCASE(patforename),1,1)+COPY(LOWERCASE(patforename),2,LENGTH(patforename)-1);
        RESET(patientmedicationfile);
        REPEAT
          READ(patientmedicationfile,patientmedication); // linear search to find existing medication
          IF (patientmedication.medicationid=medication.medicationid) AND (patientmedication.nhsid=patient.nhsid) THEN
            existingmed:=TRUE // existing med is true meaning that a deletion can take place
          ELSE
            existingmed:=FALSE; // this means a deletion cannot take place as there is nothing to delete
        UNTIL (existingmed) OR (EOF(patientmedicationfile));
        IF existingmed THEN
          BEGIN // as there is a match a deletion can take place
            WHILE FILEPOS(patientmedicationfile)<>FILESIZE(patientmedicationfile) DO
              BEGIN
                READ(patientmedicationfile,patientmedication);
                SEEK(patientmedicationfile,FILEPOS(patientmedicationfile)-2);
                WRITE(patientmedicationfile,patientmedication);
                SEEK(patientmedicationfile,FILEPOS(patientillnessfile)+1);
              END;
            IF FILEPOS(patientmedicationfile)=FILESIZE(patientmedicationfile) THEN // if the file pointer is at the end after shuffling
              BEGIN
                SEEK(patientmedicationfile,FILEPOS(patientmedicationfile)-1);
                TRUNCATE(patientmedicationfile);
              END
            ELSE
              TRUNCATE(patientmedicationfile);
            TEXTCOLOR(lightgreen);
            WRITELN('Medication removed from patient.'); // informs user of successful deletion
            TEXTCOLOR(white);
          END;
        IF NOT existingmed THEN
          BEGIN // displays error message as there is no match
            TEXTCOLOR(lightred);
            WRITELN('This medication is not prescribed to the patient, and can therefore not be removed from the patient.');
            TEXTCOLOR(white);
          END;
      UNTIL (existingmed);
    END;

  PROCEDURE SortAppt (newbooking:timetablerecord; position:LONGINT);
    VAR // shuffles and adds a new appointment to the timetablefile
      ended:BOOLEAN;
    BEGIN
      SEEK(timetablefile,FILESIZE(timetablefile)-1);
      ended:=FALSE;
      WHILE NOT(ended) DO // loops until new booking has been inserted
        BEGIN
          IF FILEPOS(timetablefile) <> position THEN
            BEGIN
              READ(timetablefile,timetable);
              WRITE(timetablefile,timetable);
              SEEK(timetablefile,FILEPOS(timetablefile)-3);
            END
          ELSE // it has found the place of insertion
            BEGIN
              READ(timetablefile,timetable);
              WRITE(timetablefile,timetable);
              SEEK(timetablefile,FILEPOS(timetablefile)-2);
              WRITE(timetablefile,newbooking);
              ended:=TRUE;
            END;
        END;
    END;

  PROCEDURE TimetableAdd;
    VAR // adds an appointment to the timetablefile
      newbooking,nextappt,prevappt,availableappt,monappt:timetablerecord;
      response,response2,response3,answer,answer2:CHAR;
      position:LONGINT;
    PROCEDURE FitAppointment;
      BEGIN
        TimetableObtainData(newbooking); // obtains the data of the user
        SEEK(timetablefile,FILESIZE(timetablefile)-1); // moves to the start of the last record of the file
        READ(timetablefile,timetable);
        IF (newbooking.date+newbooking.starttime)>(timetable.date+timetable.starttime) THEN  // compares to see if the newbooking is greater than the last record, if so it adds the newbooking to the end
          BEGIN
            WRITE(timetablefile,newbooking);
            PatientApptName(newbooking); // calls the patientApptName procedure to add the newappointment to the resolver file
            TEXTCOLOR(lightgreen);
            WRITELN('Appointment booked!'); // informs user of successful booking
            TEXTCOLOR(white);
          END
        ELSE
          BEGIN
            RESET(timetablefile);
            REPEAT
              READ(timetablefile,timetable);
            UNTIL (newbooking.date+newbooking.starttime) < (timetable.date+timetable.starttime); // reads timetable record until the new booking is less than the timetable, meaning its found its placement
            nextappt:=timetable; // nextappt is assigned timetable to compare the start time so that it may fit
            SEEK(timetablefile,FILEPOS(timetablefile)-2); // moves file pointer back 2 to find the previous appointment to compare later
            READ(timetablefile,prevappt);
            IF ((newbooking.date+newbooking.endtime) <= (nextappt.date+nextappt.starttime)) AND ((prevappt.date+prevappt.endtime) <=(newbooking.date+newbooking.starttime)) THEN
              BEGIN
                position:=FILEPOS(timetablefile);
                SortAppt(newbooking,position);
                PatientApptName(newbooking);
                TEXTCOLOR(lightgreen);
                WRITELN('Appointment booked!'); // informs user of successful booking
                TEXTCOLOR(white);
              END
            ELSE
              BEGIN
                CLRSCR;
                TEXTCOLOR(lightred);
                WRITELN('Unable to fit you into this slot as it is occupied.'); // informs of error message as unable to fit appointment
                TEXTCOLOR(white);
              END;
          END;
      END;
    PROCEDURE AvailableAppointment;
      BEGIN
        IF NOT (((newbooking.date+newbooking.endtime) <= (nextappt.date+nextappt.starttime)) AND ((prevappt.date+prevappt.endtime) <=(newbooking.date+newbooking.starttime))) THEN
          BEGIN
            CLRSCR;
            TEXTCOLOR(lightred);
            WRITELN('Unable to fit you into this slot as it is occupied.'); // informs of error message as unable to fit appointment
            TEXTCOLOR(white);
            REPEAT
              WRITELN('Would you like me to find the next available appointment? (Y/N) ');
              response:=READKEY;
              response:=UPCASE(response);
              WRITELN(response);
              IF response='Y' THEN
                BEGIN
                  SEEK(timetablefile,FILEPOS(timetablefile)-1);
                  REPEAT
                    READ(timetablefile,timetable); // moves back and reads appointment before failed appointment
                    READ(timetablefile,nextappt); // reads next appointment after failed one
                    SEEK(timetablefile,FILEPOS(timetablefile)-1);
                  UNTIL ((nextappt.date+nextappt.starttime)-(timetable.date+timetable.endtime)>=(1/24)) OR EOF(timetablefile); //loops until a one hour slot is available or end of file
                  IF EOF(timetablefile) THEN
                    BEGIN // if the end of file is reached then there were no available appointments in which a 1 hour slot was available
                      TEXTCOLOR(lightred);
                      WRITELN('Unable to find any other available appointments.');
                      TEXTCOLOR(white);
                    END;
                  IF (nextappt.date>timetable.date) AND (timetable.endtime<=16/24) THEN
                    BEGIN // checks for an appointment at the end of the day
                      availableappt.date:=timetable.date;
                      availableappt.meetingtype:='P';
                      availableappt.starttime:=timetable.endtime;
                      availableappt.endtime:=timetable.endtime+(1/24); // adds an hour to the appointment end time
                      REPEAT
                        CLRSCR;
                        WRITELN('The closest available is ',DATETOSTR(availableappt.date),' from ',TIMETOSTR(availableappt.starttime),' to ',TIMETOSTR(availableappt.endtime)); // displays next available appointment
                        WRITELN('Would you like to book this appointment? (Y/N)');
                        answer:=READKEY;
                        answer:=UPCASE(answer);
                        WRITELN(answer);
                        IF answer='Y' THEN
                          BEGIN
                            position:=FILEPOS(timetablefile);
                            SortAppt(availableappt,position);
                            PatientApptName(availableappt); // adds to the resolver file
                            TEXTCOLOR(lightgreen);
                            WRITELN('Appointment booked!'); // informs user of successful booking
                            TEXTCOLOR(white);
                          END
                        ELSE
                          IF answer='N' THEN
                            CLRSCR // takes to menu
                        ELSE
                          BEGIN
                            CLRSCR;
                            TEXTCOLOR(lightred);
                            WRITELN('You did not put ''Y/N''. Please re-enter. '); // informs of error and displays error message
                            TEXTCOLOR(white);
                          END;
                      UNTIL (answer='Y') OR (answer='N') // loops until 'Y' or 'N' as valid inputs
                    END
                  ELSE
                    IF (nextappt.date>timetable.date) AND (timetable.endtime>16/24) AND (timetable.endtime<=17/24) AND (DAYOFWEEK(timetable.date)=6) THEN
                      BEGIN // checks for an appointment at the end of the day
                        monappt.date:=timetable.date+3;
                        READ(timetablefile,timetable);
                        IF timetable.date>monappt.date THEN
                          BEGIN
                            availableappt.date:=monappt.date;
                            availableappt.starttime:=STRTOTIME('08:00');
                            availableappt.endtime:=availableappt.starttime+(1/24);
                            REPEAT
                              WRITELN(FILEPOS(timetablefile));
                              WRITELN('The closest available is ',DATETOSTR(availableappt.date),' from ',TIMETOSTR(availableappt.starttime),' to ',TIMETOSTR(availableappt.endtime)); // displays next available appointment
                              WRITELN('Would you like to book this appointment? (Y/N)');
                              response2:=READKEY;
                              response2:=UPCASE(response2);
                              WRITELN(response2);
                              IF response2='Y' THEN
                                BEGIN
                                  position:=FILEPOS(timetablefile);
                                  SortAppt(availableappt,position);
                                  PatientApptName(availableappt); // adds to the resolver file
                                  TEXTCOLOR(lightgreen);
                                  WRITELN('Appointment booked!'); // informs user of successful booking
                                  TEXTCOLOR(white);
                                END
                              ELSE
                                IF response2='N' THEN
                                  CLRSCR // takes to menu
                              ELSE
                                BEGIN
                                  CLRSCR;
                                  TEXTCOLOR(lightred);
                                  WRITELN('You did not put ''Y/N''. Please re-enter. '); // informs of error and displays error message
                                  TEXTCOLOR(white);
                                END;
                            UNTIL (response2='Y') OR (response2='N'); // loops until 'Y' or 'N' as valid inputs
                          END;
                        IF timetable.date=monappt.date THEN
                          BEGIN
                            // find out if theres a slot before the first monday appointment and figure out the time
                            IF timetable.starttime>=(9/24) THEN
                              BEGIN
                                availableappt.date:=timetable.date;
                                availableappt.meetingtype:='P';
                                availableappt.starttime:=STRTOTIME('08:00');
                                availableappt.endtime:=availableappt.starttime+(1/24);
                                REPEAT
                                  WRITELN('The closest available is ',DATETOSTR(availableappt.date),' from ',TIMETOSTR(availableappt.starttime),' to ',TIMETOSTR(availableappt.endtime));
                                  WRITELN('Would you like to book this appointment? (Y/N)');
                                  response3:=READKEY;
                                  response3:=UPCASE(response3);
                                  WRITELN(response3);
                                  IF response3='Y' THEN
                                    BEGIN
                                      position:=FILEPOS(timetablefile)-1;
                                      SortAppt(availableappt,position);
                                      PatientApptName(availableappt); // adds to the resolver file
                                      TEXTCOLOR(lightgreen);
                                      WRITELN('Appointment booked!'); // informs user of successful booking
                                      TEXTCOLOR(white);
                                    END
                                  ELSE
                                    IF response3='N' THEN
                                      CLRSCR
                                  ELSE
                                    BEGIN
                                      CLRSCR;
                                      TEXTCOLOR(lightred);
                                      WRITELN('You did not put ''Y/N''. Please re-enter. '); // informs of error and displays error message
                                      TEXTCOLOR(white);
                                    END;
                                UNTIL (response3='Y') OR (response3='N');
                              END;
                          END;
                      END
                  ELSE
                    IF nextappt.date=timetable.date THEN
                      BEGIN
                        availableappt.date:=timetable.date;
                        availableappt.meetingtype:='P';
                        availableappt.starttime:=timetable.endtime;
                        availableappt.endtime:=timetable.endtime+(1/24);
                        REPEAT
                          WRITELN('Closest available is ',DATETOSTR(availableappt.date),' from ',TIMETOSTR(availableappt.starttime),' to ',TIMETOSTR(availableappt.endtime)); // displays next available appointment
                          WRITELN('Would you like to book this appointment? (Y/N)');
                          answer2:=READKEY;
                          answer2:=UPCASE(answer2);
                          WRITELN(answer2);
                          IF answer2='Y' THEN
                            BEGIN
                              position:=FILEPOS(timetablefile);
                              SortAppt(availableappt,position);
                              PatientApptName(availableappt); // adds to the resolver file
                              TEXTCOLOR(lightgreen);
                              WRITELN('Appointment booked!'); // informs user of successful booking
                              TEXTCOLOR(white);
                            END
                          ELSE
                            IF answer2='N' THEN
                              CLRSCR
                          ELSE
                            BEGIN
                              CLRSCR;
                              TEXTCOLOR(lightred);
                              WRITELN('You did not put ''Y/N''. Please re-enter. ');
                              TEXTCOLOR(white);
                            END;
                        UNTIL (answer2='Y') OR (answer2='N');
                      END
                END
              ELSE
                IF response='N' THEN
                  CLRSCR // takes to menu
              ELSE
                BEGIN
                  CLRSCR;
                  TEXTCOLOR(lightred);
                  WRITELN('You did not put ''Y/N''. Please re-enter. ');
                  TEXTCOLOR(white);
                END;
            UNTIL (response='Y') OR (response='N'); // loops until 'Y' or 'N' as valid inputs
          END;
      END;
    BEGIN
      FitAppointment;
      AvailableAppointment;
    END;

  PROCEDURE FindAppointment;
    VAR // performs linear search to find a patient's appointment/s
      count,appointment,appointmentpos:LONGINT;
    PROCEDURE SearchAllAppointments;
      BEGIN
        count:=0;
        FindPatient;
        CLRSCR;
        RESET(timetablepatientfile); // opens resolver file to find nhsid of timetablepatient
        WHILE NOT EOF(timetablepatientfile) DO
          BEGIN
            READ(timetablepatientfile,timetablepatient);
            IF timetablepatient.nhsid=patient.nhsid THEN // once nhsid matches timetablefile will be open
              BEGIN
                RESET(timetablefile);
                WHILE NOT EOF(timetablefile) DO // once record has been found timetablefile will display all matches
                  BEGIN
                    READ(timetablefile,timetable);
                    IF (timetable.starttime=timetablepatient.starttime) AND (timetable.date=timetablepatient.date) THEN
                      BEGIN
                        count:=count+1; // used to show how many appointments there are
                        WITH timetable DO
                          BEGIN
                            WRITELN('Appointment ',count,'.');
                            WRITELN(DATETOSTR(date));
                            WRITELN(TIMETOSTR(starttime));
                            WRITELN(TIMETOSTR(endtime));
                            WRITELN;
                          END;
                      END;
                  END;
              END;
          END;
      END;
    PROCEDURE SearchSpecificAppointment;
      BEGIN
        REPEAT
          WRITELN('What appointment would you like to find? (1-',count,')');
          READLN(appointment); // used to write back the number of the appointment desired to be displayed
          CLRSCR; // clears screen for clarity
          IF (appointment>0) AND (appointment<=count) THEN
            BEGIN
              count:=0;
              RESET(timetablepatientfile);
              WHILE NOT EOF(timetablepatientfile) DO
                BEGIN
                  READ(timetablepatientfile,timetablepatient);
                  IF timetablepatient.nhsid=patient.nhsid THEN
                    BEGIN // if  match is made this loop goes through
                      RESET(timetablefile);
                      WHILE NOT EOF(timetablefile) DO
                        BEGIN
                          READ(timetablefile,timetable);
                          IF timetable.date+timetable.starttime=timetablepatient.date+timetablepatient.starttime THEN
                            BEGIN
                              count:=count+1; // increments until it matches appointment
                              IF count=appointment THEN
                                BEGIN // displays necessary appointment
                                  foundappointment:=timetable; // assigns foundappointment to be used in deletion
                                  TEXTCOLOR(lightgreen);
                                  WRITELN(DATETOSTR(timetable.date));
                                  WRITELN(TIMETOSTR(timetable.starttime));
                                  WRITELN(TIMETOSTR(timetable.endtime));
                                  TEXTCOLOR(white);
                                  WRITELN;
                                  appointmentpos:=FILEPOS(timetablefile);
                                END;
                            END;
                        END;
                    END;
                END;
              SEEK(timetablefile,appointmentpos); //seeks file pointer of appointment number inputted ready for UpdateAppointment procedure
            END
          ELSE // if the appointment is greater than count or less than or equal to 0 an error message will be displayed
            BEGIN
              TEXTCOLOR(lightred);
              WRITELN('Invalid appointment. Please provide a valid appointment number.');
              TEXTCOLOR(white);
            END;
        UNTIL (appointment>0) AND (appointment<=count); // repeats until valid appointment number
      END;
    BEGIN
      SearchAllAppointments;
      SearchSpecificAppointment;
    END;

  PROCEDURE NewAppointmentUpdateData(VAR updatebooking:timetablerecord);
    VAR // receives new appointment data to be called in update procedure
      apptdate,apptstarttime,apptendtime:STRING;
      tempstarttime,tempendtime,tempdate:TDATETIME;
    BEGIN
      REPEAT
        REPEAT
          WRITELN('Enter the date of the appointment you would like to update the current appointment to.');
          READLN(apptdate);
        UNTIL (TestDate(apptdate)); // validates for a sytactic input
        tempdate:=STRTODATE(apptdate);
      UNTIL (CheckDate(tempdate)); // validates to check whether the date inputted is after or the current date
      REPEAT
        REPEAT
          REPEAT
            WRITELN('Enter the start time of the appointment you would like to update the current appointment to.');
            READLN(apptstarttime);
          UNTIL (TestTime(apptstarttime)); // validates for a sytactic input
          tempstarttime:=STRTOTIME(apptstarttime);
        UNTIL (StartWorkingHrs(tempstarttime)); // checks to see if the input is after or 08:00 and if the input is before or 16:00
        REPEAT
          REPEAT
            WRITELN('Enter the end time of the appointment you would like to update the current appointment to.');
            READLN(apptendtime);
          UNTIL (TestTime(apptendtime)); // validates for a sytactic input
          tempendtime:=STRTOTIME(apptendtime);
        UNTIL (EndWorkingHrs(tempendtime)); // checks to see if the input is before 17:00
      UNTIL (CheckTimes(tempstarttime,tempendtime)) AND (CheckMinTimes(tempstarttime,tempendtime));
      updatebooking.date:=tempdate;
      updatebooking.meetingtype:='P';
      updatebooking.starttime:=tempstarttime;
      updatebooking.endtime:=tempendtime;
    END;

  PROCEDURE DeleteAppointment;
    PROCEDURE DeleteTimetablePatient;
      BEGIN
        FindAppointment; // finds appointment to be deleted and keeps file pointer
        RESET(timetablepatientfile); // opens resolver
        REPEAT
          READ(timetablepatientfile,timetablepatient);
        UNTIL (timetablepatient.date+timetablepatient.starttime) = (foundappointment.date+foundappointment.starttime); // finds record
        WHILE FILEPOS(timetablepatientfile)<>FILESIZE(timetablepatientfile) DO
          BEGIN
            READ(timetablepatientfile,timetablepatient);
            SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-2);
            WRITE(timetablepatientfile,timetablepatient);
            SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)+1);
          END;
        IF FILEPOS(timetablepatientfile)=FILESIZE(timetablepatientfile) THEN // if the file pointer is at the end after shuffling
          BEGIN
            SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-1);
            TRUNCATE(timetablepatientfile); // deletes appointment
          END
        ELSE
          TRUNCATE(timetablepatientfile); // deletes appointment
      END;
    PROCEDURE DeleteTimetable;
      BEGIN
        WHILE FILEPOS(timetablefile)<>FILESIZE(timetablefile) DO
        BEGIN
          READ(timetablefile,timetable);
          SEEK(timetablefile,FILEPOS(timetablefile)-2);
          WRITE(timetablefile,timetable);
          SEEK(timetablefile,FILEPOS(timetablefile)+1);
        END;
        IF FILEPOS(timetablefile)=FILESIZE(timetablefile) THEN // if the file pointer is at the end after shuffling
          BEGIN
            SEEK(timetablefile,FILEPOS(timetablefile)-1);
            TRUNCATE(timetablefile); // deletes appointment
          END
        ELSE
          TRUNCATE(timetablefile); // deletes appointment
        CLRSCR;
        TEXTCOLOR(lightgreen);
        WRITELN('Appointment deleted.'); // informs of successful deletion
        TEXTCOLOR(white);
      END;
    BEGIN
      DeleteTimetablePatient;
      DeleteTimetable;
    END;

  PROCEDURE UpdateAppointment;
    VAR // updates an appointment by adding the new one and deleting the appointment to be updated
      position,appointmentpos:LONGINT;
      updatebooking,nextappt,prevappt:timetablerecord;
      updated:BOOLEAN;
    PROCEDURE FitAppointmentAtEnd;
      BEGIN
        FindAppointment; // searches for appointment to be updated
        NewAppointmentUpdateData(updatebooking); // obtains updated appointment data
        appointmentpos:=FILEPOS(timetablefile)-1; // file pointer is kept from search procedure and moved back to be read again
        SEEK(timetablefile,FILESIZE(timetablefile)-1); // moves to the second last position to check if addition is possible
        READ(timetablefile,timetable);
        IF (updatebooking.date+updatebooking.starttime)>(timetable.date+timetable.starttime) THEN // if addition is possible then
          BEGIN
            updated:=TRUE;
            WRITE(timetablefile,updatebooking); // writes updated booking
            PatientApptName(updatebooking); // adds to resolver
            SEEK(timetablefile,appointmentpos); // goes to appointment to be deleted
            READ(timetablefile,timetable); // reads appointment to be deleted
            RESET(timetablepatientfile);
            REPEAT
              READ(timetablepatientfile,timetablepatient);
            UNTIL (timetablepatient.date+timetablepatient.starttime) = (timetable.date+timetable.starttime); // searches for match
            WHILE FILEPOS(timetablepatientfile)<>FILESIZE(timetablepatientfile) DO // shuffles for deletion
              BEGIN
                READ(timetablepatientfile,timetablepatient);
                SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-2);
                WRITE(timetablepatientfile,timetablepatient);
                SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)+1);
              END;
            IF FILEPOS(timetablepatientfile)=FILESIZE(timetablepatientfile) THEN // if the file pointer is at the end after shuffling
              BEGIN
                SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-1);
                TRUNCATE(timetablepatientfile); // deletes appointment
              END
            ELSE
              TRUNCATE(timetablepatientfile); // deletes appointment
            WHILE FILEPOS(timetablefile)<>FILESIZE(timetablefile) DO
              BEGIN
                READ(timetablefile,timetable);
                SEEK(timetablefile,FILEPOS(timetablefile)-2);
                WRITE(timetablefile,timetable);
                SEEK(timetablefile,FILEPOS(timetablefile)+1);
              END;
            IF FILEPOS(timetablefile)=FILESIZE(timetablefile) THEN // if the file pointer is at the end after shuffling
              BEGIN
                SEEK(timetablefile,FILEPOS(timetablefile)-1);
                TRUNCATE(timetablefile); // deletes appointment
              END
            ELSE
              TRUNCATE(timetablefile); // deletes appointment
          END;
      END;
    PROCEDURE FitAppointmentElse;
      BEGIN
        IF NOT ((updatebooking.date+updatebooking.starttime)>(timetable.date+timetable.starttime)) THEN
          BEGIN
            RESET(timetablefile);
            REPEAT
              READ(timetablefile,timetable);
            UNTIL (updatebooking.date+updatebooking.starttime) < (timetable.date+timetable.starttime); // reads timetable record until the updated booking is less than the timetable, meaning its found its placement
            nextappt:=timetable; // nextappt is assigned timetable to compare the start time so that it may fit
            SEEK(timetablefile,FILEPOS(timetablefile)-2); // moves file pointer back 2 to find the previous appointment to compare later
            READ(timetablefile,prevappt);
            IF ((updatebooking.date+updatebooking.endtime) <= (nextappt.date+nextappt.starttime)) AND ((prevappt.date+prevappt.endtime) <=(updatebooking.date+updatebooking.starttime)) THEN
              BEGIN
                position:=FILEPOS(timetablefile);
                SortAppt(updatebooking,position); // writes the updatebooking to the timetablefile
                PatientApptName(updatebooking); // adds to resolver
                SEEK(timetablefile,appointmentpos); // goes to appointment to be deleted
                READ(timetablefile,timetable); // reads appointment to be deleted
                RESET(timetablepatientfile);
                REPEAT
                  READ(timetablepatientfile,timetablepatient);
                UNTIL (timetablepatient.date+timetablepatient.starttime) = (timetable.date+timetable.starttime); // searches for match
                WHILE FILEPOS(timetablepatientfile)<>FILESIZE(timetablepatientfile) DO // shuffles for deletion
                  BEGIN
                    READ(timetablepatientfile,timetablepatient);
                    SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-2);
                    WRITE(timetablepatientfile,timetablepatient);
                    SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)+1);
                  END;
                IF FILEPOS(timetablepatientfile)=FILESIZE(timetablepatientfile) THEN // if the file pointer is at the end after shuffling
                  BEGIN
                    SEEK(timetablepatientfile,FILEPOS(timetablepatientfile)-1);
                    TRUNCATE(timetablepatientfile); // deletes appointment
                  END
                ELSE
                  TRUNCATE(timetablepatientfile); // deletes appointment
                WHILE FILEPOS(timetablefile)<>FILESIZE(timetablefile) DO // shuffles for deletion
                  BEGIN
                    READ(timetablefile,timetable);
                    SEEK(timetablefile,FILEPOS(timetablefile)-2);
                    WRITE(timetablefile,timetable);
                    SEEK(timetablefile,FILEPOS(timetablefile)+1);
                  END;
                IF FILEPOS(timetablefile)=FILESIZE(timetablefile) THEN // if the file pointer is at the end after shuffling
                  BEGIN
                    SEEK(timetablefile,FILEPOS(timetablefile)-1);
                    TRUNCATE(timetablefile); // deletes appointment
                  END
                ELSE
                  TRUNCATE(timetablefile); // deletes appointment
                updated:=TRUE;
              END
            ELSE
              updated:=FALSE;
          END;
      END;
    BEGIN
      updated:=FALSE;
      FitAppointmentAtEnd; // tests if the appointment fits at the end
      IF NOT updated THEN
        FitAppointmentElse; // calls FitAppointmentElse if the appointment doesnt fit at end
      IF updated THEN
        BEGIN
          TEXTCOLOR(lightgreen);
          WRITELN('Appointment successfully updated.'); // informs of a success confirmation message
          TEXTCOLOR(white);
        END
      ELSE
        BEGIN
          TEXTCOLOR(lightred);
          WRITELN('Unable to update the appointment as there is currently an appointment taking place at this time.');
          TEXTCOLOR(white);
        END;
    END;

  PROCEDURE AmendForename(inpforename:STRING);
    BEGIN // updates the forename of the patient
      REPEAT
        WRITELN('What would you like me to change the patient''s forename to?');
        READLN(inpforename);
      UNTIL (TestPresence(inpforename));
      patient.forename:=inpforename;
      SEEK(patientfile,FILEPOS(patientfile)-1);
      WRITE(patientfile,patient);
    END;

  PROCEDURE AmendSurname(inpsurname:STRING);
    BEGIN // updates the surname of the patient
      REPEAT
        WRITELN('What would you like me to change the patient''s surname to?');
        READLN(inpsurname);
      UNTIL (TestPresence(inpsurname));
      patient.surname:=inpsurname;
      SEEK(patientfile,FILEPOS(patientfile)-1);
      WRITE(patientfile,patient);
    END;

  PROCEDURE AmendContact;
    VAR // updates thhe emergency contact of the patient
      inpcontact:STRING;
    BEGIN
      REPEAT
        WRITELN('What would you like me to change the patient''s emergency contact to?');
        READLN(inpcontact);
      UNTIL (TestPresence(inpcontact)) AND (TestifContactValid(inpcontact)) AND (TestIfLengthValid(inpcontact));
      patient.emergencycontact:=inpcontact;
      SEEK(patientfile,FILEPOS(patientfile)-1);
      WRITE(patientfile,patient);
    END;

  PROCEDURE AmendAddress;
    VAR // updates the address of the patient
      inpaddress:STRING;
    BEGIN
      REPEAT
        WRITELN('What would you like me to change the patient''s address to?');
        READLN(inpaddress);
      UNTIL (TestPresence(inpaddress));
      patient.address:=inpaddress;
      SEEK(patientfile,FILEPOS(patientfile)-1);
      WRITE(patientfile,patient);
    END;

  PROCEDURE AmendEmail;
    VAR // updates the email address of the patient
      inpemail:STRING;
    BEGIN
      REPEAT
        WRITELN('What would you like me to change the patient''s email to?');
        READLN(inpemail);
      UNTIL (TestPresence(inpemail)) AND (HasAt(inpemail));
      patient.email:=inpemail;
      SEEK(patientfile,FILEPOS(patientfile)-1);
      WRITE(patientfile,patient);
    END;

  PROCEDURE AmendPatient;
    VAR // updates the patient record
      patientforename,patientsurname:STRING;
      choice:CHAR;
    BEGIN
      REPEAT
        FindPatient;
        CLRSCR;
        WRITELN('Here are the list of information you may change about a patient:');
        WRITELN('A: Forename');
        WRITELN('B: Surname');
        WRITELN('C: Emergency Contact');
        WRITELN('D: Address');
        WRITELN('E: Email');
        WRITELN('X: Return');
        choice:=READKEY;
        choice:=UPCASE(choice);
        CASE choice OF
          'A':AmendForename(patientforename);
          'B':AmendSurname(patientsurname);
          'C':AmendContact;
          'D':AmendAddress;
          'E':AmendEmail;
        END;
      UNTIL (choice='X');
      CLRSCR;
    END;

  PROCEDURE SortPatient(newpatient:patientrecord);
    VAR // sorts and adds a new patient to the patientfile
      firstpos:LONGINT;
    BEGIN
      firstpos:=2; // skips over the 'N' in nhsid
      SEEK(patientfile,FILESIZE(patientfile)-1);
      READ(patientfile,patient);
      WHILE ((COPY(newpatient.nhsid,firstpos,LENGTH(newpatient.nhsid)))<(COPY(patient.nhsid,firstpos,LENGTH(patient.nhsid)))) AND (FILEPOS(patientfile)>=2) DO
        BEGIN // compares number section of nhsid
          WRITE(patientfile,patient);
          SEEK(patientfile,FILEPOS(patientfile)-3); //seeks minus 3 to overwrite records
          READ(patientfile,patient);
        END;
      IF FILEPOS(patientfile)=1 THEN
        BEGIN
          IF (COPY(newpatient.nhsid,firstpos,LENGTH(newpatient.nhsid)))<(COPY(patient.nhsid,firstpos,LENGTH(patient.nhsid))) THEN
            BEGIN
              WRITE(patientfile,patient);
              RESET(patientfile);
            END;
        END;
      WRITE(patientfile,newpatient); // writes new patient
      TEXTCOLOR(lightgreen);
      WRITELN('A new patient has been added.'); // informs of successful addition
      TEXTCOLOR(white);
    END;

  PROCEDURE AddPatient;
    VAR // adds a patient to the patientrecord
      newpatient:patientrecord;
      noillness,nomedications:LONGINT;
    BEGIN
      PatientObtainData(newpatient); // gets the user information of the new patient
      SortPatient(newpatient);
      REPEAT
        WRITELN('How many illnesses will this patient have?');
        READLN(noillness);
        IF noillness<=0 THEN
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN('The patient must have an illness.');
            TEXTCOLOR(white);
          END;
        IF noillness>5 THEN
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN('The patient cannot have more than 5 illnesses.');
            TEXTCOLOR(white);
          END;
      UNTIL (noillness>0) AND (noillness<=5);
      REPEAT
        WRITELN('How many medications will this patient have?');
        READLN(nomedications);
        IF nomedications<=0 THEN
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN('The patient must have a medication.');
            TEXTCOLOR(white);
          END;
        IF nomedications>3 THEN
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN('The patient cannot have more than 3 medications.');
            TEXTCOLOR(white);
          END;
      UNTIL (nomedications>0) AND (nomedications<=3);
      REPEAT
        AddIllnessPatient; // adds an illness to the illness patient resolver file
        noillness:=noillness-1; // decrements the noillnesses until it reaches 0, which means that there are no more illnesses to add
      UNTIL (noillness=0);
      REPEAT
        AddMedicationPatient;
        nomedications:=nomedications-1;
      UNTIL (nomedications=0);
    END;

  PROCEDURE MedicationChoice;
    VAR // displays necessary menu options
      options:CHAR;
    BEGIN
      WRITELN('Please select one of the following options:');
      WRITELN('A: Search for a medication');
      WRITELN('B: Add a medication to a patient');
      WRITELN('C: Remove a medication from a patient');
      WRITELN('D: Update a dosage of a medication on a patient');
      WRITELN('Please enter an option');
      options:=UPCASE(READKEY);
      WRITELN(options);
      CLRSCR;
      CASE options OF
        'A':FindMedication;
        'B':AddMedicationPatient;
        'C':DeleteMedicationPatient;
        'D':UpdateMedication;
      END
    END;

  PROCEDURE PatientChoice;
    VAR // displays necessary patient options
      options:CHAR;
    BEGIN
      WRITELN('Please select one of the following options:');
      WRITELN('A: Search for a patient');
      WRITELN('B: Add a new patient');
      WRITELN('C: Delete a patient');
      WRITELN('D: Update a patient');
      WRITELN('Please enter an option');
      options:=UPCASE(READKEY);
      WRITELN(options);
      CLRSCR;
      CASE options OF
        'A':FindPatient;
        'B':AddPatient;
        'C':DeletePatient;
        'D':AmendPatient;
      END
    END;

  PROCEDURE TimetableChoice;
    VAR // displays necessary timetable options
      options:CHAR;
    BEGIN
      WRITELN('Please select one of the following options:');
      WRITELN('A: Search for an appointment');
      WRITELN('B: Add a new appointment');
      WRITELN('C: Delete an appointment');
      WRITELN('D: Update an appointment');
      WRITELN('Please enter an option');
      options:=UPCASE(READKEY);
      WRITELN(options);
      CLRSCR;
      CASE options OF
        'A':FindAppointment;
        'B':TimetableAdd;
        'C':DeleteAppointment;
        'D':UpdateAppointment;
      END
    END;

  PROCEDURE DisplayChoice;
    VAR // displays necessary options for displaying files
      options:CHAR;
    BEGIN
      WRITELN('Please select one of the following options:');
      WRITELN('A: Patients');
      WRITELN('B: Illnesses');
      WRITELN('C: Medications');
      WRITELN('D: Timetables');
      WRITELN('E: Employees');
      WRITELN('R: Return');
      WRITELN('Please enter an option');
      options:=UPCASE(READKEY);
      WRITELN(options);
      CLRSCR;
      CASE options OF
        'A':DisplayPatients;
        'B':DisplayIllnesses;
        'C':DisplayMedications;
        'D':DisplayTimetable;
        'E':DisplayEmployees;
      END;
    END;

  PROCEDURE IllnessChoice;
    VAR // displays necessary illness options
      options:CHAR;
    BEGIN
      WRITELN('Please select one of the following options:');
      WRITELN('A: Search for an illness');
      WRITELN('B: Diagnose a patient with an illness');
      WRITELN('C: Remove an illness from a patient');
      WRITELN('Please enter an option');
      options:=READKEY;
      options:=UPCASE(options);
      CLRSCR;
      CASE options OF
        'A':FindIllness;
        'B':AddIllnessPatient;
        'C':DeleteIllnessPatient;
      END;
    END;

  PROCEDURE MainMenu;
    VAR // displays necessary sub menus
      options:CHAR;
      timeleft,count,count2:LONGINT;
    BEGIN
      REPEAT
        timeleft:=5;
        count2:=5;
        WRITELN('Please select one of the following options:');
        WRITELN('A: Patients');
        WRITELN('B: Illnesses');
        WRITELN('C: Medicine ');
        WRITELN('D: Timetables');
        WRITELN('E: Display Information');
        WRITELN('X: Exit');
        WRITELN('Please enter an option');
        options := UPCASE(READKEY);
        CLRSCR;
        CASE options OF
          'A':PatientChoice;
          'B':IllnessChoice;
          'C':MedicationChoice;
          'D':TimetableChoice;
          'E':DisplayChoice;
          'X':BEGIN
                FOR count:= 1 TO timeleft DO // displays the delay in real time
                  BEGIN
                    CLRSCR;
                    TEXTCOLOR(magenta);
                    WRITELN('Exiting program in ',(timeleft-count)+1 , ' seconds...');
                    TEXTCOLOR(white);
                    DELAY(1000);
                    count2:=count2-1;
                    IF count2=0 THEN
                      HALT;
                  END;
                TEXTCOLOR(white);
              END;
        END;
      UNTIL options='X';
    END;

  PROCEDURE ChangePassword;
    VAR // allows the user to change the current password
      currentpassword,newpassword,newpassword2,displaypassword,displaypassword2,displaypassword3:STRING;
      inppassword,inppassword2,inppassword3,keyentered:CHAR;
      value,value2,value3:LONGINT;
    BEGIN
      REPEAT
        REPEAT
          newpassword:=''; // empty string so that the user may enter the new password
          displaypassword:='';
          WRITELN('New Password: ');
          REPEAT
            inppassword:=READKEY;
            value:=ORD(inppassword); // ascii value stored
            CLRSCR;
            IF (value<>13) AND (value<>8) THEN // tests for backspaces and enter key
              BEGIN
                newpassword:=newpassword+inppassword;
                displaypassword:=displaypassword+'*';
                WRITELN('New Password: ');
                WRITE(displaypassword); // written back as asterisks to protect user privacy
              END;
            IF (value=8) AND (LENGTH(newpassword)>0) THEN // tests for an empty string and backspace
              BEGIN
                DELETE(newpassword,LENGTH(newpassword),1); // deletes last character entered
                DELETE(displaypassword,LENGTH(displaypassword),1); // deletes last character entered
                WRITELN('New Password: ');
                WRITELN(displaypassword); // displays new string for user friendliness
              END;
          UNTIL (value=13); // until enter key is pressed
          currentpassword:=''; // empty string so that the user may enter the current password
          displaypassword2:='';
          WRITELN('Current Password: ');
          REPEAT
            inppassword2:=READKEY;
            value2:=ORD(inppassword2); // ascii value stored
            CLRSCR;
            IF (value2<>13) AND (value2<>8) THEN // tests for backspaces and enter key
              BEGIN
                currentpassword:=currentpassword+inppassword2;
                displaypassword2:=displaypassword2+'*';
                WRITELN('Current Password: ');
                WRITE(displaypassword2); // written back as asterisks to protect user privacy
              END;
            IF (value2=8) AND (LENGTH(currentpassword)>0) THEN // tests for an empty string and backspace
              BEGIN
                DELETE(currentpassword,LENGTH(currentpassword),1); // deletes last character entered
                DELETE(displaypassword2,LENGTH(displaypassword2),1); // deletes last character entered
                WRITELN('Current Password: ');
                WRITELN(displaypassword2); // displays new string for user friendliness
              END;
          UNTIL (value2=13); // until enter key is pressed
          TestPassword(currentpassword); // function is called to test if the current password is the valid password
          TestPasswordDiff(currentpassword,newpassword); // function is called to test if the current and new password are the same
        UNTIL (TestPassword(currentpassword)) AND (TestPasswordDiff(currentpassword,newpassword)); // repeats until the function is true
        newpassword2:=''; // empty string so that the user may re-enter the new password
        displaypassword3:='';
        WRITELN('Re-enter the New Password: ');
        REPEAT
          inppassword3:=READKEY;
          value3:=ORD(inppassword3); // ascii value stored
          CLRSCR;
          IF (value3<>13) AND (value3<>8) THEN // tests for backspaces and enter key
            BEGIN
              newpassword2:=newpassword2+inppassword3;
              displaypassword3:=displaypassword3+'*';
              WRITELN('Re-enter the New Password: ');
              WRITE(displaypassword3); // written back as asterisks to protect user privacy
            END;
          IF (value3=8) AND (LENGTH(newpassword2)>0) THEN // tests for an empty string and backspace
            BEGIN
              DELETE(newpassword2,LENGTH(newpassword2),1); // deletes last character entered
              DELETE(displaypassword3,LENGTH(displaypassword3),1); // deletes last character entered
              WRITELN('Re-enter the New Password: ');
              WRITELN(displaypassword3); // displays new string for user friendliness
            END;
        UNTIL (value3=13); // until enter key is pressed
        TestPassword2(newpassword,newpassword2); // function is called to test if the two new passwords are same
      UNTIL (TestPassword2(newpassword,newpassword2)); // repeats until the function is true
      RESET(loginfile);
      READ(loginfile,login);
      login.password:=newpassword; // the login password is assigned the new password
      SEEK(loginfile,FILEPOS(loginfile)-1);
      WRITE(loginfile,login);
      TEXTCOLOR(lightgreen);
      WRITELN('Password successfully changed.');
      TEXTCOLOR(white);
      WRITELN('Press any key to exit.');
      keyentered:=READKEY;
      CLRSCR;
      MainMenu;
    END;

  PROCEDURE LoginSystem;
    VAR // login system that requires a valid password for entry to protect confidentiality
      password,displaypassword:STRING;
      inppassword,choice:CHAR;
      value,del,deltime,count:LONGINT;
    BEGIN
      del:=0;
      deltime:=0;
      REPEAT
        password:=''; // an empty string, what the user types
        displaypassword:=''; // an empty string, which will be filled with asterisks, what the user sees on the screen
        WRITELN('Enter password to gain entry: ');
        REPEAT
          inppassword:=READKEY;
          value:=ORD(inppassword);
          CLRSCR;
          IF (value<>13) AND (value<>8) THEN // if the enter or backspace is not entered then inp is added to the empty string
            BEGIN
              password:=password+inppassword;
              displaypassword:=displaypassword+'*'; // for every character to password, displaypassword will add an asterisk to itself
              WRITELN('Enter password to gain entry: ');
              WRITE(displaypassword); // continually writes to the user to prevent backspacing the wrong character
            END;
          IF (value=8) AND (LENGTH(password)>0) THEN // if backspace is entered
            BEGIN
              DELETE(password,LENGTH(password),1);
              DELETE(displaypassword,LENGTH(displaypassword),1); // deletes last character from display password as well as password, to show the user that it has been deleted
              WRITELN('Enter password to gain entry: ');
              WRITELN(displaypassword); // writes back displayed password with last character deleted
            END;
        UNTIL (value=13); // repeats until enter key pressed
        RESET(loginfile); // opens login file
        READ(loginfile,login);
        IF login.password=password THEN // compares password to password (what the user inputted)
          BEGIN
            CLRSCR;
            REPEAT
              WRITELN('Please choose from the following options');
              WRITELN('A: Change Passwords');
              WRITELN('B: Access the Main Menu');
              WRITELN('Please enter an option.');
              choice:=UPCASE(READKEY);
              WRITELN(choice);
              CLRSCR;
              CASE choice OF
                'A':ChangePassword;
                'B':MainMenu;
              END;
            UNTIL (choice='1') OR (choice='2');
          END
        ELSE // password is incorrect, an error message will be displayed
          BEGIN
            del:=del+5000; // delay of 5 seconds (in milliseconds) that increments by 5 seconds each time an incorrect password is inputted
            deltime:=deltime+5; // the delay time that will be displayed to the user
            IF del>30000 THEN // if the user gets the password wrong 6 times, the delay will stay constant at 30 seconds
              BEGIN
                del:=30000; // delay in milliseconds
                deltime:=30; // delay time displayed to user
              END;
            TEXTCOLOR(lightred);
            WRITELN('Incorrect password.');
            WRITELN('Access Denied.');
            FOR count:= 1 TO deltime DO // displays the delay in real time
              BEGIN
                CLRSCR;
                WRITELN('Incorrect password.');
                WRITELN('Access Denied.');
                WRITELN('Please try again in ',(deltime-count)+1 , ' seconds.');
                DELAY(1000);
              END;
            TEXTCOLOR(white);
            CLRSCR;
          END;
      UNTIL (password=login.password); // repeats until the password is the same as the login password on the system
    END;

  PROCEDURE CloseFiles;
    BEGIN // closes all files
      CLOSE(loginfile);
      CLOSE(patientfile);
      CLOSE(illnessfile);
      CLOSE(medicationfile);
      CLOSE(timetablefile);
      CLOSE(employeefile);
      CLOSE(timetableemployeefile);
      CLOSE(patientillnessfile);
      CLOSE(timetablepatientfile);
      CLOSE(medicationillnessfile);
      CLOSE(patientmedicationfile);
    END;

  BEGIN
    InitialiseFiles;
    LoginSystem;
    CloseFiles;
  END.

