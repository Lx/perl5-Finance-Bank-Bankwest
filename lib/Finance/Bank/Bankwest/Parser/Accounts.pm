package Finance::Bank::Bankwest::Parser::Accounts;
# ABSTRACT: Account Balances web page parser

=head1 DESCRIPTION

This module holds the logic for identifying a Bankwest Online Banking
Account Balances page, and extracting the details of each account from
it as L<Finance::Bank::Bankwest::Account> objects.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Account>
L<Finance::Bank::Bankwest::Session/accounts>
L<Finance::Bank::Bankwest::SessionFromLogin>
L<HTTP::Response::Switch::Handler>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
use HTTP::Response::Switch::Handler 1.000000;
class Finance::Bank::Bankwest::Parser::Accounts
    with HTTP::Response::Switch::Handler
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

    method handle {
        $self->decline if not $self->scrape->{'accts'};

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
