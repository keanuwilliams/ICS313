/********************************
* Name: Keanu Williams
* Date: November 29, 2019
* Course: ICS 313
* File: kwill306.pl
* Assignment: 6
********************************/

/* TOP/1: ARG1 is a sentence represented as a list of atoms
(e.g. [is, it, true, that, mark, hamill, acts, in, star, wars, iv]).
TOP/1 will succeed or fail. Either way, it should write out a sensible answer. */

top(Sentence) :-
  yesno(Query, Sentence, []),
  showresults(Query), !.

top(Sentence) :-
  what(What, Sentence, []),
  format("The title of the movie is ~w", [What]), !.

top(Sentence) :-
  !, who(Who, Sentence, []),
  format("The person you're looking for is ~w", [Who]).

top(_) :- write("Sorry, I do not understand."), !.

/* SHOWRESULTS/1 writes out positive text if ARG1 is a list of true predicates, negative text otherwise. */
showresults(Query) :-
  test(Query),
  write("Yes, that's true.").

showresults(_) :-
  write("Sorry, that's false.").

/* TEST/1 takes a list of predicates, and succeeds if all the predicates are true, otherwise fails. */
test([Query]) :-
  Query.

test([Query|Rest]):-
  Query,
  test(Rest).

/*** DCG ***/
who(X) --> [who], verb_phrase(X^_^[Query], no), {Query}.
who(X) --> [who], verb_phrase(_^director^_, no), [of], proper_noun(PrNoun), {directed(X, PrNoun)}.
who(X) --> [who], verb_phrase(_^actor^_, no), [for], proper_noun(PrNoun), {play(X, PrNoun)}.
who(X) --> [who], verb_phrase(_^character^_, no), [of], proper_noun(PrNoun), {play(PrNoun, X)}.

what(X) --> [what], verb_phrase(_^title^_, no), [of], proper_noun(PrNoun), {title_of(PrNoun, X)}.
what(X) --> [what], verb_phrase(_^title^_, no), [for], proper_noun(PrNoun), {title_of(PrNoun, X)}.

yesno(Sem) --> [is, it, true, that], statement(_^_^Sem, no).
yesno(Sem) --> [did], statement(_^_^Sem, did).
yesno(Sem) --> statement(_^_^Sem, no), [right].

statement(S, Did) --> singlestatement(S, Did).
statement(_^_^Sem, Did) --> singlestatement(Subj^_^Sem, Did), [in], noun_phrase(PrNoun), {acts_in(Subj, PrNoun)}.
statement(_^_^Sem, Did) --> singlestatement(_^_^S1, Did), statement(_^_^S2, Did), {append(S1,S2,Sem)}.
statement(_^_^Sem, Did) --> singlestatement(_^_^S1, Did), [and], statement(_^_^S2, Did), {append(S1,S2,Sem)}.

singlestatement(Subj^Obj^Sem, Did) --> noun_phrase(Subj), verb_phrase(Subj^Obj^Sem, Did).

noun_phrase(Sem) --> proper_noun(Sem).
noun_phrase(Sem) --> [a], noun(Sem, consonant).
noun_phrase(Sem) --> [an], noun(Sem, vowel).
noun_phrase(Sem) --> [the], noun(Sem, _).

verb_phrase(Subj^Obj^Sem, Did) --> verb(Subj^Obj^Sem, Did), noun_phrase(Obj).

