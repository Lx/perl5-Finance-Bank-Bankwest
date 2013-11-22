package Finance::Bank::Bankwest::Parsers;
# ABSTRACT: feed HTTP responses to multiple parsers in succession

=for stopwords
parsers

=for Pod::Coverage
handler_namespace default_handlers default_exception

=head1 DESCRIPTION

This module provides a convenient means to apply several classes in the
C<Finance::Bank::Bankwest::Parser> namespace to an L<HTTP::Response> at
once in order to receive structured data from it, or have the most
appropriate exception thrown.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::BadResponse>
L<Finance::Bank::Bankwest::Session>
L<Finance::Bank::Bankwest::SessionFromLogin>
L<HTTP::Response::Switch>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireFinalReturn)
use MooseX::Declare 0.06; # for auto "strict" and "warnings"
use HTTP::Response::Switch 1.001000; # for exception class loading
class Finance::Bank::Bankwest::Parsers
    with HTTP::Response::Switch
{
    sub handler_namespace   { 'Finance::Bank::Bankwest::Parser' }
    sub default_handlers    { qw( Login ) }
    sub default_exception   { 'Finance::Bank::Bankwest::Error::BadResponse' }
}

__PACKAGE__->load_handlers;
1;
