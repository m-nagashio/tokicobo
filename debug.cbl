       IDENTIFICATION  DIVISION.
       PROGRAM-ID.     HELLO.
       DATA            DIVISION.
       WORKING-STORAGE SECTION.
       01 INPUT_TEXT   PIC X(99).
       01 TALK_COUNT   PIC 9(1).
       01 OUTPUT_TEXT  PIC 9(1).
       PROCEDURE       DIVISION.
       MAIN-RTN.
           MOVE "好きだ" TO INPUT_TEXT.
           MOVE 1 TO TALK_COUNT.
           CALL "analysis" USING BY REFERENCE INPUT_TEXT
                                 BY VALUE TALK_COUNT
                           GIVING OUTPUT_TEXT.
           DISPLAY "RETURN-TEXT:" OUTPUT_TEXT.
       MAIN-EXT.
           STOP RUN.