/** PROPER NOUNS **/
proper_noun(mark_hamill) --> [mark, hamill].
proper_noun(harrison_ford) --> [harrison, ford].
proper_noun(carrie_fisher) --> [carrie, fisher].
proper_noun(ewan_mcgregor) --> [ewan, mcgregor].
proper_noun(natalie_portman) --> [natalie, portman].
proper_noun(hayden_christensen) --> [hayden, christensen].
proper_noun(liam_neeson) --> [liam, neeson].
proper_noun(jake_lloyd) --> [jake, lloyd].
proper_noun(ian_mcdiarmid) --> [ian, mcdiarmid].
proper_noun(alec_guinness) --> [alec, guinness].
proper_noun(sam_jackson) --> [samuel, l, jackson].
proper_noun(sam_jackson) --> [samuel, jackson].
proper_noun(sam_jackson) --> [sam, jackson].
proper_noun(frank_oz) --> [frank, oz].
proper_noun(anthony_daniels) --> [anthony, daniels].
proper_noun(kenny_baker) --> [kenny, baker].
proper_noun(peter_mayhew) --> [peter, mayhew].
proper_noun(david_prowse) --> [david, prowse].
proper_noun(billy_williams) --> [billy, dee, williams].
proper_noun(billy_williams) --> [billy, williams].
proper_noun(luke_skywalker) --> [luke, skywalker].
proper_noun(dobbu_scay) --> [dobbu, scay].
proper_noun(han_solo) --> [han_solo].
proper_noun(leia_organa) --> [leia, organa].
proper_noun(obiwan_kenobi) --> [obi-wan, kenobi].
proper_noun(padme) --> [padme].
proper_noun(queen_amidala) --> [queen, amidala].
proper_noun(palpatine) --> [palpatine].
proper_noun(anakin_skywalker) --> [anakin, skywalker].
proper_noun(yoda) --> [yoda].
proper_noun(chewbacca) --> [chewbacca].
proper_noun(r2d2) --> [r2d2].
proper_noun(c3pO) --> [c3pO].
proper_noun(darth_vader) --> [darth, vader].
proper_noun(mace_windu) --> [mace, windu].
proper_noun(the_emperor) --> [the, emperor].
proper_noun(lando_calrissian) --> [lando, calrissian].
proper_noun(james_jones) --> [james, earl, jones].
proper_noun(james_jones) --> [james, jones].
proper_noun(george_lucas) --> [george, lucas].
proper_noun(irvin_kershner) --> [irvin, kershner].
proper_noun(richard_marquand) --> [richard, marquand].
proper_noun(robert_wise) --> [robert, wise].
proper_noun(nicholas_meyer) --> [nicholas, meyer].
proper_noun(leonard_nimoy) --> [leonard, nimoy].
proper_noun(william_shatner) --> [william, shatner].
proper_noun(deforest_kelley) --> [deforest, kelley].
proper_noun(james_doohan) --> [james, doohan].
proper_noun(george_takei) --> [george, takei].
proper_noun(james_kirk) --> [captain, james, t, kirk].
proper_noun(james_kirk) --> [captain, james, kirk].
proper_noun(james_kirk) --> [james, t, kirk].
proper_noun(james_kirk) --> [james, kirk].
proper_noun(spock) --> [spock].
proper_noun(dr_mccoy) --> [doctor, mccoy].
proper_noun(dr_mccoy) --> [dr, mccoy].
proper_noun(scotty) --> [scotty].
proper_noun(sulu) --> [sulu].
proper_noun(star_wars1) --> [star, wars, i].
proper_noun(star_wars2) --> [star, wars, ii].
proper_noun(star_wars3) --> [star, wars, iii].
proper_noun(star_wars4) --> [star, wars, iv].
proper_noun(star_wars5) --> [star, wars, v].
proper_noun(star_wars6) --> [star, wars, vi].
proper_noun(star_trek1) --> [star, trek, i].
proper_noun(star_trek2) --> [star, trek, ii].
proper_noun(star_trek3) --> [star, trek, iii].
proper_noun(the_phantom_menace) --> [the, phantom, menace].
proper_noun(attack_of_the_clones) --> [attack, of, the, clones].
proper_noun(revenge_of_the_sith) --> [revenge, of, the, sith].
proper_noun(a_new_hope) --> [a, new, hope].
proper_noun(the_empire_strikes_back) --> [the, empire, strikes, back].
proper_noun(return_of_the_jedi) --> [return, of, the, jedi].
proper_noun(the_motion_picture) --> [the, motion, picture].
proper_noun(the_wrath_of_khan) --> [the, wrath, of, khan].
proper_noun(the_search_for_spock) --> [the, search, for, spock].

/** NOUNS **/
noun(actor, vowel) --> [actor].
noun(director, consonant) --> [director].
noun(title, consonant) --> [title].
noun(character, consonant) --> [character].

