package File::Name::Check;

use strict;
use warnings;

use 5.008_005;
our $VERSION = '0.09';

use File::Spec;
use Encode::Locale;
use Encode;

sub new {
  my $class = shift;
  # uncoverable condition false
  bless @_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}, ref $class || $class;
}

# paranoic = caseunique + safechars
sub paranoic {
    my $self = shift;
    my $path = shift;

    return ($self->safechars($path) && $self->caseunique($path,@_) ) ;
}

# matches qr/^[0-9a-zA-Z_.-]+$/
# these chars are also URI-safe
sub safechars {
    my $self = shift;
    my $path = shift;
    my ( $volume, $directories, $file ) = File::Spec->splitpath($path);
    return ( $file =~ m/^[0-9a-zA-Z_.-]+$/ );
}

# can use locale encoding
sub locale {
    my $self = shift;
    my $path = shift;

    my $encoding = $Encode::Locale::ENCODING_LOCALE_FS;
    return $self->encoded( $path, $encoding );
}

sub encoded {
    my $self = shift;
    my $path = shift;
    my $encoding = shift;
    my ( $volume, $directories, $file ) = File::Spec->splitpath($path);
    return $self->_reencode( $file, $encoding );
}

# unique under case-insensitive
sub caseunique {
    my $self = shift;
    my $path = shift;
    my @names = @_;

    my ( $volume, $directories, $file ) = File::Spec->splitpath($path);
    my $dir = File::Spec->catpath( $volume, $directories );

    my @files;
    if  (@names) {
       @files = grep{ m/^${file}$/i } @names;
    }
    else {
      opendir(my $dir_handle, $dir);
      @files = grep{ m/^${file}$/i } readdir($dir_handle);
      closedir($dir_handle);
    }

    return 1 if ( scalar @files == 1 );
}

sub _reencode {
    my $self = shift;
    my ( $bytes, $encoding) = @_;
    no warnings 'utf8';
    if ( $bytes ne encode( $encoding, decode( $encoding, $bytes ) ) ) {
        # say '*** decoded: ', decode( $encoding, $bytes );
        # say '     quoted: ', decode( $encoding, $bytes, Encode::FB_PERLQQ );
        return 0;
    }
    else { return 1; }
}

1;

__END__

=encoding utf-8

=head1 NAME

File::Name::Check - Check file names

=begin html

<a href="https://travis-ci.org/wollmers/File-Name-Check"><img src="https://travis-ci.org/wollmers/File-Name-Check.png" alt="File-Name-Check"></a>
<a href='https://coveralls.io/r/wollmers/File-Name-Check?branch=master'><img src='https://coveralls.io/repos/wollmers/File-Name-Check/badge.png?branch=master' alt='Coverage Status' /></a>
<a href='http://cpants.cpanauthors.org/dist/File-Name-Check'><img src='http://cpants.cpanauthors.org/dist/File-Name-Check.png' alt='Kwalitee Score' /></a>
<a href="http://badge.fury.io/pl/File-Name-Check"><img src="https://badge.fury.io/pl/File-Name-Check.svg" alt="CPAN version" height="18"></a>

=end html

=head1 SYNOPSIS

  use File::Name::Check;

=head1 DESCRIPTION

File::Name::Check is a collection of utilities to check against restrictions of some environments.

=head2 CONSTRUCTOR

=over 4

=item new()

Creates a new object

=back

=head2 METHODS

=over 4

=item caseunique

=item encoded

=item locale

=item paranoic

=item safechars

=back


=head1 AUTHOR

Helmut Wollmersdorfer E<lt>helmut.wollmersdorfer@gmx.atE<gt>

=head1 COPYRIGHT

Copyright 2014- Helmut Wollmersdorfer

=begin html

<a href='http://cpants.cpanauthors.org/author/wollmers'><img src='http://cpants.cpanauthors.org/author/wollmers.png' alt='Kwalitee Score' /></a>

=end html

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

