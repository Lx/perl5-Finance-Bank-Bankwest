package Finance::Bank::Bankwest::Parsers;
{
  $Finance::Bank::Bankwest::Parsers::VERSION = '1.2.1';
}
# ABSTRACT: feed HTTP responses to multiple parsers in succession


## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Parsers {

    use Finance::Bank::Bankwest::Error::BadResponse ();
    use Module::Pluggable::Object ();
    use MooseX::StrictConstructor; # no exports
    use TryCatch; # for "try" and "catch"

    my $module_base = 'Finance::Bank::Bankwest::Parser';

    # Load all of the parser classes at compile time.
    {
        $_->plugins for Module::Pluggable::Object->new(
            search_path     => [$module_base],
            require         => 1,
        );
    }


    method test($class: $res, Str @testers) {
        for my $tester (@testers) {
            try {
                return "${module_base}::$tester"->test($res);
            }
            catch (Finance::Bank::Bankwest::Error::BadResponse $e) {
                # This parser doesn't recognise the response.
                # Try the next one.
            }
        }
        # None of the parsers recognised the response.
        Finance::Bank::Bankwest::Error::BadResponse->throw($res);
    }


    method parse($class: $res, Str $parser, Str @testers) {
        try {
            return "${module_base}::$parser"->parse($res);
        }
        catch (Finance::Bank::Bankwest::Error::BadResponse $e) {
            return $class->test($res, @testers);
        }
    }
}

__END__

=pod

=for :stopwords Alex Peters parsers recognises

=head1 NAME

Finance::Bank::Bankwest::Parsers - feed HTTP responses to multiple parsers in succession

=head1 VERSION

This module is part of distribution Finance-Bank-Bankwest v1.2.1.

This distribution's version numbering follows the conventions defined at L<semver.org|http://semver.org/>.

=head1 DESCRIPTION

This module provides a convenient means to apply several
L<Finance::Bank::Bankwest::Parser>-consuming classes to an
L<HTTP::Response> at once in order to receive structured data from it,
or have the most appropriate exception thrown.

=head1 METHODS

=head2 test

    Finance::Bank::Bankwest::Parsers->test(
        $http_response,
        qw{ ParserA ParserB ... },
    );

Instruct C<Finance::Bank::Bankwest::Parser::ParserA> to inspect the
supplied L<HTTP::Response> object, returning if that parser recognises
the response and deems it acceptable.

If not, and that parser doesn't emit a specific exception, repeat for
C<Finance::Bank::Bankwest::Parser::ParserB> and then any other parsers
supplied.

If no parsers emit a specific exception, throw a
L<Finance::Bank::Bankwest::Error::BadResponse> exception directly.

=head2 parse

    return Finance::Bank::Bankwest::Parsers->parse(
        $http_response,
        qw{ ParserA ParserB ... },
    );

Instruct C<Finance::Bank::Bankwest::Parser::ParserA> to inspect the
supplied L<HTTP::Response> object, returning structured data if that
parser recognises the response and deems it acceptable.

If not, and that parser doesn't emit a specific exception, pass the
response, C<Finance::Bank::Bankwest::Parser::ParserB> and any other
parsers to the L</test> method so that a specific exception may be
thrown.

=head1 SEE ALSO



=over 4

=item *

L<Finance::Bank::Bankwest::Error::BadResponse>

=item *

L<Finance::Bank::Bankwest::Parser>

=item *

L<Finance::Bank::Bankwest::Session>

=item *

L<Finance::Bank::Bankwest::SessionFromLogin>

=back

=head1 AUTHOR

Alex Peters <lxp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Alex Peters.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

The full text of the license can be found in the
'LICENSE' file included with this distribution.

=cut
