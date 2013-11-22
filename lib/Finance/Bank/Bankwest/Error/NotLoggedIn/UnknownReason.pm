package Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason;
# ABSTRACT: general Bankwest session failure exception

=for stopwords
initialised

=head1 DESCRIPTION

This exception may be thrown on calls to
L<Finance::Bank::Bankwest/login> or various methods of
L<Finance::Bank::Bankwest::Session> when for an unanticipated reason, a
Bankwest Online Banking session cannot be initialised or has been
terminated.

This exception is likely to occur when a Personal Access Number (PAN)
has been suspended, or when Bankwest Online Banking is undergoing some
sort of maintenance (but still presenting a login form).

=attr response

An L<HTTP::Response> object holding the response causing the exception
to be thrown.  May be useful for diagnosing the cause of the problem.

This attribute is made available via
L<Finance::Bank::Bankwest::Error::WithResponse>.

=head1 SEE ALSO

L<Finance::Bank::Bankwest/login>
L<Finance::Bank::Bankwest::Error::NotLoggedIn>
L<Finance::Bank::Bankwest::Error::WithResponse>
L<Finance::Bank::Bankwest::Session>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare 0.06; # for auto "strict" and "warnings"
class Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason
    extends Finance::Bank::Bankwest::Error::NotLoggedIn
    with Finance::Bank::Bankwest::Error::WithResponse
{
    method MESSAGE {
        'a Bankwest Online Banking session cannot be established '
            . 'for an unknown reason'
    }
}
