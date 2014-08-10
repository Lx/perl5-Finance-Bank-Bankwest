package Finance::Bank::Bankwest::Parser::ServiceMessage;
# ABSTRACT: Online Banking service message web page parser

=for stopwords
dismissible

=head1 DESCRIPTION

This module holds the logic for identifying an L<HTTP::Response> object
as a dismissible "service message" page occasionally served by Bankwest
Online Banking after login occurs.

This module always throws a
L<Finance::Bank::Bankwest::Error::ServiceMessage> exception on
detection of such a page rather than returning anything.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::ServiceMessage>
L<Finance::Bank::Bankwest::SessionFromLogin>
L<HTTP::Response::Switch::Handler>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
use HTTP::Response::Switch::Handler 1.000000;
class Finance::Bank::Bankwest::Parser::ServiceMessage
    with HTTP::Response::Switch::Handler
{
    use Finance::Bank::Bankwest::Error::ServiceMessage ();
    use Web::Scraper qw{ scraper process };

    my $scraper = scraper {
        process '#divInterceptContent', 'div' => sub { 1 };
        process '#btnStartBanking', 'button' => sub { 1 };
    };
    method handle {
        my $s = $scraper->scrape( $self->response );
        $self->decline if not $s->{'div'} or not $s->{'button'};
        Finance::Bank::Bankwest::Error::ServiceMessage
            ->throw( $self->response );
    }
}
