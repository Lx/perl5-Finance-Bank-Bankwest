package Finance::Bank::Bankwest::Account;
# ABSTRACT: representation of a Bankwest account

=for stopwords
unfinalised

=head1 SYNOPSIS

    $account->name;                 # 'My Zero Transaction'
    $account->number;               # '303-111 0012345'
    $account->balance;              # 4224.35
    $account->credit_limit;         # 100.00
    $account->uncleared_funds;      # 0.00
    $account->available_balance;    # 4207.66

=head1 DESCRIPTION

Instances of this module are returned by
L<Finance::Bank::Bankwest::Session/accounts>.

=attr name

The "nickname" for the account as set in the Bankwest Online Banking
interface.

=attr number

The full account number of the account in C<BBB-BBB AAAAAAA> format,
where C<B> is a BSB digit and C<A> is an account digit.

=attr balance

The current balance of the account in dollars, not including
unfinalised debits.

=attr credit_limit

The account's credit limit in dollars.

=attr uncleared_funds

The total of all unfinalised deposits in dollars.

=attr available_balance

The account's available balance in dollars, including unfinalised
debits and the credit limit.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Session/accounts>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Account {

    use MooseX::StrictConstructor;

    for (
        [ name              => 'Str' ],
        [ number            => 'Str' ],
        [ balance           => 'Num' ],
        [ credit_limit      => 'Num' ],
        [ uncleared_funds   => 'Num' ],
        [ available_balance => 'Num' ],
    ) {
        has $_->[0] => ( isa => $_->[1], is => 'ro', required => 1 );
    }
}
