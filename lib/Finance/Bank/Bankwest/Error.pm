package Finance::Bank::Bankwest::Error;
# ABSTRACT: Finance-Bank-Bankwest error superclass

=head1 DESCRIPTION

All exceptions thrown by the Finance-Bank-Bankwest distribution are
parented by this class.  It allows the user to easily identify an error
as belonging to this distribution without caring about specifics:

    use TryCatch; # for "try" and "catch"
    try {
        $session->logout;
    }
    catch (Finance::Bank::Bankwest::Error $e) {
        warn "logout failed, but don't care";
    }

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::BadResponse>
L<Finance::Bank::Bankwest::Error::ExportFailed>
L<Finance::Bank::Bankwest::Error::NotLoggedIn>
L<Throwable::Error>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare 0.35; # the only working version for Travis CI
use Throwable::Error 0.101110; # for bug fix
class Finance::Bank::Bankwest::Error
    extends Throwable::Error
{
    use MooseX::StrictConstructor 0.13; # no exports; oldest by Travis CI

=method MESSAGE

Defined in subclasses that are directly instantiated, and called if the
exception is being stringified.  Prepares and returns a textual
representation of the error message, accessible via the C<message>
attribute (see L<Throwable::Error/message>).

=cut

    has '+message' => (
        builder => 'MESSAGE',
        lazy    => 1,
    );
}
