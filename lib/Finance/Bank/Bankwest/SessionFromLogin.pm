package Finance::Bank::Bankwest::SessionFromLogin;
# ABSTRACT: create a session using a PAN and access code

=head1 SYNOPSIS

    my $from_login = Finance::Bank::Bankwest::SessionFromLogin->new(
        pan         => 12345678,
        access_code => 'LetMeIn123',
    );
    # returns a Finance::Bank::Bankwest::Session object
    my $session = $from_login->session;

=head1 DESCRIPTION

This module logs into Bankwest Online Banking using a supplied PAN
(Personal Access Number) and access code, and sets up a
L<Finance::Bank::Bankwest::Session> object with the newly-created
session.

L<Finance::Bank::Bankwest/login> provides a slightly more convenient
wrapper for this functionality.

=head1 SEE ALSO

L<Finance::Bank::Bankwest/login>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason>
L<Finance::Bank::Bankwest::Error::BadResponse>
L<Finance::Bank::Bankwest::Session>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::SessionFromLogin {

    use Finance::Bank::Bankwest::Parsers ();
    use Finance::Bank::Bankwest::Session ();
    use MooseX::StrictConstructor; # no exports
    use TryCatch; # for "try" and "catch"
    use WWW::Mechanize ();

=attr pan

The Personal Access Number (PAN).  Required.

=cut

    has 'pan' => (
        is          => 'ro',
        isa         => 'Str',
        required    => 1,
    );

=attr access_code

The access code associated with the provided PAN.  Required.

=cut

    has 'access_code' => (
        is          => 'ro',
        isa         => 'Str',
        required    => 1,
    );

=attr session

If login with the provided credentials is successful, a
L<Finance::Bank::Bankwest::Session> instance.

May throw one of the following exceptions on failure:

=begin :list

= L<Finance::Bank::Bankwest::Error::NotLoggedIn::BadCredentials>

if the remote server rejects the supplied PAN/access code combination.

= L<Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason>

or

= L<Finance::Bank::Bankwest::Error::BadResponse>

if the remote server returns something unexpected, such as an "offline
for maintenance" message or some sort of intermediate advertising
pop-up.  In both cases the remote server's response is available as an
L<HTTP::Response> object; see
L<Finance::Bank::Bankwest::Error::WithResponse/response>.

=end :list

=cut

    has 'session' => (
        init_arg    => undef,
        is          => 'ro',
        isa         => 'Finance::Bank::Bankwest::Session',
        lazy_build  => 1,
    );
    method _build_session {
        my $ua = WWW::Mechanize->new(
            stack_depth     => 0,
            cookie_jar      => { hide_cookie2 => 1 },
        );
        $ua->get($self->login_uri);

        # Is this actually a login page?
        try {
            Finance::Bank::Bankwest::Parsers->test($ua->res, 'Login');
        }
        catch (Finance::Bank::Bankwest::Error::NotLoggedIn $e) {
            # Generally the appearance of a login page is a bad thing,
            # but because we are currently trying to log in, it's not.
        }

        # The "__EVENTTARGET" parameter is normally set via JavaScript.
        $ua->submit_form(
            form_id => 'Form1',
            fields => {
                'AuthUC$txtUserID'  => $self->pan,
                'AuthUC$txtData'    => $self->access_code,
                '__EVENTTARGET'     => 'AuthUC$btnLogin',
            },
        );

        # Does the result look like an Account Balances page?
        # If not, determine and throw the appropriate exception.
        Finance::Bank::Bankwest::Parsers->test(
            $ua->res,
            qw{ Accounts Login },
        );

        # If this point is reached, the session is established.
        return Finance::Bank::Bankwest::Session->new( $ua );
    }

=attr login_uri

The location of the resource that accepts the provided PAN and access
code and establishes the banking session.  Use the default value during
normal operation.

=cut

    has 'login_uri' => (
        is          => 'ro',
        isa         => 'Str',
        default     => 'https://ibs.bankwest.com.au/BWLogin/rib.aspx',
    );
}
