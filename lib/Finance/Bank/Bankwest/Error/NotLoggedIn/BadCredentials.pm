package Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials;
# ABSTRACT: invalid PAN/access code combination exception

=head1 DESCRIPTION

This exception may be thrown on calls to
L<Finance::Bank::Bankwest/login> (or more specifically,
L<Finance::Bank::Bankwest::SessionFromLogin/session>) when the Bankwest
Online Banking server rejects the Personal Access Number (PAN)/access
code combination supplied to it.

=head1 SEE ALSO

L<Finance::Bank::Bankwest/login>
L<Finance::Bank::Bankwest::Error::NotLoggedIn>
L<Finance::Bank::Bankwest::SessionFromLogin/session>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare 0.06; # for auto "strict" and "warnings"
class Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials
    extends Finance::Bank::Bankwest::Error::NotLoggedIn
{
    method MESSAGE {
        'could not log into Bankwest Online Banking; '
            . 'invalid PAN/access code combination'
    }
}
