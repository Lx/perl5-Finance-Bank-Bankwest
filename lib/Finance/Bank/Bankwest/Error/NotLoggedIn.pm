package Finance::Bank::Bankwest::Error::NotLoggedIn;
# ABSTRACT: non-existent session exception superclass

=head1 DESCRIPTION

A subclass of this exception is thrown when the server reports that a
Bankwest Online Banking session is not set up.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::SubsequentLogin>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::Timeout>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Error::NotLoggedIn
    extends Finance::Bank::Bankwest::Error
{
}
