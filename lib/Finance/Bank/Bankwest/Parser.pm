package Finance::Bank::Bankwest::Parser;
# ABSTRACT: Bankwest Online Banking response parser superclass

=for stopwords
analyse recognise recognised subclasses

=head1 DESCRIPTION

Subclasses of this module receive an L<HTTP::Response> object when
instantiated, and are capable of reporting whether they recognise that
that particular response and optionally returning structured data.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Error::BadResponse>
L<Finance::Bank::Bankwest::Parser::Accounts>
L<Finance::Bank::Bankwest::Parser::Login>
L<Finance::Bank::Bankwest::Parser::Logout>
L<Finance::Bank::Bankwest::Parser::TransactionExport>
L<Finance::Bank::Bankwest::Parser::TransactionSearch>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Parser {

    use Carp 'croak';
    use Finance::Bank::Bankwest::Error::BadResponse ();
    use MooseX::StrictConstructor; # no exports
    use MooseX::Types; # for "class_type"

    # Allow instantiation via ->new($http_response).
    class_type 'HTTP::Response';
    with 'MooseX::OneArgNew' => {
        type        => 'HTTP::Response',
        init_arg    => 'response',
    };

=attr response

An L<HTTP::Response> object holding the response to analyse.

=cut

    has 'response' => (
        is          => 'ro',
        isa         => 'HTTP::Response',
        required    => 1,
    );

=method bad_response

    $self->bad_response if ...;

Called internally by subclasses to conveniently throw a
L<Finance::Bank::Bankwest::Error::BadResponse> exception with the
L</response> attached.

=cut

    method bad_response {
        Finance::Bank::Bankwest::Error::BadResponse->throw(
            response    => $self->response,
        );
    }

=method test

    $class->test($http_response);

Inspect the supplied L<HTTP::Response> object.  Return without error if
the response is recognised and acceptable, or throw an appropriate
exception.

=method TEST

Must be implemented by subclasses; called internally by L</test> and
L</parse>.

=cut

    method test($class: $response) {
        $class->new($response)->TEST;
    }

=method parse

    return $class->parse($http_response);

Produce and return a specific data structure from the supplied
L<HTTP::Response> object, or throw an appropriate exception if the
response is not recognised and acceptable.

=method PARSE

Implemented by subclasses if parsing is applicable to them; called
internally by L</parse>.

=cut

    method parse($class: $response) {
        my $self = $class->new($response);
        $self->TEST;
        return $self->PARSE;
    }
    method PARSE {
        croak 'parsing is not applicable to this module';
    }
}
