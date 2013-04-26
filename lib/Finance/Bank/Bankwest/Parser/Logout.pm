package Finance::Bank::Bankwest::Parser::Logout;
# ABSTRACT: Online Banking logout web page parser

=head1 DESCRIPTION

This module holds the logic for identifying an L<HTTP::Response> object
as a Bankwest Online Banking logout web page.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Parser>
L<Finance::Bank::Bankwest::Session/logout>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Parser::Logout
    extends Finance::Bank::Bankwest::Parser
{
    use Web::Scraper qw{ scraper process };

    my $token = 'You have successfully logged out from your session';
    my $scraper = scraper {
        process '#contentColumn', 'text' => 'TEXT';
    };

    method TEST {
        my $scrape = $scraper->scrape($self->response);
        $self->bad_response
            if not defined $scrape->{'text'}
                or index($scrape->{'text'}, $token) < 0;
    }
}
