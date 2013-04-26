package Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason;
# ABSTRACT: general transaction CSV export failure exception

=for stopwords
CSV programmatically

=head1 DESCRIPTION

This exception may be thrown on calls to
L<Finance::Bank::Bankwest::Session/transactions> when the Bankwest
Online Banking server declines to action a transaction export request
for a reason that cannot be programmatically determined.

It is also internally thrown when the transaction search form is loaded
for the first time, but then caught since this is an anticipated event.

=attr response

An L<HTTP::Response> object holding the response causing the exception
to be thrown.  May be useful for diagnosing the cause of the problem.

This attribute is made available via
L<Finance::Bank::Bankwest::Error::WithResponse>.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::ExportFailed>
L<Finance::Bank::Bankwest::Error::WithResponse>
L<Finance::Bank::Bankwest::Session/transactions>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason
    extends Finance::Bank::Bankwest::Error::ExportFailed
    with Finance::Bank::Bankwest::Error::WithResponse
{
    method MESSAGE {
        'the Bankwest Online Banking server declined to export '
            . 'transactions for an unknown reason'
    }

    # The contents of these fields couldn't be determined if this
    # exception is being thrown, so don't enforce their collection.
    has '+params' => ( default => sub { [] } );
    has '+errors' => ( default => sub { [] } );
}
