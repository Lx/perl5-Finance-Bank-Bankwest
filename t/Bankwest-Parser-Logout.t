use Test::Routine::Util;
use Test::More;

run_tests(
    undef,
    't::lib::Test::ParserSubclass' => {
        parser      => 'Logout',
        test_ok     => 'logged-out',
        test_fail   => { 'google' => 'BadResponse' },
    },
);
done_testing;
