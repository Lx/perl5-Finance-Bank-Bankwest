use Test::Routine;
use Test::Routine::Util;
use Test::More;
use Test::Exception;

use HTTP::Response ();
use MooseX::Declare;

class Finance::Bank::Bankwest::Parser::FakeTestYes
    extends Finance::Bank::Bankwest::Parser
{
    method TEST { }
}
class Finance::Bank::Bankwest::Parser::FakeTestNo
    extends Finance::Bank::Bankwest::Parser
{
    method TEST { $self->bad_response }
}
class Finance::Bank::Bankwest::Parser::FakeTestOops
    extends Finance::Bank::Bankwest::Parser
{
    method TEST { die 'something went wrong' }
}
class Finance::Bank::Bankwest::Parser::FakeParseYes
    extends Finance::Bank::Bankwest::Parser::FakeTestYes
{
    method PARSE { 'OK' }
}

test 'parsers loaded when Parsers used' => sub {
    throws_ok
        { Finance::Bank::Bankwest::Parser::Accounts->ANYTHING }
        qr/perhaps you forgot to load/,
        'Parser::Accounts must not be loaded before Parsers used';
    use_ok('Finance::Bank::Bankwest::Parsers');
    ok
        Finance::Bank::Bankwest::Parser::Accounts->can('test'),
        'Parser::Accounts must be loaded after Parsers used';
};

my $r = HTTP::Response->new;
test 'test method' => sub {
    lives_ok
        { Finance::Bank::Bankwest::Parsers->test($r, 'FakeTestYes') }
        'test must live if first tester says yes';
    throws_ok
        { Finance::Bank::Bankwest::Parsers->test(
            $r,
            qw{ FakeTestNo FakeTestOops },
        ) }
        qr/something went wrong/,
        'subsequent tester unexpected error must propagate';
    throws_ok
        { Finance::Bank::Bankwest::Parsers->test(
            $r,
            qw{ FakeTestNo FakeTestNo },
        ) }
        'Finance::Bank::Bankwest::Error::BadResponse',
        'must throw BadResponse if no testers say yes or die';
};

test 'parse method' => sub {
    is
        Finance::Bank::Bankwest::Parsers->parse($r, 'FakeParseYes'),
        'OK',
        'parse must return result if parser says yes';
    throws_ok
        { Finance::Bank::Bankwest::Parsers->parse(
            $r,
            qw{ FakeTestNo FakeTestOops },
        ) }
        qr/something went wrong/,
        'subsequent tester unexpected error must propagate';
    throws_ok
        { Finance::Bank::Bankwest::Parsers->parse(
            $r,
            qw{ FakeTestOops FakeTestNo },
        ) }
        qr/something went wrong/,
        'parser unexpected error must propagate';
};

run_me;
done_testing;
