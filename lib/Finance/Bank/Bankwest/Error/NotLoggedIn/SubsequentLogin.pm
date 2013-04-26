package Finance::Bank::Bankwest::Error::NotLoggedIn::SubsequentLogin;
# ABSTRACT: Bankwest session multiple login exception

=head1 DESCRIPTION

This exception may be thrown on calls to various methods of
L<Finance::Bank::Bankwest::Session> when the Bankwest Online Banking
session has been terminated due to another session being established
with the same credentials.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::NotLoggedIn>
L<Finance::Bank::Bankwest::Session>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Error::NotLoggedIn::SubsequentLogin
    extends Finance::Bank::Bankwest::Error::NotLoggedIn
{
    method MESSAGE {
        'the Bankwest Online Banking session has been terminated '
            . 'due to a subsequent login'
    }
}
