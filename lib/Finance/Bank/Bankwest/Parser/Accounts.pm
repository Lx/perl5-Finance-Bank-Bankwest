package Finance::Bank::Bankwest::Parser::Accounts;
{
  $Finance::Bank::Bankwest::Parser::Accounts::VERSION = '1.2.1';
}
# ABSTRACT: Account Balances web page parser


## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Parser::Accounts
    extends Finance::Bank::Bankwest::Parser
{
    use Finance::Bank::Bankwest::Account ();
    use Web::Scraper qw{ scraper process };

    my $scraper = scraper {
        process
            '#_ctl0_ContentMain_grdBalances tbody tr',
            'accts[]' => scraper {
                process '//td[1]', 'name'               => 'TEXT';
                process '//td[2]', 'number'             => 'TEXT';
                process '//td[3]', 'balance'            => 'TEXT';
                process '//td[4]', 'credit_limit'       => 'TEXT';
                process '//td[5]', 'uncleared_funds'    => 'TEXT';
                process '//td[6]', 'available_balance'  => 'TEXT';
            };
    };

    has 'scrape' => (
        init_arg    => undef,
        lazy        => 1,
        is          => 'ro',
        isa         => 'HashRef[ArrayRef[HashRef[Str]]]',
        default     => sub { $scraper->scrape( shift->response ) },
    );

    method TEST {
        $self->bad_response if not $self->scrape->{'accts'};
    }

    method PARSE {
        my @accts;
        for my $acct (@{ $self->scrape->{'accts'} }) {
            for (qw{
                balance
                credit_limit
                uncleared_funds
                available_balance
            }) {
                $acct->{$_} =~ tr{$,}{}d;
            }
            push @accts, Finance::Bank::Bankwest::Account->new($acct);
        }
        return @accts;
    }
}

__END__

=pod

=for :stopwords Alex Peters

=head1 NAME

Finance::Bank::Bankwest::Parser::Accounts - Account Balances web page parser

=head1 VERSION

This module is part of distribution Finance-Bank-Bankwest v1.2.1.

This distribution's version numbering follows the conventions defined at L<semver.org|http://semver.org/>.

=head1 DESCRIPTION

This module holds the logic for identifying a Bankwest Online Banking
Account Balances page, and extracting the details of each account from
it as L<Finance::Bank::Bankwest::Account> objects.

=head1 SEE ALSO



=over 4

=item *

L<Finance::Bank::Bankwest::Account>

=item *

L<Finance::Bank::Bankwest::Parser>

=item *

L<Finance::Bank::Bankwest::Session/accounts>

=item *

L<Finance::Bank::Bankwest::SessionFromLogin>

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
