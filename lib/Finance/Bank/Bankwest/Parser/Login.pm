package Finance::Bank::Bankwest::Parser::Login;
# ABSTRACT: Online Banking login web page parser

=head1 DESCRIPTION

This module holds the logic for identifying an L<HTTP::Response> object
as a Bankwest Online Banking login web page, and throwing appropriate
exceptions when the page indicates that something has gone wrong (e.g.
session timeout, subsequent login, bad credentials).

This module always throws an exception regardless of the content of the
response, on the basis that being presented with a login page during a
session is almost always a bad thing.  In the one foreseeable case when
a login page is good--logging in--the caller can simply catch the
exception and proceed as normal.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::SubsequentLogin>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::Timeout>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason>
L<Finance::Bank::Bankwest::Parser>
L<Finance::Bank::Bankwest::Session>
L<Finance::Bank::Bankwest::SessionFromLogin>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Parser::Login
    extends Finance::Bank::Bankwest::Parser
{
    use Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials ();
    use Finance::Bank::Bankwest::Error::NotLoggedIn::SubsequentLogin ();
    use Finance::Bank::Bankwest::Error::NotLoggedIn::Timeout ();
    use Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason ();
    use Web::Scraper qw{ scraper process };

    my $scraper = scraper {
        process '#Form1 h2', 'form' => 'TEXT';
        process '#additionalMessageHeading', 'heading' => 'TEXT';
        process '#AuthUC_lblMessage', 'bc' => 'TEXT';
        process '#lblAdditionalLogonMessage', 'sl' => 'TEXT';
    };
    method TEST {
        my $s = $scraper->scrape($self->response);
        $self->bad_response
            if not defined $s->{'form'}
                or $s->{'form'} !~ m{ ^ \s* Login \s* $ }x;
        Finance::Bank::Bankwest::Error::NotLoggedIn::Timeout->throw
            if defined $s->{'heading'}
                and $s->{'heading'} eq 'Time Out';
        Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials->throw
            if defined $s->{'bc'} and (
                index($s->{'bc'}, "PAN and secure code don't match") >= 0
                or index($s->{'bc'}, 'forgot to enter your PAN') >= 0
            );
        Finance::Bank::Bankwest::Error::NotLoggedIn::SubsequentLogin->throw
            if defined $s->{'sl'}
                and index($s->{'sl'}, 'due to a subsequent logon') >= 0;

        # The login form is being shown, with or without unanticipated
        # error messages.  In almost every case this is a bad thing, so
        # throw an exception.  If the caller is expecting a login form
        # then they can catch the exception and carry on.
        Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason
            ->throw( $self->response );
    }
}
