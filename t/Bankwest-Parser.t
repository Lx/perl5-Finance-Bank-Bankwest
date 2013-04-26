use Test::Routine;
use Test::Routine::Util;
use Test::More;
use Test::Exception;

use HTTP::Response ();
use Scalar::Util 'refaddr';

use MooseX::Declare;

my $been_tested;

class t::ParserConsumer1
    extends Finance::Bank::Bankwest::Parser
{
    method TEST { die 'this is TEST' }
}
class t::ParserConsumer2
    extends Finance::Bank::Bankwest::Parser
{
    method TEST { }
}
class t::ParserConsumer3
    extends Finance::Bank::Bankwest::Parser
{
    method TEST { $been_tested++; }
    method PARSE {
        die 'no TEST first?!' unless $been_tested;
        return 'OK';
    }
}

my $r = HTTP::Response->new;

run_tests(
    undef,
    't::lib::Test::UnexpectedParamFails' => {
        class       => 't::ParserConsumer1',
        good_args   => { response => $r },
    },
);

test 'succeed with single argument' => sub {
    my $c = t::ParserConsumer1->new($r);
    is refaddr $r, refaddr $c->response,
        'response should return the right response';
};

test 'test calls TEST' => sub {
    throws_ok { t::ParserConsumer1->test($r) } qr/this is TEST/;
};

test 'PARSE dies if not defined' => sub {
    throws_ok
        { t::ParserConsumer2->parse($r) }
        qr/parsing is not applicable/;
};

test 'parse calls TEST first' => sub {
    $been_tested = 0;
    throws_ok
        { t::ParserConsumer3->new($r)->PARSE; }
        qr/no TEST first/,
        'PARSE must die if called directly without TEST first';
    is(t::ParserConsumer3->parse($r), 'OK');
    ok($been_tested);
};

test 'throw BadResponse' => sub {
    my $c = t::ParserConsumer1->new($r);
    throws_ok
        { $c->bad_response }
        'Finance::Bank::Bankwest::Error::BadResponse';
    my $e = $@;
    is refaddr $e->response, refaddr $c->response,
        'response should return the right response';
};

run_me;
done_testing;