/** VERBS **/
verb(X^Y^[play(X,Y)], did) --> [play].
verb(X^Y^[directed(X,Y)], did) --> [direct].
verb(X^Y^[acts_in(X,Y)], no) --> [acts, in].
verb(X^Y^[play(X,Y)], no) --> [plays].
verb(X^Y^[directed(X,Y)], no) --> [directs].
verb(X^actor^[actor(X)], no) --> [is].
verb(X^director^[director(X)], no) --> [is].
verb(X^character^[character(X)], no) --> [is].
verb(X^title^[title(X)], no) --> [is].

/*** DATABASE ***/

/** MOVIE TITLES **/
title(the_phantom_menace).
title(attack_of_the_clones).
title(revenge_of_the_sith).
title(a_new_hope).
title(the_empire_strikes_back).
title(return_of_the_jedi).
title(the_motion_picture).
title(the_wrath_of_khan).
title(the_search_for_spock).

title_of(star_wars1, the_phantom_menace).
title_of(star_wars2, attack_of_the_clones).
title_of(star_wars3, revenge_of_the_sith).
title_of(star_wars4, a_new_hope).
title_of(star_wars5, the_empire_strikes_back).
title_of(star_wars6, return_of_the_jedi).
title_of(star_trek1, the_motion_picture).
title_of(star_trek2, the_wrath_of_khan).
title_of(star_trek3, the_search_for_spock).

/** DIRECTORS **/
director(george_lucas).
director(irvin_kershner).
director(richard_marquand).
director(nicholas_meyer).
director(robert_wise).
director(leonard_nimoy).

directed(george_lucas, star_wars1).
directed(george_lucas, star_wars2).
directed(george_lucas, star_wars3).
directed(george_lucas, star_wars4).
directed(irvin_kershner, star_wars5).
directed(richard_marquand, star_wars6).
directed(robert_wise, star_trek1).
directed(nicholas_meyer, star_trek2).
directed(leonard_nimoy, star_trek3).

/** ACTORS **/
actor(mark_hamill).
actor(harrison_ford).
actor(carrie_fisher).
actor(ewan_mcgregor).
actor(natalie_portman).
actor(hayden_christensen).
actor(liam_neeson).
actor(jake_lloyd).
actor(ian_mcdiarmid).
actor(sam_jackson).
actor(frank_oz).
actor(kenny_baker).
actor(anthony_daniels).
actor(peter_mayhew).
actor(alec_guinness).
actor(david_prowse).
actor(billy_williams).
actor(james_jones).
actor(leonard_nimoy).
actor(william_shatner).
actor(deforest_kelley).
actor(james_doohan).
actor(george_takei).

/* CHARACTERS */

character(luke_skywalker).
character(dobbu_scay).
character(leia_organa).
character(han_solo).
character(obiwan_kenobi).
character(padme).
character(queen_amidala).
character(anakin_skywalker).
character(palpatine).
character(the_emperor).
character(mace_windu).
character(yoda).
character(r2d2).
character(c3pO).
character(chewbacca).
character(darth_vader).
character(lando_calrissian).
character(james_kirk).
character(spock).
character(dr_mccoy).
character(scotty).
character(sulu).

/** ACTORS PLAYED AS **/
play(mark_hamill, luke_skywalker).
play(mark_hamill, dobbu_scay).
play(carrie_fisher, leia_organa).
play(harrison_ford, han_solo).
play(ewan_mcgregor, obiwan_kenobi).
play(alec_guinness, obiwan_kenobi).
play(natalie_portman, padme).
play(natalie_portman, queen_amidala).
play(hayden_christensen, anakin_skywalker).
play(jake_lloyd, anakin_skywalker).
play(ian_mcdiarmid, palpatine).
play(ian_mcdiarmid, the_emperor).
play(sam_jackson, mace_windu).
play(frank_oz, yoda).
play(kenny_baker, r2d2).
play(anthony_daniels, c3pO).
play(peter_mayhew, chewbacca).
play(david_prowse, darth_vader).
play(james_jones, darth_vader).
play(billy_williams, lando_calrissian).
play(william_shatner, james_kirk).
play(leonard_nimoy, spock).
play(deforest_kelley, dr_mccoy).
play(james_doohan, scotty).
play(george_takei, sulu).

