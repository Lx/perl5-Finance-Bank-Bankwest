package Finance::Bank::Bankwest;
# ABSTRACT: check Bankwest accounts from Perl

=for stopwords
Bankwest's login

=head1 SYNOPSIS

    my $session = Finance::Bank::Bankwest->login(
        pan         => 12345678,
        access_code => 'LetMeIn123',
    );
    for my $acct ($session->accounts) {
        printf(
            "Account %s has available balance %s\n",
            $acct->number,
            $acct->available_balance,
        );
        my @txns = $session->transactions(
            account     => $acct->number,
            from_date   => '31/12/2012',
        );
        for my $txn (@txns) {
            printf(
                "> Transaction: %s (%s)\n",
                $txn->narrative,
                $txn->amount,
            );
        }
    }
    $session->logout;

=head1 DESCRIPTION

This distribution provides the ability to log into Bankwest's Online
Banking service using a Personal Access Number (PAN) and access code,
then retrieve information on all accounts associated with that PAN and
their transactions.

Consult the documentation for L<Finance::Bank::Bankwest::Session> for
further details on what can be achieved within a session.

=head1 WARNING

The code contained in this distribution is B<not endorsed by Bankwest>
as an official means of accessing banking data.  It is entirely written
and provided by a third party, and B<Bankwest will not provide support>
for this distribution if approached for it (see L</SUPPORT>).

You should audit the source code of this distribution in order to
satisfy yourself that your banking details are only being used in a
legitimate manner.

Consider also consulting the Bankwest Online Banking Conditions of Use
before using this distribution.

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Session>
L<Finance::Bank::Bankwest::SessionFromLogin/session>

=cut

use strict;
use warnings;

use Finance::Bank::Bankwest::SessionFromLogin ();

=method login

    $session = Finance::Bank::Bankwest->login(
        pan             => 12345678,        # required
        access_code     => 'LetMeIn123',    # required
    );

Log into Bankwest Online Banking with the supplied Personal Access
Number (PAN) and access code.  Returns a
L<Finance::Bank::Bankwest::Session> object on success.

Refer to L<Finance::Bank::Bankwest::SessionFromLogin/session> for
specific details on possible exceptions that may be thrown in cases of
failure.

=cut

sub login {
    my ($class, @args) = @_;
    return Finance::Bank::Bankwest::SessionFromLogin->new(@args)->session;
}

1;
