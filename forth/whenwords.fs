\ whenwords.fs

\ --- Basic Helpers ---
-1 CONSTANT MY-TRUE
0 CONSTANT MY-FALSE
: -ROT ROT ROT ;
: MY-MOD 2DUP / * - ;
: MY-/MOD 2DUP / -ROT MY-MOD SWAP ;
: 2DROP DROP DROP ;
: 2DUP OVER OVER ;
: 2OVER 3 PICK 3 PICK ;
: 2SWAP ROT >R ROT R> ;
: MY-ABS DUP 0 < IF -1 * THEN ;
: MY-NEGATE -1 * ;
: NIP SWAP DROP ;
: TUCK SWAP OVER ;
: MY-LE ( n1 n2 -- b ) > 0= ;
: MY-GE ( n1 n2 -- b ) < 0= ;
: MY-NE ( n1 n2 -- b ) = 0= ;
: MY-WITHIN ( n low high -- b ) >R 2DUP MY-GE -ROT DROP R> < AND ;
: 2PICK 2 PICK ;
: 3PICK 3 PICK ;
: 4PICK 4 PICK ;
: 5PICK 5 PICK ;
: MY-STAR-SLASH ( n1 n2 n3 -- n4 ) >R * R> / ;
: MY-COMPARE COMPARE ;
: HALT BYE ;

\ --- Constants ---
60 CONSTANT MINUTE
3600 CONSTANT HOUR
86400 CONSTANT DAY
2592000 CONSTANT MONTH
31536000 CONSTANT YEAR

\ --- String Utilities ---
CREATE N-BUF 512 ALLOT
VARIABLE N-PTR
: N>S ( n -- addr len )
  DUP 0 = IF DROP S" 0" EXIT THEN
  DUP 0 < >R MY-ABS
  N-BUF 256 + N-PTR !
  BEGIN
    10 MY-/MOD ( rem quot )
    SWAP 48 + ( quot char )
    N-PTR @ 1- DUP N-PTR ! ( quot char ptr )
    SWAP OVER ( quot ptr char ptr )
    DROP ( quot ptr char )
    SWAP C! ( quot )
    DUP 0 =
  UNTIL
  DROP
  R> IF N-PTR @ 1- DUP N-PTR ! 45 SWAP C! THEN
  N-PTR @ N-BUF 256 + N-PTR @ -
;

\ --- String Builder ---
CREATE RES-BUF 8192 ALLOT
VARIABLE RES-PTR

: RES-RESET RES-BUF RES-PTR ! ;
: RES-APPEND ( addr len -- )
  DUP 0= IF 2DROP EXIT THEN
  RES-PTR @ SWAP 2DUP + RES-PTR ! MOVE ;
: S-APPEND RES-APPEND ;
: RES-GET ( -- addr len ) RES-BUF RES-PTR @ OVER - ;

: ADD-SPACE 32 RES-PTR @ C! 1 RES-PTR +! ;
: ADD-COMMA 44 RES-PTR @ C! 1 RES-PTR +! ;

\ --- Options ---
VARIABLE OPT-COMPACT
VARIABLE OPT-MAX-UNITS

: RESET-OPTIONS 0 OPT-COMPACT ! 0 OPT-MAX-UNITS ! ;

\ --- Date Logic ---
: IS-LEAP ( y -- b )
  DUP 4 MY-MOD 0 = IF
    DUP 100 MY-MOD 0 = IF
      400 MY-MOD 0 = IF MY-TRUE ELSE MY-FALSE THEN
    ELSE
      DROP MY-TRUE
    THEN
  ELSE
    DROP MY-FALSE
  THEN ;

: DAYS-IN-YEAR ( y -- n ) IS-LEAP IF 366 ELSE 365 THEN ;

: DAYS-IN-MONTH ( m y -- n )
  OVER 2 = IF
    NIP IS-LEAP IF 29 ELSE 28 THEN
  ELSE
    DROP ( y )
    DUP 4 = OVER 6 = OR OVER 9 = OR OVER 11 = OR IF
      DROP 30
    ELSE
      DROP 31
    THEN
  THEN ;

: MONTH-NAME ( m -- addr len )
  DUP 1 = IF DROP S" January" ELSE
  DUP 2 = IF DROP S" February" ELSE
  DUP 3 = IF DROP S" March" ELSE
  DUP 4 = IF DROP S" April" ELSE
  DUP 5 = IF DROP S" May" ELSE
  DUP 6 = IF DROP S" June" ELSE
  DUP 7 = IF DROP S" July" ELSE
  DUP 8 = IF DROP S" August" ELSE
  DUP 9 = IF DROP S" September" ELSE
  DUP 10 = IF DROP S" October" ELSE
  DUP 11 = IF DROP S" November" ELSE
  DUP 12 = IF DROP S" December" ELSE
  S" Unknown" ROT DROP THEN THEN THEN THEN THEN THEN THEN THEN THEN THEN THEN THEN ;

