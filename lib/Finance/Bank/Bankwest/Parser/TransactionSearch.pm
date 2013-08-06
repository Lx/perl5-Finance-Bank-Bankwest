package Finance::Bank::Bankwest::Parser::TransactionSearch;
# ABSTRACT: transaction search page parser

=head1 DESCRIPTION

This module holds the logic for identifying an L<HTTP::Response> object
as a Bankwest Online Banking transaction search page, and throwing
appropriate exceptions when the page indicates that something has gone
wrong (e.g. bad data entered into the form).

If the response holds a search form with no error messages or fields
marked as having invalid input, a
L<Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason>
exception is thrown.  This is because of the possibility that such a
page could theoretically be returned for some reason after form
submission, and in such a case it is important for an exception to be
thrown.  In cases where an empty form is expected (such as loading the
form to populate and submit it), the exception can be discarded.

If error messages or fields marked as having invalid input appear in
the response, a L<Finance::Bank::Bankwest::Error::ExportFailed>
exception is thrown.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::ExportFailed>
L<Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason>
L<HTTP::Response::Switch::Handler>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
use HTTP::Response::Switch::Handler 1.000000;
class Finance::Bank::Bankwest::Parser::TransactionSearch
    with HTTP::Response::Switch::Handler
{
    use Finance::Bank::Bankwest::Error::ExportFailed ();
    use Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason ();
    use Web::Scraper qw{ scraper process };

    my $scraper = scraper {
        process '#headingBar',
            'heading' => 'TEXT';
        process '#_ctl0_valSummary ul li',
            'errors[]' => 'TEXT';
        process '#_ctl0_ContentMain_valAccount_custom1',
            'acct_style' => '@style';
        process '#_ctl0_ContentMain_dpFromDate_valCheck_custom1',
            'from_date_err' => sub { 1 };
        process '#_ctl0_ContentMain_dpFromDate_valCheck_custom2',
            'from_date_err' => sub { 1 };
        process '#_ctl0_ContentMain_dpToDate_valCheck_custom1',
            'to_date_has_err' => sub { 1 };
        process '#_ctl0_ContentMain_valToDate',
            'tdate_style' => '@style';
    };
    method handle {
        my $scrape = $scraper->scrape($self->response);

        $self->decline if not $scrape->{'heading'}
            or $scrape->{'heading'} !~ /^\s*Transaction\s+Search\s*$/x;

        my %ef;
        $ef{'account'}++ if defined $scrape->{'acct_style'}
            and index($scrape->{'acct_style'}, ';display:none;') < 0;
        $ef{'from_date'}++ if $scrape->{'from_date_err'};
        $ef{'to_date'}++ if $scrape->{'to_date_has_err'};
        $ef{'to_date'}++ if defined $scrape->{'tdate_style'}
            and index($scrape->{'tdate_style'}, ';display:none;') < 0;

        if ($scrape->{'errors'}) {
            s{ ^ \s+ }{}x for @{ $scrape->{'errors'} };
        }
        if ($scrape->{'errors'} or keys %ef) {
            Finance::Bank::Bankwest::Error::ExportFailed->throw(
                errors  => $scrape->{'errors'},
                params  => [keys %ef],
            );
        }

        # We have a transaction search page with no apparent errors.
        # Not a problem if the caller is expecting it, but very bad
        # news otherwise--so throw an exception just in case.
        Finance::Bank::Bankwest::Error::ExportFailed::UnknownReason
            ->throw($self->response);
    }
}
