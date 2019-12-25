#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Author: Keanu Williams
# Class: ICS313
# Assignment: 7
# Date: December 13, 2019
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

use strict;
use warnings;

my $DEBUG = 0;

if ($#ARGV != 1) {
  print "ERROR: incorrect format.\nFORMAT: perl kwill307.pl <HTML Filename> <type of content>\n";
}
else {
  if ($DEBUG == 1) {
    print "-----DEBUG-----\n";
    print "**\$ARGV[0] => $ARGV[0]\n";
    print "**\$ARGV[1] => $ARGV[1]\n";
  }

  # store command-line arguments
  my $html_filename = $ARGV[0];
  my $type = lc $ARGV[1];

  # open html file typed in command-line for reading
  open(my $html_fh, '<', "IMDb_Webpages/$html_filename") or die "Could not open file $html_filename $!";
  my $html_file = do {local $/; <$html_fh> };

  # user typed in film
  if ($type eq "film") {
    (my $title) = $html_file =~ /<h1 class="">(.*?)&nbsp.*<\/h1>/sg;
    (my $director) = $html_file =~ /<h4 class="inline">Director:<\/h4>\s*<a.*?>(.*?)<\/a>/sg;
    (my @actors) = $html_file =~ /<td>\s*<a href="\/name\/.*?\n>\s(.*?)\s*<\/a>\s*<\/td>/sg;
    (my @characters) = $html_file =~ /<td class="character">\s*?<a href=.*?\/characters\/.*?>(.*?)<\/a>/sg;
    (my @actor_characters) = $html_file =~ /<td>\s*<a href="\/name\/.*?\n>\s(.*?)\s*<\/a>\s*<\/td>.*?<td class="character">\s*?<a href=.*?\/characters\/.*?>(.*?)<\/a>/sg;
    if ($DEBUG == 1) {
      print "**TITLE => $title\n";
      print "**DIRECTOR => $director\n";
      print "**ACTORS =>\n";
      foreach (@actors) {
        print "-$_\n";
      }
      print "**CHARACTERS =>\n";
      foreach (@characters) {
        print "-$_\n";
      }
      print "**ACTOR_CHARACTERS =>\n";
      for(my $i = 0; $i < scalar @actor_characters; $i++) {
        print "\$$i => $actor_characters[$i]\n";
      }
    }
    # push files to database
    (my $db_filename) = $html_filename =~ /(.*)\.(?:htm|html)$/sg;
    $db_filename = "$db_filename.pl";
    if ($DEBUG == 1) {
      print "**DB_FILENAME => $db_filename\n";
    }
    # open database file with same name as html for writing
    open(my $db_fh, ">", "Databases/Films/$db_filename") or die "Could not open file $db_filename $!";
    print "Updating $db_filename...";
    print $db_fh "/*** FILE: $db_filename ***/\n\n";
    print $db_fh "/** DATABASE **/\n\n";

    print $db_fh "/* TITLE */\n";
    my @split_title = split(//, $title);
    my $mov_title;
    foreach(@split_title) {
      if ($_ =~ /[a-zA-Z]/) {
        $mov_title .= lc $_;
      }
      elsif($_ =~ /\-/) {
        last;
      }
      elsif ($_ =~ /\s/) {
        $mov_title .= '_';
      }
    }
    # remove the whitespace at the end if it exists
    if (substr($mov_title, -1) eq "_") {
      $mov_title = substr($mov_title, 0, (length $mov_title) - 1);
    }
    if ($DEBUG == 1) {
      print "\n**\$MOV_TITLE => $mov_title\n";
    }
    $mov_title =~ s/_episode_//;
    $mov_title =~ s/ix/9/;
    $mov_title =~ s/viii/8/;
    $mov_title =~ s/vii/7/;
    $mov_title =~ s/vi/6/;
    $mov_title =~ s/iv/4/;
    $mov_title =~ s/iii/3/;
    $mov_title =~ s/ii/2/;
    $mov_title =~ s/v/5/;
    $mov_title =~ s/i/1/;

    print $db_fh "title($mov_title).\n\n";

    my @split_director = split(//, $director);
    my $mov_director;
    foreach(@split_director) {
      if ($_ =~ /[a-zA-Z]/) {
        $mov_director .= lc $_;
      }
      elsif ($_ =~ /\s/) {
        $mov_director .= '_';
      }
    }
    print $db_fh "/* DIRECTOR */\n";
    print $db_fh "director($mov_director).\n\n";
    print $db_fh "/* DIRECTED */\n";
    print $db_fh "directed($mov_director, $mov_title).\n\n";

    print $db_fh "/* ACTORS */\n";
    foreach(@actors) {
      my @split_actor = split(//, $_);
      my $mov_actor;
      foreach(@split_actor) {
        if ($_ =~ /[a-zA-Z]/) {
          $mov_actor .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_actor .= '_';
        }
      }
      print $db_fh "actor($mov_actor).\n"
    }

    print $db_fh "\n/* ACTS IN */\n";
    foreach(@actors) {
      my @split_actor = split(//, $_);
      my $mov_actor;
      foreach(@split_actor) {
        if ($_ =~ /[a-zA-Z]/) {
          $mov_actor .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_actor .= '_';
        }
      }
      print $db_fh "acts_in($mov_actor, $mov_title).\n"
    }

    print $db_fh "\n/* PLAYS */\n";
      for(my $i = 0; $i < scalar @actor_characters; $i++) {
      my @split_actor = split(//, $actor_characters[$i]); $i++;
      my @split_character = split(//, $actor_characters[$i]);
      my $mov_actor; my $mov_character;
      foreach(@split_actor) {
        if ($_ =~ /[a-zA-Z]/) {
          $mov_actor .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_actor .= '_';
        }
      }
      foreach(@split_character) {
        if ($_ =~ /\w/) {
          $mov_character .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_character .= '_';
        }
      }
      print $db_fh "plays($mov_actor, $mov_character).\n"
    }

    print $db_fh "\n/* CHARACTERS */\n";
    foreach(@characters) {
      my @split_character = split(//, $_);
      my $mov_character;
      foreach(@split_character) {
        if ($_ =~ /\w/) {
          $mov_character .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_character .= '_';
        }
      }
      print $db_fh "character($mov_character).\n"
    }

    close $db_fh;
    print "Done\n";
  }
  # user typed in director
  elsif ($type eq "director") {
    (my $director) = $html_file =~ /<meta property=['|"]og:title['|"] content=['|"](.*?) - IMDb['|"]\s*\/>/sg;
    (my @films) = $html_file =~ /id="director.*?href="\/title\/.*?>(.*?)<\/a>/sg;
    if ($DEBUG == 1) {
      print "**DIRECTOR => $director\n";
      print "**FILMS =>\n";
      foreach(@films) {
        print "-$_\n";
      }
    }
    # push files to database
    (my $db_filename) = $html_filename =~ /(.*)\.(?:htm|html)$/sg;
    $db_filename = "$db_filename.pl";
    if ($DEBUG == 1) {
      print "**DB_FILENAME => $db_filename\n";
    }
    # open database file with same name as html for writing
    open(my $db_fh, ">", "Databases/Directors/$db_filename") or die "Could not open file $db_filename $!";
    print "Updating $db_filename...";
    print $db_fh "/*** FILE: $db_filename ***/\n\n";
    print $db_fh "/** DATABASE **/\n\n";

    print $db_fh "/* DIRECTOR */\n";
    my @split_director = split(//, $director);
    my $mov_director;
    foreach(@split_director) {
      if ($_ =~ /[a-zA-Z]/) {
        $mov_director .= lc $_;
      }
      elsif ($_ =~ /\s/) {
        $mov_director .= '_';
      }
    }
    print $db_fh "director($mov_director).\n\n";

    print $db_fh "/* DIRECTED */\n";
    foreach(@films) {
      my @split_title = split(//, $_);
      my $mov_title;
      foreach(@split_title) {
        if ($_ =~ /\w/) {
          $mov_title .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_title .= '_';
        }
      }
      $mov_title =~ s/_episode_//;
      if ($mov_title =~ /^\d*$/) {
        $mov_title = "mov_$mov_title";
      }
      if ($mov_title =~ /star_warsix.*?$/)  {
        $mov_title =~ s//star_wars9/;
      }
      elsif ($mov_title =~ /star_warsviii.*?$/)  {
        $mov_title =~ s//star_wars8/;
      }
      elsif ($mov_title =~ /star_warsvii.*?$/)  {
        $mov_title =~ s//star_wars7/;
      }
      elsif ($mov_title =~ /star_warsvi.*?$/)  {
        $mov_title =~ s//star_wars6/;
      }
      elsif ($mov_title =~ /star_warsiv.*?$/)  {
        $mov_title =~ s//star_wars4/;
      }
      elsif ($mov_title =~ /star_warsiii.*?$/)  {
        $mov_title =~ s//star_wars3/;
      }
      elsif ($mov_title =~ /star_warsii.*?$/)  {
        $mov_title =~ s//star_wars2/;
      }
      elsif ($mov_title =~ /star_warsv.*?$/)  {
        $mov_title =~ s//star_wars5/;
      }
      elsif ($mov_title =~ /star_warsi.*?$/)  {
        $mov_title =~ s//star_wars1/;
      }

      print $db_fh "directed($mov_director, $mov_title).\n"
    }

    close $db_fh;
    print "Done\n";
  }
  # user typed in actor
  elsif ($type eq "actor") {
    (my $actor) = $html_file =~ /<title>(.*?)<\/title>/sg;
    (my @movies) = $html_file =~ /<b><a href="\/title\/.*?>(.*?)<\/a>/sg;
    (my @characters) = $html_file =~ /<b><a href="\/title\/.*?\(.*?\).*?<br\/>\n(.*?)\n.*?<\/div>/sg;
    if ($DEBUG == 1) {
      print "**ACTOR => $actor\n";
      print "**FILMS =>\n";
      foreach(@movies) {
        print "-$_\n";
      }
      print "**CHARACTERS =>\n";
      foreach(@characters) {
        print "-$_\n";
      }
    }

    # push files to database
    (my $db_filename) = $html_filename =~ /(.*)\.(?:htm|html)$/sg;
    $db_filename = "$db_filename.pl";
    if ($DEBUG == 1) {
      print "**DB_FILENAME => $db_filename\n";
    }
    # open database file with same name as html for writing
    open(my $db_fh, ">", "Databases/Actors/$db_filename") or die "Could not open file $db_filename $!";
    print "Updating $db_filename...";
    print $db_fh "/*** FILE: $db_filename ***/\n\n";
    print $db_fh "/** DATABASE **/\n\n";

    print $db_fh "/* ACTOR */\n";
    my @split_actor = split(//, $actor);
    my $mov_actor;
    foreach(@split_actor) {
      if ($_ =~ /[a-zA-Z]/) {
        $mov_actor .= lc $_;
      }
      elsif($_ =~ /-/) {
        last;
      }
      elsif ($_ =~ /\s/) {
        $mov_actor .= '_';
      }
    }
    if (substr($mov_actor, -1) eq "_") {
      $mov_actor = substr($mov_actor, 0, (length $mov_actor) - 1);
    }
    print $db_fh "actor($mov_actor).\n\n";

    print $db_fh "/* ACTS IN */\n";
    foreach(@movies) {
      my @split_title = split(//, $_);
      my $mov_title;
      foreach(@split_title) {
        if ($_ =~ /\w/) {
          $mov_title .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_title .= '_';
        }
      }
      print $db_fh "acts_in($mov_actor, $mov_title).\n"
    }

    print $db_fh "\n/* FILMS */\n";
    foreach (@movies) {
      my @split_title = split(//, $_);
      my $mov_title;
      foreach(@split_title) {
        if ($_ =~ /\w/) {
          $mov_title .= lc $_;
        }
        elsif ($_ =~ /\s/) {
          $mov_title .= '_';
        }
      }
      print $db_fh "title($mov_title).\n"
    }

    print $db_fh "\n/* CHARACTERS */\n";
    foreach (@characters) {
      if (!($_ =~ /^<\/?div.*?$/)) {
        my @split_character = split(//, $_);
        my $mov_character;
        foreach(@split_character) {
          if ($_ =~ /\w/) {
            $mov_character .= lc $_;
          }
          elsif ($_ =~ /\s/) {
            $mov_character .= '_';
          }
        }
        print $db_fh "character($mov_character).\n"
      }
    }

    print $db_fh "\n/* PLAYS */\n";
    foreach (@characters) {
      if (!($_ =~ /^<\/?div.*?$/)) {
        my @split_character = split(//, $_);
        my $mov_character;
        foreach(@split_character) {
          if ($_ =~ /\w/) {
            $mov_character .= lc $_;
          }
          elsif ($_ =~ /\s/) {
            $mov_character .= '_';
          }
        }
        print $db_fh "plays($mov_actor, $mov_character).\n"
      }
    }

    close $db_fh;
    print "Done\n";
  }
  # user typed in invalid type
  else {
    print "ERROR: incorrect type of content. Available types of content are film, actor, or director.\n";
  }

  close $html_fh;
}
