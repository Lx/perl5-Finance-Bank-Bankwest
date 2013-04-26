package Finance::Bank::Bankwest::Error::BadResponse;
# ABSTRACT: unexpected remote server response exception

=head1 DESCRIPTION

This exception may be thrown by L<Finance::Bank::Bankwest::Parsers> (or
a L<Finance::Bank::Bankwest::Parser>-consuming class) when the Bankwest
Online Banking server returns a response that is not expected.

This may be due to the remote server being down, some sort of
temporary pop-up being implemented (like an ad), or a change to
the structure of the web interface.

=attr response

An L<HTTP::Response> object holding the response causing the exception
to be thrown.  May be useful for diagnosing the cause of the problem.

This attribute is made available via
L<Finance::Bank::Bankwest::Error::WithResponse>.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error>
L<Finance::Bank::Bankwest::Error::WithResponse>
L<Finance::Bank::Bankwest::Parser>
L<Finance::Bank::Bankwest::Parsers>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Error::BadResponse
    extends Finance::Bank::Bankwest::Error
    with Finance::Bank::Bankwest::Error::WithResponse
{
    method MESSAGE {
        'the Bankwest Online Banking server returned an unexpected response'
    }
}