: WEEKDAY-NAME ( w -- addr len )
  DUP 0 = IF DROP S" Sunday" ELSE
  DUP 1 = IF DROP S" Monday" ELSE
  DUP 2 = IF DROP S" Tuesday" ELSE
  DUP 3 = IF DROP S" Wednesday" ELSE
  DUP 4 = IF DROP S" Thursday" ELSE
  DUP 5 = IF DROP S" Friday" ELSE
  DUP 6 = IF DROP S" Saturday" ELSE
  S" Unknown" ROT DROP THEN THEN THEN THEN THEN THEN THEN ;

: <> MY-NE ;
: >= MY-GE ;
: <= MY-LE ;

VARIABLE TMP-Y VARIABLE TMP-M VARIABLE TMP-D
: TIMESTAMP>YMD ( ts -- y m d )
  86400 / ( days )
  1970 TMP-Y !
  BEGIN
    DUP TMP-Y @ DAYS-IN-YEAR >=
  WHILE
    TMP-Y @ DAYS-IN-YEAR -
    1 TMP-Y +!
  REPEAT
  1+ ( doy )
  1 TMP-M !
  BEGIN
    DUP TMP-M @ TMP-Y @ DAYS-IN-MONTH >
  WHILE
    TMP-M @ TMP-Y @ DAYS-IN-MONTH -
    1 TMP-M +!
  REPEAT
  TMP-Y @ TMP-M @ ROT
;

: DAY-NUM ( ts -- n ) 86400 / ;
: TIMESTAMP>WD ( ts -- n ) 86400 / 4 + 7 MY-MOD ;

