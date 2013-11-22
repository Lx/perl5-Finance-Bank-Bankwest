package Finance::Bank::Bankwest::Parser::TransactionExport;
# ABSTRACT: transaction CSV export parser

=for stopwords
CSV

=head1 DESCRIPTION

This module holds the logic for identifying an L<HTTP::Response> object
as a Bankwest Online Banking transaction CSV export, and extracting the
details of each transaction from it as
L<Finance::Bank::Bankwest::Transaction> objects.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Transaction>
L<HTTP::Response::Switch::Handler>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
use HTTP::Response::Switch::Handler 1.000000;
class Finance::Bank::Bankwest::Parser::TransactionExport
    with HTTP::Response::Switch::Handler
{
    use Finance::Bank::Bankwest::Transaction ();
    use IO::String 0.03 (); # earlier versions fail their tests
    use Text::CSV_XS 0.66 (); # for "empty_is_undef" attribute

    method handle {
        $self->decline
            if $self->response->headers->content_type ne 'text/csv';

        my $io = IO::String->new( $self->response->content_ref );
        my $csv = Text::CSV_XS->new({
            auto_diag       => 2,
            empty_is_undef  => 1,
        });
        $csv->column_names( $csv->getline($io) );

        my @txns;
        while (my $row = $csv->getline_hr($io)) {
            my $amount;
            for (qw{ Credit Debit }) {
                next if not defined $row->{$_};
                $amount = $row->{$_};
                undef $amount if $amount == 0;
            }
            push @txns, Finance::Bank::Bankwest::Transaction->new(
                date        => $row->{'Transaction Date'},
                narrative   => $row->{'Narration'},
                cheque_num  => $row->{'Cheque Number'},
                amount      => $amount,
                type        => $row->{'Transaction Type'},
            );
        }
        return @txns;
    }
}
