package Finance::Bank::Bankwest::Error::ServiceMessage;
# ABSTRACT: service message intercept exception

=head1 DESCRIPTION

This exception may be thrown (but internally caught) on calls to
L<Finance::Bank::Bankwest/login> (or more specifically,
L<Finance::Bank::Bankwest::SessionFromLogin/session>) if the Bankwest
Online Banking server presents a "service message" page after logging
in.

This exception should never propagate outside this distribution.

=attr response

An L<HTTP::Response> object holding the response causing the exception
to be thrown.  May be useful for diagnostic purposes.

This attribute is made available via
L<Finance::Bank::Bankwest::Error::WithResponse>.

=head1 SEE ALSO

L<Finance::Bank::Bankwest/login>
L<Finance::Bank::Bankwest::Error>
L<Finance::Bank::Bankwest::Error::WithResponse>
L<Finance::Bank::Bankwest::SessionFromLogin/session>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Error::ServiceMessage
    extends Finance::Bank::Bankwest::Error
    with Finance::Bank::Bankwest::Error::WithResponse
{
    method MESSAGE {
        'the Bankwest Online Banking server presented a service '
            . 'message page'
    }
}
