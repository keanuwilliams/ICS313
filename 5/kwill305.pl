/********************************
* Name: Keanu Williams
* Date: November 8, 2019
* Course: ICS 313
* File: kwill305.pl
* Assignment: 5
********************************/

/*******************************************************************************/

/* listlength/2: Arg1 is a list, Arg2 is the length of the list */

listlength([], 0).
listlength([_|T], X) :-
  listlength(T, Y),
  X is Y + 1.

/*******************************************************************************/

/* Colored-Balls-In-A-Row Problems */

/* Situation #1
 * - You have six colored balls: 2 red, 2 orange and 2 purple.
 * - No balls of the same color may be adjacent to one another. */

/* Colors for Situation 1 */
color1(red).
color1(orange).
color1(purple).

/* Procedure for Situation 1 */
coloredballs1(List, X) :-
  permutation(List, X), /* permutation */
  listlength(X, 6), /* check if length is 6 */
  iscolor(X, 1), /* check if the colors match situation */
  countballs(X, red, 2), /* make sure there are two red balls */
  countballs(X, orange, 2), /* make sure there are two orange balls */
  countballs(X, purple, 2), /* make sure there are two purple balls */
  \+ adjacent(X, red), /* make sure red balls arent adjacent */
  \+ adjacent(X, orange), /* make sure orange balls arent adjacent */
  \+ adjacent(X, purple). /* make sure purple balls arent adjacent */

/*******************************************************************************/

/* Situation #2
 * - You have six colored balls: 4 green, 1 white and 1 orange.
 * - There are no more than 2 green balls in a row. */

/* Colors for Situation 2 */
color2(green).
color2(orange).
color2(white).

/* Procedure for Situation 2 */
coloredballs2(List, X) :-
  permutation(List, X), /* permutation */
  listlength(X, 6), /* checks if length is 6 */
  iscolor(X, 2), /* check if the colors match situation */
  countballs(X, green, 4), /* make sure there are four green balls */
  countballs(X, orange, 1), /* make sure there are one orange ball */
  countballs(X, white, 1), /* make sure there are one white ball */
  \+ adjacent2(X, green). /* make sure no more than two green balls in a row */

/*******************************************************************************/

 /* Situation #3
  * - You have eight colored balls: 1 green, 2 black, 2 white and 3 red.
  * - The balls in positions 2 and 3 are not red.
  * - The balls in positions 4 and 8 are the same color.
  * - The balls in positions 1 and 7 are of different colors.
  * - There is a red ball to the left of every white ball.
  * - A black ball is neither first nor last.
  * - The balls in positions 6 and 7 are not white */

/* Colors for Situation 3 */
color3(green).
color3(black).
color3(white).
color3(red).

/* Procedure for Situation 3 */
coloredballs3(List, X) :-
  permutation(List, X), /* permutation */
  listlength(X, 8), /* check if length is 8 */
  iscolor(X, 3), /* check if the colors match situation */
  countballs(X, green, 1), /* make sure there is one green ball */
  countballs(X, black, 2), /* make sure there are two black balls */
  countballs(X, white, 2), /* make sure there are two white balls */
  countballs(X, red, 3), /* make sure there are three red balls */
  coloredballs3positions(X). /* Follows position guidelines for Situation 3 */

/* Helper for Situation 3 */
/* Possible positions for each color:
 * Red: 1 4 7 8
 * Black: 2 3 4 5 6 7
 * Green: 1 2 3 4 5 6 7 8
 * White: 1 2 5 */
coloredballs3positions([Pos1, Pos2, Pos3, Pos4, Pos5, Pos6, Pos7, Pos8]) :-
  Pos2 \= red, /* The balls in positions 2 and 3 are not red */
  Pos3 \= red,
  Pos3 \= white, /* There is a red ball to the left of every white ball */
  Pos4 \= white,
  Pos5 \= red,
  Pos6 \= red,
  ( Pos2 == white ->
    Pos1 = red
  ; Pos5 == white ->
    Pos4 = red
  ),
  Pos4 = Pos8, /* The balls in position 4 and 8 are the same color */
  Pos1 \= Pos7, /* The balls in position 1 and 7 are different colors */
  Pos1 \= black, /* A black ball is neither first nor last */
  Pos8 \= black,
  Pos6 \= white, /* The balls in positions 6 and 7 are not white */
  Pos7 \= white.


/*******************************************************************************/

/* split3/2: Arg1 is a positive integer N, Arg2 is a list of positive integers */
/* Returns true if the list can be partitioned into three sublists, such that
 * the sum of the integers in each subset is less than or equal to N. */

/* Procedure for split3 */
split3(N, L) :-
  ispositive([N]),
  ispositive(L),
  listlength(L, Length),
  Length >= 3,
  initialsplit(N, L).

/* Helper Functions for split3 */
/* Begin by splitting list into three sublists (in order) */
initialsplit(N, [First,Second|T]) :-
  split3split(N, [First], [Second], T), !.

/* Base Case for split3split to check all sublists */
split3split(N, SL1, SL2, SL3) :-
  split3check(N, SL1),
  split3check(N, SL2),
  split3check(N, SL3).

/* Split the lists (with elements in the same order) */
split3split(N, SL1, SL2, [SL3H|SL3T]) :-
  myappend(SL2, [SL3H], NSL2),
  split3split(N, SL1, NSL2, SL3T).

split3split(N, SL1, [SL2H|SL2T], SL3) :-
  myappend(SL1, [SL2H], NSL1),
  split3split(N, NSL1, SL2T, SL3).

/* Check given cases */
split3check(N, SL) :-
  listnotempty(SL),
  checksum(N, SL).

/*******************************************************************************/

/* EXTRA FUNCTIONS */

/* Function to check if list is empty */
listnotempty(List) :-
  listlength(List, X),
  X > 0.

/* Function that checks if sum of list is less than or equal to N */
checksum(N, List) :-
  sumup(List, X),
  N >= X.

/* Function to check if all numbers in list are positive. */
ispositive([]).
ispositive([H|T]) :-
  H >= 0,
  ispositive(T).

/* Function to check if the amount of balls match for that color */
countballs([], _, 0).
countballs([H|T], X, N) :-
  ( H == X ->
    countballs(T, X, M),
    N is M + 1
  ; countballs(T, X, N)
  ).

/* Function to check if the color matches the situation */
iscolor([], _).
iscolor([H|T], Situation) :-
  ( Situation == 1 ->
    color1(H),
    iscolor(T, 1)
  ; Situation == 2 ->
    color2(H),
    iscolor(T, 2)
  ; Situation == 3 ->
    color3(H),
    iscolor(T, 3)
  ).

/* Function to check if an there are 2 of the same element in a row in a list */
adjacent([X,X|_], X).
adjacent([_|T], X) :-
  adjacent(T, X).

/* Function to check if there are no more than 2 of the same element in a row in a list*/
adjacent2([X,X,X|_], X).
adjacent2([_|T], X) :-
  adjacent2(T, X).

/* From RecursionExamples.pl on Laulima */
sumup([], 0).
sumup([H|T], X) :-
  sumup(T, Y),
  X is H + Y.

myappend([], L, L).
myappend([H|T], A, [H|A1]) :-
  myappend(T, A, A1).

/* From https://stackoverflow.com/questions/9134380/how-to-access-list-permutations-in-prolog */
takeout(X, [X|R], R).
takeout(X, [F|R], [F|S]) :-
  takeout(X, R, S).

permutation([], []).
permutation([X|Y], Z) :-
  permutation(Y, W),
  takeout(X, Z, W).

/*******************************************************************************/
