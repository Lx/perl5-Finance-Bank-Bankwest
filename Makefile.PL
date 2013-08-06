
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "check Bankwest accounts from Perl",
  "AUTHOR" => "Alex Peters <lxp\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Finance-Bank-Bankwest",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Finance::Bank::Bankwest",
  "PREREQ_PM" => {
    "HTTP::Response::Switch" => "1.001000",
    "IO::String" => 0,
    "MooseX::Declare" => 0,
    "MooseX::OneArgNew" => 0,
    "MooseX::StrictConstructor" => 0,
    "MooseX::Types" => 0,
    "Text::CSV_XS" => "0.66",
    "Throwable::Error" => "0.101110",
    "TryCatch" => 0,
    "WWW::Mechanize" => 0,
    "Web::Scraper" => 0
  },
  "TEST_REQUIRES" => {
    "File::Temp" => 0,
    "HTTP::Response" => 0,
    "Module::Loaded" => 0,
    "Scalar::Util" => 0,
    "Test::Exception" => 0,
    "Test::More" => 0,
    "Test::Routine" => 0,
    "URI::file" => 0,
    "parent" => 0
  },
  "VERSION" => "1.2.4",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



