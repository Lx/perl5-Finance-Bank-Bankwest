use Test::Routine::Util;
use Test::More;

my %good_args = (
    date        => '31/12/2012',
    narrative   => '1 BANK CHEQUE FEE - BWA CUSTOMER',
    cheque_num  => undef,
    amount      => '-10.00',
    type        => 'FEE',
);

run_tests(
    undef,
    't::lib::Test::UnexpectedParamFails' => {
        class       => 'Transaction',
        good_args   => \%good_args,
    },
);
done_testing;
