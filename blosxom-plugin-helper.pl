#!/usr/local/bin/perl

# blosxom-plugin-helper.pl v1.1
#
# Copyright (c) 2005 Kyo Nagashima <kyo\@hail2u.net>, http://hail2u.net/
#
# This script is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

use strict;

# --- Configurable variables -----------

my $author = 'John Doe <john.d@example.com>, http://example.com/';

# --------------------------------------

my $plugin_name = shift;

if (!$plugin_name or $plugin_name eq '--help') {
  print <<"_DATA_";

blosxom-plugin-helper.pl v1.0
Copyright (c) 2005 Kyo Nagashima <kyo\@hail2u.net>, http://hail2u.net/

Usage: blosxom-plugin-helper.pl [<plugin_name> | --help]
_DATA_
  exit;
}

my($yr, $mo, $da) = &get_date();

my $template = <<"_TMPL_";
# Blosxom Plugin: $plugin_name
# Author(s): $author
# Version: $yr-$mo-$da
# Documentation: See the bottom of this file or type: perldoc $plugin_name

package $plugin_name;

use strict;

# --- Configurable variables -----------

# --- Plug-in package variables --------

# --------------------------------------

sub start {
  return 1;
}

sub template {
  return sub {
    my(\$path, \$chunk, \$flavour) = \@_;

    return join '', (\$blosxom::template{\$flavour}{\$chunk} || \$blosxom::template{error}{\$chunk} || '');
  };
}

sub entries {
  return sub {
    my(\%files, \%indexes, \%others);

    return (\\\%files, \\\%indexes, \\\$others);
  };
}

sub filter {
  my(\$pkg, \$files_ref, \$others_ref) = \@_;

  return 1;
}

sub skip {
  return 0;
}

sub interpolate {
  return sub {
    package blosxom;
    my \$template = shift;

    return \$template;
  };
}

sub head {
  my(\$pkg, \$path, \$head_ref) = \@_;

  return 1;
}

sub sort {
  return sub {
    my(\$files_ref) = \@_;

    return keys \%\$files_ref;
  };
}

sub date {
  my(\$pkg, \$path, \$date_ref, \$mtime, \$dw, \$mo, \$mo_num, \$da, \$ti, \$yr) = \@_;

  return 1;
}

sub story {
  my(\$pkg, \$path, \$fn, \$story_ref, \$title_ref, \$body_ref) = \@_;

  return 1;
}

sub foot {
  my(\$pkg, \$path, \$foot_ref) = \@_;

  return 1;
}

sub end {
  return 1;
}

sub last {
  return 1;
}

1;

__END__

=head1 NAME

Blosxom Plug-in: $plugin_name

=head1 SYNOPSIS


=head1 VERSION

$yr-$mo-$da

=head1 AUTHOR

$author

=head1 INSTALLATION

Drop $plugin_name into your plugins directory.

=head1 CONFIGURATION


=head1 REQUIREMENTS


=head1 SEE ALSO

=over

=item Blosxom Home/Docs/Licensing

http://www.blosxom.com/

=item Blosxom Plugin Docs

http://www.blosxom.com/documentation/users/plugins.html

=back

=head1 BUGS

Address bug reports and comments to:

=over

=item blosxom ML

http://groups.yahoo.com/group/blosxom/

=item all about blosxom ML

http://www.freeml.com/info/blosxom@freeml.com

=back

all about blosxom ML: http://www.freeml.com/info/blosxom\@freeml.com

=head1 LICENSE

Copyright $yr, $author

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
_TMPL_

open(FH, "> $plugin_name") or die "$!";
print FH $template;
close(FH);

exit;

sub get_date {
  my ($ss, $nn, $hh, $dd, $mm, $yy, $ww) = localtime(time);
  $yy = $yy + 1900;
  $mm = sprintf "%02d", ++$mm;
  $dd = sprintf "%02d", $dd;

  return($yy, $mm, $dd);
}
