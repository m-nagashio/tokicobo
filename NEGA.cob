       IDENTIFICATION    DIVISION.
       PROGRAM-ID.       NEGA.
       ENVIRONMENT       DIVISION.
       INPUT-OUTPUT      SECTION.
       FILE-CONTROL.
           SELECT  F1  ASSIGN  TO  "NEGA_ART.txt".
           SELECT  F2  ASSIGN  TO  "NEGA_MSG.txt".
      *
       DATA                  DIVISION.
       FILE                  SECTION.
       FD  F1.
       01  F1R.
           03  F1-REC.
             05  F1-FLG      PIC 9(001).
             05  F1-REC1     PIC X(080).
             05  FILLER      PIC X(002).
      *
       FD  F2.
       01  F2R.
           03  F2-REC.
             05  F2-FLG      PIC 9(001).
             05  F2-REC1     PIC X(120).
             05  FILLER      PIC X(002).
      *
       WORKING-STORAGE       SECTION.
       01  WORK.
         03  F1-END          PIC X(01).
         03  F2-END          PIC X(01).
         03  WAITO           PIC X(01).
      *
       LINKAGE               SECTION.
       01  PARA.
         03  PARA-STORY      PIC 9(01).
         03  PARA-NEXT       PIC 9(01).
      *
       PROCEDURE             DIVISION  USING  PARA.
      *
       000-START         SECTION.
      *     display "NEGA" PARA-STORY.
           PERFORM  100-INIT  THRU  100-END.
      *
           PERFORM  200-MAIN1 THRU  200-END
               UNTIL F1-END = HIGH-VALUE.
           ACCEPT WAITO FROM CONSOLE.
      *
           PERFORM  210-MAIN2 THRU  210-END
               UNTIL F2-END = HIGH-VALUE.
      *
           PERFORM  300-CLOSE THRU  300-END.
           EXIT PROGRAM.
       000-END.
           EXIT.
      *
       100-INIT          SECTION.
           INITIALIZE WORK.
           OPEN  INPUT  F1 F2.
           PERFORM 220-READ   THRU  220-END.
           PERFORM 230-READ   THRU  230-END.
           MOVE  ZERO         TO    PARA-NEXT.
       100-END.
           EXIT.
      *
       200-MAIN1         SECTION.
           IF  F1-FLG       =     PARA-STORY
               DISPLAY F1-REC1
           END-IF.
           PERFORM 220-READ   THRU  220-END.
       200-END.
           EXIT.
      *
       210-MAIN2         SECTION.
           IF  F2-FLG       =     PARA-STORY
               DISPLAY F2-REC1
           END-IF.
           PERFORM 230-READ   THRU  230-END.
       210-END.
           EXIT.
      *
       220-READ          SECTION.
           READ F1
           AT END
               MOVE HIGH-VALUE TO F1-END
           END-READ.
       220-END.
           EXIT.
      *
       230-READ          SECTION.
           READ F2
           AT END
               MOVE HIGH-VALUE TO F2-END
           END-READ.
       230-END.
           EXIT.
      *
       300-CLOSE         SECTION.
           CLOSE  F1 F2.
       300-END.
           EXIT.
