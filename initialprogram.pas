PROGRAM initialprogram;

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

    medicationillnessrecord=RECORD
                              medicationid:STRING[4];
                              illnessid:STRING[4];
                            END;
    medicationillnessfiletype= FILE of medicationillnessrecord;

    patientmedicationrecord=RECORD
                              nhsid:STRING[4];
                              medicationid:STRING[4];
                              medicationdosage:STRING;
                            END;
    patientmedicationfiletype= FILE of patientmedicationrecord;

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
    timetableemployeefiletype= FILE of timetableemployeerecord;

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
    timetable:timetablerecord;
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
        WRITELN('Please enter drive: ');
        drivechar:=UPCASE(READKEY);
        WRITELN(drivechar);
        IF NOT(drivechar IN drives) THEN // if the input is not a valid drive then an error message is displayed
          BEGIN
            TEXTCOLOR(lightred);
            WRITELN('Please enter valid drive.');
            WRITELN;
            TEXTCOLOR(white);
          END;
      UNTIL drivechar IN drives; // repeats until a valid drive is inputted
      PickDrive:=drivechar;
    END;

  PROCEDURE initialisefiles;
    VAR
      directory:STRING;
    BEGIN
      directory:=PickDrive+':\Computer Science\Projects\';

      ASSIGN(loginfile,directory+'login.dta');
      REWRITE(loginfile);

      ASSIGN(patientfile,directory+'patient.dta');
      REWRITE(patientfile);

      ASSIGN(illnessfile,directory+'illness.dta');
      REWRITE(illnessfile);

      ASSIGN(medicationfile,directory+ 'medication.dta');
      REWRITE(medicationfile);

      ASSIGN(medicationillnessfile,directory+'medicationillnessresolver.dta');
      REWRITE(medicationillnessfile);

      ASSIGN(patientmedicationfile,directory+'patientmedicationresolver.dta');
      REWRITE(patientmedicationfile);

      ASSIGN(timetablefile,directory+'timetable.dta');
      REWRITE(timetablefile);

      ASSIGN(employeefile,directory+'employee.dta');
      REWRITE(employeefile);

      ASSIGN(timetableemployeefile,directory+'timetableemployee.dta');
      REWRITE(timetableemployeefile);

      ASSIGN(timetablepatientfile,directory+'timetablepatientresolver.dta');
      REWRITE(timetablepatientfile);

      ASSIGN(patientillnessfile,directory+'patientillnessresolver.dta');
      REWRITE(patientillnessfile);
    END;

  PROCEDURE createloginfile;
    BEGIN
      login.password:='cs123';
      WRITE(loginfile,login);
    END;

  PROCEDURE createpatientfile;
    BEGIN
      WITH patient DO
        BEGIN
          nhsid:='N000';
          forename:='Emily';
          surname:='Johnson';
          dob:=STRTODATE('19/06/1965');
          emergencycontact:='07700900123';
          address:='17 Elm Street, Manchester, M12 3AB';
          email:='emily.johnson@example.com';
          WRITE(patientfile,patient);

          nhsid:='N001';
          forename:='Marcus';
          surname:='Patel';
          dob:=STRTODATE('28/03/1978');
          emergencycontact:='07812345678';
          address:='17 Elm Street, Manchester, M12 3AB';
          email:='marcus.patel@example.com';
          WRITE(patientfile,patient);

          nhsid:='N002';
          forename:='Jennifer';
          surname:='Nguyen';
          dob:=STRTODATE('09/10/1982');
          emergencycontact:='07956789012';
          address:='68 Maple Road, Birmingham, B1 1AA';
          email:='jennifer.nguyen@example.com';
          WRITE(patientfile,patient);

          nhsid:='N003';
          forename:='Alexander';
          surname:='Thompson';
          dob:=STRTODATE('05/12/1957');
          emergencycontact:='07954321098';
          address:='25 Pine Lane, Glasgow, G1 1AA';
          email:='alexander.thompson@example.com';
          WRITE(patientfile,patient);

          nhsid:='N004';
          forename:='Sophia';
          surname:='Martinez';
          dob:=STRTODATE('20/04/1969');
          emergencycontact:='0754387643';
          address:='53 Cedar Close, Liverpool, L1 1AA';
          email:='sophia.martinez@example.com';
          WRITE(patientfile,patient);

          nhsid:='N005';
          forename:='Benjamin';
          surname:='Lee';
          dob:=STRTODATE('12/09/1972');
          emergencycontact:='07789210987';
          address:='89 Birch Grove, Cardiff, CF1 1AA';
          email:='benjamin.lee@example.com';
          WRITE(patientfile,patient);

          nhsid:='N006';
          forename:='Olivia';
          surname:='Rodriguez';
          dob:=STRTODATE('03/11/1986');
          emergencycontact:='07890543210';
          address:='12 Ash Street, Belfast, BT1 1AA';
          email:='olivia.rodriguez@example.com';
          WRITE(patientfile,patient);

          nhsid:='N007';
          forename:='Lucas';
          surname:='Brown';
          dob:=STRTODATE('19/02/1960');
          emergencycontact:='07987654321';
          address:='36 Beech Drive, Edinburgh, EH1 1AA';
          email:='lucas.brown@example.com';
          WRITE(patientfile,patient);

          nhsid:='N008';
          forename:='Isabella';
          surname:='Garcia';
          dob:=STRTODATE('24/07/1980');
          emergencycontact:='07634098765';
          address:='77 Willow Way, Bristol, BS1 1AA';
          email:='isabella.garcia@example.com';
          WRITE(patientfile,patient);

          nhsid:='N009';
          forename:='William';
          surname:='Wright';
          dob:=STRTODATE('07/05/1971');
          emergencycontact:='07521234567';
          address:='49 Sycamore Court, Newcastle, NE1 1AA';
          email:='william.wright@example.com';
          WRITE(patientfile,patient);
        END;
    END;

  PROCEDURE createillnessfile;
    BEGIN
      WITH illness DO
        BEGIN
          illnessid:='I001';
          illnessname:='Anxiety Disorder';
          illnessdescription:='Excessive fear or worry about a specific situation';
          WRITE(illnessfile,illness);

          illnessid:='I002';
          illnessname:='Schizophrenia';
          illnessdescription:='An illness where you may feel or see things that may not be real';
          WRITE(illnessfile,illness);

          illnessid:='I003';
          illnessname:='Obsessive Compulsive Disorder';
          illnessdescription:='Mental illness involving persistent, unwanted thoughts (obsessions) and repetitive actions (compulsions) to reduce anxiety.';
          WRITE(illnessfile,illness);

          illnessid:='I004';
          illnessname:='Bipolar Disorder';
          illnessdescription:='A mental illness that causes unusual shifts in a person''s mood, energy, activity levels and concentration';
          WRITE(illnessfile,illness);

          illnessid:='I005';
          illnessname:='Post Traumatic Disorder';
          illnessdescription:='A mental health illness caused by traumatic experiences';
          WRITE(illnessfile,illness);
        END;
    END;

  PROCEDURE createmedicationfile;
    BEGIN
      WITH medication DO
        BEGIN
          medicationid:='M001';
          medicationame:='Lamotrigine';
          medicationdescription:='Medicine that reduces feelings of excitability and delays occurrence of mood episodes';
          WRITE(medicationfile,medication);

          medicationid:='M002';
          medicationame:='Antipsychotics';
          medicationdescription:='Medicine that reduces release of dopamine';
          WRITE(medicationfile,medication);

          medicationid:='M003';
          medicationame:='Prazosin';
          medicationdescription:='Helps reduces nightmares and improves sleep quality';
          WRITE(medicationfile,medication);
        END;
    END;

  PROCEDURE createpatientillnessfile;
    BEGIN
      WITH patientillness DO
        BEGIN
          nhsid:='N000';
          illnessid:='I001';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N001';
          illnessid:='I004';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N002';
          illnessid:='I002';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N003';
          illnessid:='I003';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N004';
          illnessid:='I005';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N005';
          illnessid:='I001';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N006';
          illnessid:='I005';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N007';
          illnessid:='I004';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N008';
          illnessid:='I002';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N009';
          illnessid:='I003';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N003';
          illnessid:='I001';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N004';
          illnessid:='I001';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N005';
          illnessid:='I002';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N006';
          illnessid:='I001';
          WRITE(patientillnessfile,patientillness);

          nhsid:='N007';
          illnessid:='I001';
          WRITE(patientillnessfile,patientillness);
        END;
    END;

  PROCEDURE createpatientmedication;
    BEGIN
      WITH patientmedication DO
        BEGIN
          nhsid:='N000';
          medicationid:='M003';
          medicationdosage:='4mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N001';
          medicationid:='M001';
          medicationdosage:='100mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N002';
          medicationid:='M001';
          medicationdosage:='95mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N002';
          medicationid:='M002';
          medicationdosage:='55mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N003';
          medicationid:='M002';
          medicationdosage:='50mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N004';
          medicationid:='M003';
          medicationdosage:='4mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N005';
          medicationid:='M003';
          medicationdosage:='4mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N006';
          medicationid:='M003';
          medicationdosage:='3.5mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N007';
          medicationid:='M001';
          medicationdosage:='105mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N008';
          medicationid:='M001';
          medicationdosage:='100mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N008';
          medicationid:='M002';
          medicationdosage:='52mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N009';
          medicationid:='M002';
          medicationdosage:='50mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N003';
          medicationid:='M003';
          medicationdosage:='4mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N005';
          medicationid:='M001';
          medicationdosage:='98mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N005';
          medicationid:='M002';
          medicationdosage:='53mg';
          WRITE(patientmedicationfile,patientmedication);

          nhsid:='N007';
          medicationid:='M003';
          medicationdosage:='3.5mg';
          WRITE(patientmedicationfile,patientmedication);
        END;
    END;

  PROCEDURE createmedicationillness;
    BEGIN
      WITH medicationillness DO
        BEGIN
          medicationid:='M001';
          illnessid:='I002';
          WRITE(medicationillnessfile,medicationillness);

          medicationid:='M001';
          illnessid:='I004';
          WRITE(medicationillnessfile,medicationillness);

          medicationid:='M002';
          illnessid:='I003';
          WRITE(medicationillnessfile,medicationillness);

          medicationid:='M002';
          illnessid:='I002';
          WRITE(medicationillnessfile,medicationillness);

          medicationid:='M003';
          illnessid:='I005';
          WRITE(medicationillnessfile,medicationillness);

          medicationid:='M003';
          illnessid:='I001';
          WRITE(medicationillnessfile,medicationillness);
        END;
    END;

  PROCEDURE createtimetablefile;
    BEGIN
      WITH timetable DO
        BEGIN
          date:=STRTODATE('01/01/1900');
          meetingtype:='P';
          starttime:=STRTOTIME('12:00');
          endtime:=STRTOTIME('13:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('06/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('15:30');
          endtime:=STRTOTIME('16:30');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('09/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('11:00');
          endtime:=STRTOTIME('12:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('10/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('08:00');
          endtime:=STRTOTIME('09:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('10/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('10:00');
          endtime:=STRTOTIME('11:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('10/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('12:05');
          endtime:=STRTOTIME('13:05');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('10/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('13:10');
          endtime:=STRTOTIME('14:10');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('10/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('15:15');
          endtime:=STRTOTIME('16:15');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('11/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('08:15');
          endtime:=STRTOTIME('09:15');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('11/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('15:00');
          endtime:=STRTOTIME('16:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('12/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('10:20');
          endtime:=STRTOTIME('11:20');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('12/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('12:25');
          endtime:=STRTOTIME('13:25');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('12/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('15:25');
          endtime:=STRTOTIME('16:25');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('13/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('09:30');
          endtime:=STRTOTIME('10:30');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('13/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('11:35');
          endtime:=STRTOTIME('12:35');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('13/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('13:40');
          endtime:=STRTOTIME('14:40');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('13/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('14:45');
          endtime:=STRTOTIME('15:45');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('16/06/2025');
          meetingtype:='P';
          starttime:=STRTOTIME('15:45');
          endtime:=STRTOTIME('16:45');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('18/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('08:00');
          endtime:=STRTOTIME('09:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('23/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('08:00');
          endtime:=STRTOTIME('09:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('23/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('10:05');
          endtime:=STRTOTIME('11:05');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('23/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('12:10');
          endtime:=STRTOTIME('13:10');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('23/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('14:20');
          endtime:=STRTOTIME('15:20');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('23/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('15:25');
          endtime:=STRTOTIME('16:25');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('24/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('08:00');
          endtime:=STRTOTIME('09:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('24/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('10:05');
          endtime:=STRTOTIME('11:05');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('24/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('16:15');
          endtime:=STRTOTIME('17:15');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('24/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('18:20');
          endtime:=STRTOTIME('19:20');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('25/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('08:00');
          endtime:=STRTOTIME('09:00');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('25/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('12:10');
          endtime:=STRTOTIME('13:10');
          WRITE(timetablefile,timetable);

          date:=STRTODATE('26/06/2025');
          meetingtype:='C';
          starttime:=STRTOTIME('15:30');
          endtime:=STRTOTIME('16:30');
          WRITE(timetablefile,timetable);
        END;
    END;

  PROCEDURE createemployeefile;
    BEGIN
      WITH employee DO
        BEGIN
          empid:='E000';
          forename:='Michael';
          surname:='Anderson';
          WRITE(employeefile,employee);

          empid:='E001';
          forename:='Jessica';
          surname:='Turner';
          WRITE(employeefile,employee);

          empid:='E002';
          forename:='David';
          surname:='Thompson';
          WRITE(employeefile,employee);

          empid:='E003';
          forename:='Sarah';
          surname:='Martinez';
          WRITE(employeefile,employee);

          empid:='E004';
          forename:='Robert';
          surname:='Johnson';
          WRITE(employeefile,employee);
        END;
    END;

  PROCEDURE createtimetableemployee;
    BEGIN
      WITH timetableemployee DO
        BEGIN
          date:=STRTODATE('18/06/2025');
          starttime:=STRTOTIME('08:00');
          empid:='E000';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('23/06/2025');
          starttime:=STRTOTIME('08:00');
          empid:='E001';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('23/06/2025');
          starttime:=STRTOTIME('10:05');
          empid:='E002';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('23/06/2025');
          starttime:=STRTOTIME('12:10');
          empid:='E003';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('23/06/2025');
          starttime:=STRTOTIME('14:20');
          empid:='E004';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('23/06/2025');
          starttime:=STRTOTIME('15:25');
          empid:='E001';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('23/06/2025');
          starttime:=STRTOTIME('15:25');
          empid:='E002';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('24/06/2025');
          starttime:=STRTOTIME('08:00');
          empid:='E004';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('24/06/2025');
          starttime:=STRTOTIME('10:05');
          empid:='E001';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('24/06/2025');
          starttime:=STRTOTIME('16:15');
          empid:='E002';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('24/06/2025');
          starttime:=STRTOTIME('18:20');
          empid:='E003';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('25/06/2025');
          starttime:=STRTOTIME('08:00');
          empid:='E003';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('25/06/2025');
          starttime:=STRTOTIME('08:00');
          empid:='E001';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('25/06/2025');
          starttime:=STRTOTIME('12:10');
          empid:='E004';
          WRITE(timetableemployeefile,timetableemployee);

          date:=STRTODATE('26/06/2025');
          starttime:=STRTOTIME('15:30');
          empid:='E002';
          WRITE(timetableemployeefile,timetableemployee);
        END;
    END;

  PROCEDURE createtimetablepatient;
    BEGIN
      WITH timetablepatient DO
        BEGIN
          date:=STRTODATE('06/06/2025');
          starttime:=STRTOTIME('15:30');
          nhsid:='N001';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('09/06/2025');
          starttime:=STRTOTIME('11:00');
          nhsid:='N000';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('10/06/2025');
          starttime:=STRTOTIME('08:00');
          nhsid:='N005';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('10/06/2025');
          starttime:=STRTOTIME('10:00');
          nhsid:='N001';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('10/06/2025');
          starttime:=STRTOTIME('12:05');
          nhsid:='N002';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('10/06/2025');
          starttime:=STRTOTIME('13:10');
          nhsid:='N003';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('10/06/2025');
          starttime:=STRTOTIME('15:15');
          nhsid:='N004';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('11/06/2025');
          starttime:=STRTOTIME('08:15');
          nhsid:='N006';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('11/06/2025');
          starttime:=STRTOTIME('15:00');
          nhsid:='N007';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('12/06/2025');
          starttime:=STRTOTIME('10:20');
          nhsid:='N008';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('12/06/2025');
          starttime:=STRTOTIME('12:25');
          nhsid:='N009';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('12/06/2025');
          starttime:=STRTOTIME('15:25');
          nhsid:='N000';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('12/06/2025');
          starttime:=STRTOTIME('15:25');
          nhsid:='N001';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('13/06/2025');
          starttime:=STRTOTIME('09:30');
          nhsid:='N002';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('13/06/2025');
          starttime:=STRTOTIME('11:35');
          nhsid:='N003';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('13/06/2025');
          starttime:=STRTOTIME('13:40');
          nhsid:='N004';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('13/06/2025');
          starttime:=STRTOTIME('14:45');
          nhsid:='N005';
          WRITE(timetablepatientfile,timetablepatient);

          date:=STRTODATE('16/06/2025');
          starttime:=STRTOTIME('15:45');
          nhsid:='N006';
          WRITE(timetablepatientfile,timetablepatient);
        END;
    END;

  PROCEDURE closefiles;
    BEGIN
      CLOSE(loginfile);
      CLOSE(patientfile);
      CLOSE(illnessfile);
      CLOSE(medicationfile);
      CLOSE(medicationillnessfile);
      CLOSE(patientmedicationfile);
      CLOSE(timetablefile);
      CLOSE(employeefile);
      CLOSE(timetableemployeefile);
      CLOSE(timetablepatientfile);
      CLOSE(patientillnessfile);
    END;

  BEGIN
    initialisefiles;
    createloginfile;
    createpatientfile;
    createillnessfile;
    createmedicationfile;
    createmedicationillness;
    createtimetablefile;
    createemployeefile;
    createtimetableemployee;
    createtimetablepatient;
    createpatientillnessfile;
    createpatientmedication;
    closefiles;
    READLN;
  END.









