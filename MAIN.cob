       IDENTIFICATION    DIVISION.
       PROGRAM-ID.       MAIN.
       ENVIRONMENT       DIVISION.
       INPUT-OUTPUT      SECTION.
       FILE-CONTROL.
           SELECT  F1  ASSIGN  TO  "MAIN1.txt".
           SELECT  F2  ASSIGN  TO  "MAIN2.txt".
           SELECT  F3  ASSIGN  TO  "MAIN3.txt".
           SELECT  F4  ASSIGN  TO  "HAPPY END.txt".
           SELECT  F5  ASSIGN  TO  "BAD END.txt".
       DATA                  DIVISION.
       FILE                  SECTION.
       FD  F1.
       01  F1R.
           03  F1-REC.
             05  F1-REC1     PIC X(120).
             05  FILLER      PIC X(02).
      *
       FD  F2.
       01  F2R.
           03  F2-REC.
             05  F2-REC1     PIC X(120).
             05  FILLER      PIC X(02).
      *
       FD  F3.
       01  F3R.
           03  F3-REC.
             05  F3-REC1     PIC X(120).
             05  FILLER      PIC X(02).
      *
       FD  F4.
       01  F4R.
           03  F4-REC.
             05  F4-REC1     PIC X(120).
             05  FILLER      PIC X(02).
      *
       FD  F5.
       01  F5R.
           03  F5-REC.
             05  F5-REC1     PIC X(120).
             05  FILLER      PIC X(02).
      *
       WORKING-STORAGE       SECTION.
       01  WORK.
         03  F1-END          PIC X(01).
         03  F2-END          PIC X(01).
         03  F3-END          PIC X(01).
         03  F4-END          PIC X(01).
         03  F5-END          PIC X(01).
         03  PARA.
           05  PARA-STORY    PIC 9(01).
           05  PARA-NEXT     PIC 9(01).
         03  WAITO           PIC X(01).
      *
       PROCEDURE         DIVISION.
      *
       000-START         SECTION.
      *     display "MAIN".
           PERFORM  100-INIT  THRU  100-END.
      *
           PERFORM  200-MAIN  THRU  200-END
               UNTIL F1-END = HIGH-VALUE.
      *
           ACCEPT WAITO FROM CONSOLE.
           PERFORM  210-MAIN  THRU  210-END
               UNTIL F2-END = HIGH-VALUE.
      *
           ACCEPT WAITO FROM CONSOLE.
           PERFORM  220-MAIN  THRU  220-END
               UNTIL F3-END = HIGH-VALUE.
      *
           MOVE  1            TO    PARA-STORY.
           MOVE  1            TO    PARA-NEXT.
           PERFORM  400-STORY THRU  400-END
               UNTIL PARA-NEXT = "0".
      *
           PERFORM  500-CLOSE THRU  500-END.
           STOP RUN.
       000-END.
           EXIT.
      *
       100-INIT          SECTION.
           INITIALIZE WORK.
           OPEN  INPUT  F1 F2 F3 F4 F5.
           PERFORM 300-READ   THRU  300-END.
           PERFORM 310-READ   THRU  310-END.
           PERFORM 320-READ   THRU  320-END.
           PERFORM 330-READ   THRU  330-END.
           PERFORM 330-READ   THRU  340-END.
       100-END.
           EXIT.
      *
       200-MAIN          SECTION.
           DISPLAY F1-REC1.
           PERFORM 300-READ   THRU  300-END.
       200-END.
           EXIT.
      *
       210-MAIN          SECTION.
           DISPLAY F2-REC1.
           PERFORM 310-READ   THRU  310-END.
       210-END.
           EXIT.
      *
       220-MAIN          SECTION.
           DISPLAY F3-REC1.
           PERFORM 320-READ   THRU  320-END.
       220-END.
           EXIT.
      *
       230-MAIN          SECTION.
           DISPLAY F4-REC1.
           PERFORM 330-READ   THRU  330-END.
       230-END.
           EXIT.
      *
       240-MAIN          SECTION.
           DISPLAY F5-REC1.
           PERFORM 340-READ   THRU  340-END.
       240-END.
           EXIT.
      *
       300-READ          SECTION.
           READ F1
           AT END
               MOVE HIGH-VALUE TO F1-END
           END-READ.
       300-END.
           EXIT.
      *
       310-READ          SECTION.
           READ F2
           AT END
               MOVE HIGH-VALUE TO F2-END
           END-READ.
       310-END.
           EXIT.
      *
       320-READ          SECTION.
           READ F3
           AT END
               MOVE HIGH-VALUE TO F3-END
           END-READ.
       320-END.
           EXIT.
      *
       330-READ          SECTION.
           READ F4
           AT END
               MOVE HIGH-VALUE TO F4-END
           END-READ.
       330-END.
           EXIT.
      *
       340-READ          SECTION.
           READ F5
           AT END
               MOVE HIGH-VALUE TO F5-END
           END-READ.
       340-END.
           EXIT.
      *
       400-STORY         SECTION.
           ACCEPT WAITO FROM CONSOLE.
           CALL  "STORY"   USING  PARA.
           IF  PARA-NEXT   =      "1"
           THEN
               IF  PARA-STORY  NOT =  3
                   ADD  1      TO     PARA-STORY
               ELSE
                   ACCEPT WAITO FROM CONSOLE
                   PERFORM  230-MAIN  THRU  230-END
                       UNTIL F4-END = HIGH-VALUE
                   MOVE ZERO   TO     PARA-NEXT
               END-IF
           ELSE
               ACCEPT WAITO FROM CONSOLE
               PERFORM  240-MAIN  THRU  240-END
                   UNTIL F5-END = HIGH-VALUE
           END-IF.
       400-END.
           EXIT.
      *
       500-CLOSE         SECTION.
           CLOSE  F1 F2 F3 F4 F5.
       500-END.
           EXIT.
