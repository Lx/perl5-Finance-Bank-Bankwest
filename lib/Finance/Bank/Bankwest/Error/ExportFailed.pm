package Finance::Bank::Bankwest::Error::ExportFailed;
# ABSTRACT: transaction CSV export failure exception

=for stopwords
CSV params

=head1 DESCRIPTION

This exception is thrown when the Bankwest Online Banking server
rejects the information supplied to
L<Finance::Bank::Bankwest::Session/transactions>.

In cases where the reason for failure cannot be determined, a
L<Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason>
exception is thrown instead.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error>
L<Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason>
L<Finance::Bank::Bankwest::Session/transactions>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Error::ExportFailed
    extends Finance::Bank::Bankwest::Error
{
    method MESSAGE {
        return sprintf(
            "%s %s [%s], %s\n%s",
            'the Bankwest Online Banking server rejected transaction',
            'parameter/s',
            join(q{, }, $self->params),
            'giving the following reason/s:',
            join("\n", map { qq{  * $_} } $self->errors),
        );
    }

=attr params

A list of the parameters passed to
L<Finance::Bank::Bankwest::Session/transactions> that the Bankwest
Online Banking server rejected.  The reason/s for rejection can be
determined by inspecting the L</errors> list.

=cut

    has 'params' => (
        isa         => 'ArrayRef[Str]',
        traits      => [qw{ Array }],
        handles     => { 'params' => 'elements' },
        required    => 1,
    );

=attr errors

A list of error messages returned by Bankwest Online Banking as to why
the transaction export failed.

=cut

    has 'errors' => (
        isa         => 'ArrayRef[Str]',
        traits      => [qw{ Array }],
        handles     => { 'errors' => 'elements' },
        required    => 1,
    );
}
