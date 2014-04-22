    {
        no warnings 'File::Find';
        find( \&wanted, @dirs );

        sub wanted {
            if ( $File::Find::name =~ m/^${file}$/i ) {
                my $name = $File::Find::name;
                push @files, $File::Find::name;
            }
        }
    }
    

# NAME

File::Name::Check - Check file names

# SYNOPSIS

    use File::Name::Check;

# DESCRIPTION

File::Name::Check is a collection of utilities to check against restrictions of some environments.

# AUTHOR

Helmut Wollmersdorfer <helmut.wollmersdorfer@gmx.at>

# COPYRIGHT

Copyright 2014- Helmut Wollmersdorfer

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

# POD ERRORS

Hey! __The above document had some coding errors, which are explained below:__

- Around line 3:

    Unknown directive: =comment
