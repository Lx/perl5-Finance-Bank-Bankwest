package Finance::Bank::Bankwest::Error::WithResponse;
# ABSTRACT: make exceptions hold an L<HTTP::Response>

=head1 DESCRIPTION

Exception classes consuming this role provide access to the Bankwest
Online Banking response that triggered the exception.

Catching exceptions of this type allows calling code to log responses
for later analysis if desired.

=attr response

An L<HTTP::Response> object holding the response causing the exception
to be thrown.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::BadResponse>
L<Finance::Bank::Bankwest::Error::NotLoggedIn::UnknownReason>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare 0.06; # for auto "strict" and "warnings"
role Finance::Bank::Bankwest::Error::WithResponse {

    use MooseX::Types; # for "class_type"

    # Allow instantiation via single argument: ->new($http_response).
    class_type 'HTTP::Response';
    with 'MooseX::OneArgNew' => {
        type        => 'HTTP::Response',
        init_arg    => 'response',
    };

    has 'response' => (
        is          => 'ro',
        isa         => 'HTTP::Response',
        required    => 1,
    );
}
