package Finance::Bank::Bankwest::Parsers;
# ABSTRACT: feed HTTP responses to multiple parsers in succession

=for stopwords
parsers recognises

=head1 DESCRIPTION

This module provides a convenient means to apply several
L<Finance::Bank::Bankwest::Parser>-consuming classes to an
L<HTTP::Response> at once in order to receive structured data from it,
or have the most appropriate exception thrown.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::BadResponse>
L<Finance::Bank::Bankwest::Parser>
L<Finance::Bank::Bankwest::Session>
L<Finance::Bank::Bankwest::SessionFromLogin>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Parsers {

    use Finance::Bank::Bankwest::Error::BadResponse ();
    use Module::Pluggable::Object ();
    use MooseX::StrictConstructor;
    use TryCatch; # for "try" and "catch"

    my $module_base = 'Finance::Bank::Bankwest::Parser';

    # Load all of the parser classes at compile time.
    {
        $_->plugins for Module::Pluggable::Object->new(
            search_path     => [$module_base],
            require         => 1,
        );
    }

=method test

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

=cut

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

=method parse

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

=cut

    method parse($class: $res, Str $parser, Str @testers) {
        try {
            return "${module_base}::$parser"->parse($res);
        }
        catch (Finance::Bank::Bankwest::Error::BadResponse $e) {
            return $class->test($res, @testers);
        }
    }
}