\ --- TIMEAGO Implementation ---
: ROUND-DIV ( n div -- n' )
  TUCK 2 / + SWAP /
;

: TIMEAGO ( ts ref -- addr len )
  RES-RESET
  2DUP = IF 2DROP S" just now" EXIT THEN
  2DUP < IF
    SWAP - ( past, ref-ts ) MY-FALSE
  ELSE
    - ( future, ts-ref ) MY-TRUE
  THEN ( diff future? )
  OVER 45 < IF 2DROP S" just now" EXIT THEN
  ( diff future? )
  TUCK IF S" in " S-APPEND THEN
  ( future? diff )
  DUP 90 < IF DROP S" 1 minute" S-APPEND
  ELSE DUP 2700 < IF 60 ROUND-DIV N>S S-APPEND S"  minutes" S-APPEND
  ELSE DUP 5400 < IF DROP S" 1 hour" S-APPEND
  ELSE DUP 79200 < IF 3600 ROUND-DIV N>S S-APPEND S"  hours" S-APPEND
  ELSE DUP 129600 < IF DROP S" 1 day" S-APPEND
  ELSE DUP 2246400 < IF 86400 ROUND-DIV N>S S-APPEND S"  days" S-APPEND
  ELSE DUP 3974400 < IF DROP S" 1 month" S-APPEND
  ELSE DUP 27648000 < IF 2630000 ROUND-DIV N>S S-APPEND S"  months" S-APPEND
  ELSE DUP 47347200 < IF DROP S" 1 year" S-APPEND
  ELSE 31536000 ROUND-DIV N>S S-APPEND S"  years" S-APPEND
  THEN THEN THEN THEN THEN THEN THEN THEN THEN
  
  ( future? )
  0= IF S"  ago" S-APPEND THEN
  RES-GET
;

\ --- DURATION Implementation ---
VARIABLE UNIT-COUNT
: ADD-UNIT ( val name-addr name-len compact-addr compact-len -- )
  4 PICK 0 <> IF
    UNIT-COUNT @ OPT-MAX-UNITS @ < IF
      OPT-COMPACT @ IF
        UNIT-COUNT @ 0 > IF ADD-SPACE THEN
        2SWAP 2DROP ( val compact-addr compact-len )
        ROT N>S S-APPEND S-APPEND
      ELSE
        UNIT-COUNT @ 0 > IF S" , " S-APPEND THEN
        2DROP ( val name-addr name-len )
        ROT DUP N>S S-APPEND ADD-SPACE
        -ROT ( val name-addr name-len )
        2PICK 1 = IF S-APPEND ELSE S-APPEND S" s" S-APPEND THEN
        DROP ( consume val )
      THEN
      1 UNIT-COUNT +!
    ELSE
      2DROP 2DROP DROP
    THEN
  ELSE
    2DROP 2DROP DROP
  THEN ;

: DURATION ( secs -- addr len )
  DUP 0 < IF 
    DROP S" ERROR" 
  ELSE
    DUP 0 = IF 
      DROP S" 0 seconds" OPT-COMPACT @ IF 2DROP S" 0s" THEN
    ELSE
      RES-RESET 0 UNIT-COUNT !
      OPT-MAX-UNITS @ 0= IF 2 OPT-MAX-UNITS ! THEN
      ( secs )
      DUP YEAR / DUP >R YEAR * - R> S" year" S" y" ADD-UNIT
      DUP MONTH / DUP >R MONTH * - R> S" month" S" mo" ADD-UNIT
      DUP DAY / DUP >R DAY * - R> S" day" S" d" ADD-UNIT
      DUP HOUR / DUP >R HOUR * - R> S" hour" S" h" ADD-UNIT
      DUP MINUTE / DUP >R MINUTE * - R> S" minute" S" m" ADD-UNIT
      ( secs_left ) S" second" S" s" ADD-UNIT
      RES-GET
    THEN
  THEN ;
\ --- PARSE-DURATION Implementation ---
VARIABLE P-TOTAL
VARIABLE P-NUM
VARIABLE P-SCALE
VARIABLE P-UNIT
VARIABLE P-ADDR
VARIABLE P-LEN

: IS-DIGIT ( c -- b ) 48 57 1+ MY-WITHIN ;
: TO-LOWER ( c -- c' ) DUP 65 90 1+ MY-WITHIN IF 32 + THEN ;
: P-PEEK ( -- c ) P-LEN @ 0= IF 0 ELSE P-ADDR @ C@ THEN ;
: P-SKIP ( -- ) P-LEN @ 0 > IF 1 P-ADDR +! -1 P-LEN +! THEN ;

: PARSE-DURATION ( addr len -- n )
  DUP 0= IF 2DROP -1 EXIT THEN
  P-LEN ! P-ADDR ! 0 P-TOTAL !
  
  BEGIN P-LEN @ 0 > WHILE
    P-PEEK 32 = P-PEEK 44 = OR P-PEEK 97 = OR P-PEEK 10 = OR P-PEEK 13 = OR IF P-SKIP 
    ELSE P-PEEK IS-DIGIT IF
      0 P-NUM ! 1 P-SCALE !
      BEGIN P-PEEK IS-DIGIT WHILE
        P-NUM @ 10 * P-PEEK 48 - + P-NUM ! P-SKIP
      REPEAT
      P-PEEK 46 = IF 
        P-SKIP 10 P-SCALE !
        P-PEEK IS-DIGIT IF P-NUM @ 10 * P-PEEK 48 - + P-NUM ! P-SKIP ELSE P-NUM @ 10 * P-NUM ! THEN
        BEGIN P-PEEK IS-DIGIT WHILE P-SKIP REPEAT
      THEN
      
      P-PEEK 58 = IF
        P-NUM @ 3600 * P-TOTAL @ + P-TOTAL ! 
        P-SKIP 0 P-NUM !
        BEGIN P-PEEK IS-DIGIT WHILE P-NUM @ 10 * P-PEEK 48 - + P-NUM ! P-SKIP REPEAT
        P-NUM @ 60 * P-TOTAL @ + P-TOTAL !
        P-PEEK 58 = IF
          P-SKIP 0 P-NUM !
          BEGIN P-PEEK IS-DIGIT WHILE P-NUM @ 10 * P-PEEK 48 - + P-NUM ! P-SKIP REPEAT
          P-NUM @ P-TOTAL @ + P-TOTAL !
        THEN
      ELSE
        BEGIN P-PEEK 32 = WHILE P-SKIP REPEAT
        0 P-UNIT !
        P-PEEK TO-LOWER
        DUP 119 = IF 604800 P-UNIT ! ELSE
        DUP 100 = IF 86400 P-UNIT ! ELSE
        DUP 104 = IF 3600 P-UNIT ! ELSE
        DUP 109 = IF 
          P-SKIP P-PEEK TO-LOWER 111 = IF 2592000 P-UNIT ! P-SKIP ELSE 60 P-UNIT ! THEN
        ELSE
        DUP 115 = IF 1 P-UNIT ! THEN
        THEN THEN THEN THEN
        DROP
        
        P-UNIT @ 0= IF -1 EXIT THEN
        BEGIN P-PEEK TO-LOWER 97 122 1+ MY-WITHIN WHILE P-SKIP REPEAT
        P-NUM @ P-UNIT @ P-SCALE @ MY-STAR-SLASH P-TOTAL @ + P-TOTAL !
      THEN
    ELSE
      P-PEEK TO-LOWER 97 122 1+ MY-WITHIN IF
        BEGIN P-PEEK TO-LOWER 97 122 1+ MY-WITHIN WHILE P-SKIP REPEAT
      ELSE
        -1 EXIT
      THEN
    THEN THEN
  REPEAT
  P-TOTAL @ 0 = IF -1 ELSE P-TOTAL @ THEN
;

\ --- HUMAN-DATE Implementation ---
VARIABLE HD-Y VARIABLE HD-M VARIABLE HD-D
VARIABLE HD-RY VARIABLE HD-RM VARIABLE HD-RD

: HUMAN-DATE ( ts ref -- addr len )
  RES-RESET
  2DUP DAY-NUM SWAP DAY-NUM - ( diff = ref_day - ts_day )
  DUP 0 = IF DROP S" Today" S-APPEND ELSE
  DUP 1 = IF DROP S" Yesterday" S-APPEND ELSE
  DUP -1 = IF DROP S" Tomorrow" S-APPEND ELSE
  DUP DUP 2 >= SWAP 6 <= AND IF
    DROP S" Last " S-APPEND 1 PICK TIMESTAMP>WD WEEKDAY-NAME S-APPEND ELSE
  DUP DUP -2 <= SWAP -6 >= AND IF
    DROP S" This " S-APPEND 1 PICK TIMESTAMP>WD WEEKDAY-NAME S-APPEND ELSE
    DROP ( diff )
    1 PICK TIMESTAMP>YMD HD-D ! HD-M ! HD-Y !
    0 PICK TIMESTAMP>YMD HD-RD ! HD-RM ! HD-RY !
    HD-Y @ HD-RY @ = IF
      HD-M @ MONTH-NAME S-APPEND ADD-SPACE HD-D @ N>S S-APPEND
    ELSE
      HD-M @ MONTH-NAME S-APPEND ADD-SPACE HD-D @ N>S S-APPEND
      S" , " S-APPEND HD-Y @ N>S S-APPEND
    THEN
  THEN THEN THEN THEN THEN
  2DROP RES-GET
;

\ --- DATE-RANGE Implementation ---
VARIABLE DR-Y1 VARIABLE DR-M1 VARIABLE DR-D1
VARIABLE DR-Y2 VARIABLE DR-M2 VARIABLE DR-D2

: DATE-RANGE ( s e -- addr len )
  RES-RESET
  2DUP > IF SWAP THEN ( s e )
  2DUP DAY-NUM SWAP DAY-NUM = IF
    1 PICK TIMESTAMP>YMD DR-D1 ! DR-M1 ! DR-Y1 !
    DR-M1 @ MONTH-NAME S-APPEND ADD-SPACE DR-D1 @ N>S S-APPEND
    S" , " S-APPEND DR-Y1 @ N>S S-APPEND
  ELSE
    0 PICK TIMESTAMP>YMD DR-D2 ! DR-M2 ! DR-Y2 !
    1 PICK TIMESTAMP>YMD DR-D1 ! DR-M1 ! DR-Y1 !
    
    DR-Y1 @ DR-Y2 @ = IF
      DR-M1 @ DR-M2 @ = IF
        DR-M1 @ MONTH-NAME S-APPEND ADD-SPACE
        DR-D1 @ N>S S-APPEND S" –" S-APPEND DR-D2 @ N>S S-APPEND
        S" , " S-APPEND DR-Y1 @ N>S S-APPEND
      ELSE
        DR-M1 @ MONTH-NAME S-APPEND ADD-SPACE
        DR-D1 @ N>S S-APPEND S"  – " S-APPEND
        DR-M2 @ MONTH-NAME S-APPEND ADD-SPACE
        DR-D2 @ N>S S-APPEND S" , " S-APPEND DR-Y2 @ N>S S-APPEND
      THEN
    ELSE
      DR-M1 @ MONTH-NAME S-APPEND ADD-SPACE
      DR-D1 @ N>S S-APPEND S" , " S-APPEND DR-Y1 @ N>S S-APPEND
      S"  – " S-APPEND
      DR-M2 @ MONTH-NAME S-APPEND ADD-SPACE
      DR-D2 @ N>S S-APPEND S" , " S-APPEND DR-Y2 @ N>S S-APPEND
    THEN
  THEN
  2DROP ( s e )
  RES-GET
;
