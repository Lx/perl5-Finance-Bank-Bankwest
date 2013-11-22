package Finance::Bank::Bankwest::Error::NotLoggedIn::Timeout;
# ABSTRACT: Bankwest session timeout exception

=head1 DESCRIPTION

This exception may be thrown on calls to various methods of
L<Finance::Bank::Bankwest::Session> when the Bankwest Online Banking
session has been terminated due to inactivity.

At the time of writing, the remote server appears to terminate sessions
after 15 minutes of inactivity.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::NotLoggedIn>
L<Finance::Bank::Bankwest::Session>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare 0.06; # for auto "strict" and "warnings"
class Finance::Bank::Bankwest::Error::NotLoggedIn::Timeout
    extends Finance::Bank::Bankwest::Error::NotLoggedIn
{
    method MESSAGE {
        'the Bankwest Online Banking session has timed out '
            . 'due to inactivity'
    }
}