/** MOVIES ACTED IN/DIRECTED IN **/

/* Star Wars: Episode I - The Phantom Menace */
acts_in(natalie_portman, star_wars1).
acts_in(ewan_mcgregor, star_wars1).
acts_in(liam_neeson, star_wars1).
acts_in(jake_lloyd, star_wars1).
acts_in(ian_mcdiarmid, star_wars1).
acts_in(kenny_baker, star_wars1).
acts_in(frank_oz, star_wars1).
acts_in(anthony_daniels, star_wars1).

/* Star Wars: Episode II - Attack of the Clones */
acts_in(natalie_portman, star_wars2).
acts_in(ewan_mcgregor, star_wars2).
acts_in(hayden_christensen, star_wars2).
acts_in(ian_mcdiarmid, star_wars2).
acts_in(sam_jackson, star_wars2).
acts_in(kenny_baker, star_wars2).
acts_in(frank_oz, star_wars2).
acts_in(anthony_daniels, star_wars2).

/* Star Wars: Episode III - Revenge of the Sith */
acts_in(ewan_mcgregor, star_wars3).
acts_in(natalie_portman, star_wars3).
acts_in(hayden_christensen, star_wars3).
acts_in(ian_mcdiarmid, star_wars3).
acts_in(sam_jackson, star_wars3).
acts_in(peter_mayhew, star_wars3).
acts_in(frank_oz, star_wars3).
acts_in(kenny_baker, star_wars3).
acts_in(anthony_daniels, star_wars3).

/* Star Wars: Episode IV - A New Hope */
acts_in(mark_hamill, star_wars4).
acts_in(harrison_ford, star_wars4).
acts_in(carrie_fisher, star_wars4).
acts_in(alec_guinness, star_wars4).
acts_in(peter_mayhew, star_wars4).
acts_in(kenny_baker, star_wars4).
acts_in(anthony_daniels, star_wars4).
acts_in(david_prowse, star_wars4).
acts_in(james_jones, star_wars4).

/* Star Wars: Episode V - The Empire Strikes Back */
acts_in(mark_hamill, star_wars5).
acts_in(harrison_ford, star_wars5).
acts_in(carrie_fisher, star_wars5).
acts_in(alec_guinness, star_wars5).
acts_in(peter_mayhew, star_wars5).
acts_in(frank_oz, star_wars5).
acts_in(kenny_baker, star_wars5).
acts_in(anthony_daniels, star_wars5).
acts_in(david_prowse, star_wars5).
acts_in(james_jones, star_wars5).
acts_in(billy_williams, star_wars5).

/* Star Wars: Episode VI - Return of the Jedi */
acts_in(mark_hamill, star_wars6).
acts_in(harrison_ford, star_wars6).
acts_in(carrie_fisher, star_wars6).
acts_in(alec_guinness, star_wars6).
acts_in(peter_mayhew, star_wars6).
acts_in(frank_oz, star_wars6).
acts_in(kenny_baker, star_wars6).
acts_in(anthony_daniels, star_wars6).
acts_in(ian_mcdiarmid, star_wars6).
acts_in(david_prowse, star_wars6).
acts_in(james_jones, star_wars6).
acts_in(billy_williams, star_wars6).

/* Star Trek: The Motion Picture */
acts_in(william_shatner, star_trek1).
acts_in(leonard_nimoy, star_trek1).
acts_in(deforest_kelley, star_trek1).
acts_in(james_doohan, star_trek1).
acts_in(george_takei, star_trek1).

/* Star Trek II: The Wrath of Khan */
acts_in(william_shatner, star_trek2).
acts_in(leonard_nimoy, star_trek2).
acts_in(deforest_kelley, star_trek2).
acts_in(james_doohan, star_trek2).
acts_in(george_takei, star_trek2).

/* Star Trek III: The Search for Spock */
acts_in(william_shatner, star_trek3).
acts_in(leonard_nimoy, star_trek3).
acts_in(deforest_kelley, star_trek3).
acts_in(james_doohan, star_trek3).
acts_in(george_takei, star_trek3).
