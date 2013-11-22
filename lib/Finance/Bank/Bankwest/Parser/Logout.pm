package Finance::Bank::Bankwest::Parser::Logout;
# ABSTRACT: Online Banking logout web page parser

=head1 DESCRIPTION

This module holds the logic for identifying an L<HTTP::Response> object
as a Bankwest Online Banking logout web page.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Session/logout>
L<HTTP::Response::Switch::Handler>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare 0.06; # for auto "strict" and "warnings"
use HTTP::Response::Switch::Handler 1.000000;
class Finance::Bank::Bankwest::Parser::Logout
    with HTTP::Response::Switch::Handler
{
    use Web::Scraper qw{ scraper process };

    my $token = 'You have successfully logged out from your session';
    my $scraper = scraper {
        process '#contentColumn', 'text' => 'TEXT';
    };

    method handle {
        my $scrape = $scraper->scrape($self->response);
        $self->decline
            if not defined $scrape->{'text'}
                or index($scrape->{'text'}, $token) < 0;
    }
}
