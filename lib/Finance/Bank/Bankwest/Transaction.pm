package Finance::Bank::Bankwest::Transaction;
# ABSTRACT: representation of an account transaction

=for stopwords
authorisation BPAY CHQ DAU DEP DFD DRI EFTPOS ENQ NAR TFC TFD WDC WDI
WDL

=head1 SYNOPSIS

    $transaction->date;         # '31/12/2012'
    $transaction->narrative;    # '1 BANK CHEQUE FEE - BWA CUSTOMER'
    $transaction->cheque_num;   # undef
    $transaction->amount;       # -10.00
    $transaction->type;         # 'FEE'

    SAME_TRANSACTION if $this_txn->equals($other_txn);
    SAME_TRANSACTION if $this_txn eq $other_txn;
    DIFFERENT_TRANSACTION if $this_txn ne $other_txn;

=head1 DESCRIPTION

Instances of this module are returned by
L<Finance::Bank::Bankwest::Session/transactions>.

=attr date

A string in C<DD/MM/YYYY> format representing the date of the
transaction.

=attr narrative

A description of the transaction.

=attr cheque_num

The cheque number for cheque withdrawals, or C<undef> if not applicable.

=attr amount

A positive or negative value representing the credit or debit value of
the transaction respectively, or C<undef> if not applicable (such as
for fee notices or declined transactions).

=attr type

The transaction "type."  May be one of the following values (or even
something else):

=over 6

=item CHQ

Debit via cheque.

=item DAU

Authorisation only.

=item DEP

Non-salary deposit or EFTPOS refund.

=item DFD

Deposit via a Fast Deposit box.

=item DID

Dishonoured debit, e.g. bounced cheque.

=item DRI

Debit interest.

=item ENQ

Declined transaction.

=item FEE

Bank fee, e.g. bank cheque fee.

=item NAR

Information-only transaction without a credit or debit, such as
notification of an ATM fee being paid by Bankwest or a breakdown of
fees included in another transaction (such as foreign currency
conversion).

=item PAY

Salary deposit.

=item TFC

Internal credit from another Bankwest account.

=item TFD

BPAY or internal debit to another Bankwest account.

=item WDC

Credit withdrawal.

=item WDI

Credit withdrawal by an international merchant.

=item WDL

ATM, EFTPOS or "pay anyone" withdrawal, or direct debit.

=back

=head1 SEE ALSO

L<Finance::Bank::Bankwest::Session/transactions>

=cut

## no critic (RequireUseStrict, RequireUseWarnings, RequireEndWithOne)
use MooseX::Declare;
class Finance::Bank::Bankwest::Transaction is dirty {

    use MooseX::StrictConstructor;

    for (
        [ date          => 'Str'        ],
        [ narrative     => 'Str'        ],
        [ cheque_num    => 'Maybe[Str]' ],
        [ amount        => 'Maybe[Num]' ],
        [ type          => 'Str'        ],
    ) {
        has $_->[0] => ( isa => $_->[1], is => 'ro', required => 1 );
    }

=method equals

    if ($this_txn->equals($other_txn)) {
        # $this_txn and $other_txn represent the exact same transaction
        ...
    }

True if both this transaction and the specified one represent an
identical transaction; false otherwise.

Perl's C<eq> and C<ne> operators are also L<overload>-ed for
Transaction objects, allowing the following code to work as expected:

    if ($this_txn eq $other_txn) {
        # $this_txn and $other_txn represent the exact same transaction
        ...
    }

    if ($this_txn ne $other_txn) {
        # $this_txn and $other_txn DO NOT represent the exact same transaction
        ...
    }

=cut

    method equals(Finance::Bank::Bankwest::Transaction $other) {
        for (qw{ date narrative cheque_num amount type }) {
            next if not defined $self->$_ and not defined $other->$_;
            return if defined $self->$_ and not defined $other->$_;
            return if defined $other->$_ and not defined $self->$_;
            return if $self->$_ ne $other->$_;
        }
        return 1;
    }

    clean;
    use overload 'eq' => sub { shift->equals(shift) };
    use overload 'ne' => sub { not shift->equals(shift) };
}
