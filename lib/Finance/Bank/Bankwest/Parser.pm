package Finance::Bank::Bankwest::Parser;
{
  $Finance::Bank::Bankwest::Parser::VERSION = '1.2.1';
}
# ABSTRACT: Bankwest Online Banking response parser superclass


## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Parser {

    use Finance::Bank::Bankwest::Error::BadResponse ();
    use MooseX::StrictConstructor; # no exports
    use MooseX::Types; # for "class_type"

    # Allow instantiation via ->new($http_response).
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


    method bad_response {
        Finance::Bank::Bankwest::Error::BadResponse->throw(
            response    => $self->response,
        );
    }


    method test($class: $response) {
        $class->new($response)->TEST;
    }


    method parse($class: $response) {
        my $self = $class->new($response);
        $self->TEST;
        return $self->PARSE;
    }
}

__END__

=pod

=for :stopwords Alex Peters analyse recognise recognised subclasses

=head1 NAME

Finance::Bank::Bankwest::Parser - Bankwest Online Banking response parser superclass

=head1 VERSION

This module is part of distribution Finance-Bank-Bankwest v1.2.1.

This distribution's version numbering follows the conventions defined at L<semver.org|http://semver.org/>.

=head1 DESCRIPTION

Subclasses of this module receive an L<HTTP::Response> object when
instantiated, and are capable of reporting whether they recognise that
that particular response and optionally returning structured data.

=head1 ATTRIBUTES

=head2 response

An L<HTTP::Response> object holding the response to analyse.

=head1 METHODS

=head2 bad_response

    $self->bad_response if ...;

Called internally by subclasses to conveniently throw a
L<Finance::Bank::Bankwest::Error::BadResponse> exception with the
L</response> attached.

=head2 test

    $class->test($http_response);

Inspect the supplied L<HTTP::Response> object.  Return without error if
the response is recognised and acceptable, or throw an appropriate
exception.

=head2 TEST

Must be implemented by subclasses; called internally by L</test> and
L</parse>.

=head2 parse

    return $class->parse($http_response);

Produce and return a specific data structure from the supplied
L<HTTP::Response> object, or throw an appropriate exception if the
response is not recognised and acceptable.

=head2 PARSE

Implemented by subclasses if parsing is applicable to them; called
internally by L</parse>.

=head1 SEE ALSO



=over 4

=item *

L<Finance::Bank::Bankwest::Error::BadResponse>

=item *

L<Finance::Bank::Bankwest::Parser::Accounts>

=item *

L<Finance::Bank::Bankwest::Parser::Login>

=item *

L<Finance::Bank::Bankwest::Parser::Logout>

=item *

L<Finance::Bank::Bankwest::Parser::TransactionExport>

=item *

L<Finance::Bank::Bankwest::Parser::TransactionSearch>

=back

=head1 AUTHOR

Alex Peters <lxp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Alex Peters.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

The full text of the license can be found in the
'LICENSE' file included with this distribution.

=cut
