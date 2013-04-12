require 'time'
require 'log_weaver'


# Vars common to specs and factories; I tried wrapping them in a module, i.e.:
# module CommonVariables
#   def p1() 'p1' end
# end
# but having modules deep in Rspec get access to it by extending was way more voodoo
# than I can stomach for now. So we'll go with globals.

$p1 = 'p1'
$p2 = 'p2'

$t1 = Time.parse('2000-01-01 00:00:01.000') # NOTE: init time this way to discard values below msec
$t2 = $t1 + 1

$l1 = ' l1'
$l2 = ' l2'

$t1_l1 = "#{$t1}#{$l1}"
$t1_l2 = "#{$t1}#{$l2}"
$t2_l1 = "#{$t2}#{$l1}"
$t2_l2 = "#{$t2}#{$l2}"

$no_t_l1 = $l1
$no_t_l2 = $l2

$out_p1_t1_l1 = "#{$p1}:#{$t1_l1}"
$out_p2_t2_l1 = "#{$p2}:#{$t2_l1}"

$io_empty                      = StringIO.new
$io_t1_l1                      = StringIO.new($t1_l1)
$io_t2_l1                      = StringIO.new($t2_l1)
$io_t1_l1_t2_l1                = StringIO.new([$t1_l1, $t2_l1].join("\n"))
$io_t1_l1_t1_l2                = StringIO.new([$t1_l1, $t1_l2].join("\n"))
$io_no_t_l1_t1_l2              = StringIO.new([$no_t_l1, $t1_l2].join("\n"))
$io_t1_l1_no_t_l2              = StringIO.new([$t1_l1, $no_t_l2].join("\n"))

$io_t1l2_t2l2                  = StringIO.new([$t1_l2, $t2_l2].join("\n"))
$io_with_missing_timestamps    = StringIO.new([$t1_l1, $no_t_line, $t2_l1].join("\n"))
$io_with_duplicate_timestamp   = StringIO.new([$t1_l1, $t1_l1].join("\n"))
$io_starting_with_no_timestamp = StringIO.new([$no_t_line, $t2_l1].join("\n"))

$hash_t1_l1 = { $t1 => [$l1] }
$hash_t2_l1 = { $t2 => [$l1] }


$hash_t1_l1_t2_l1 = {
    $t1 => [$l1],
    $t2 => [$l1]
}

$hash_t1_l1_t1_l2 = {
    $t1 => [$l1, $l2]
}

$hash_io_t1_l1_no_t_l2 = {
    $t1 => [$l1, $no_t_l2]
}


# need to monkey-patch in argumentless constructors for FactoryGirl to be happy;
# see http://stackoverflow.com/a/6838145/26819
module LogWeaver
  class ParsedLog
    attr_accessor :prefix
    def initialize
    end
  end
end

FactoryGirl.define do
  #TODO: can this be LogWeaver::ParsedLog instead of a string?
  factory 'log_weaver/parsed_log' do
    factory :pl_p1 do
      prefix {$p1} #TODO: are the curlies needed here?
      factory :pl_p1_t1_l1 do
        lines $hash_t1_l1
      end
      factory :pl_p1_t2_l1 do
        lines $hash_t2_l1
      end
    end

    factory :pl_p2 do
      prefix $p2
      factory :pl_p2_t1_l1 do
        lines $hash_t1_l1
      end
      factory :pl_p2_t2_l1 do
        lines $hash_t2_l1
      end
    end
  end

  $pl_p1_t1_l1 = FactoryGirl.build :pl_p1_t1_l1
  $pl_p1_t2_l1 = FactoryGirl.build :pl_p1_t2_l1
  $pl_p2_t1_l1 = FactoryGirl.build :pl_p2_t1_l1
  $pl_p2_t2_l1 = FactoryGirl.build :pl_p2_t2_l1

  factory 'log_weaver/combined_log_index_key' do
    factory :k_p1 do
      prefix $p1
      factory :k_p1_t1 do
        timestamp $t1
      end
      factory :k_p1_t2 do
        timestamp $t2
      end
    end
    factory :k_p2 do
      prefix $p2
      factory :k_p2_t1 do
        timestamp $t1
      end
      factory :k_p2_t2 do
        timestamp $t2
      end
    end
  end
end

$k_p1_t1 = FactoryGirl.build :k_p1_t1
$k_p1_t2 = FactoryGirl.build :k_p1_t2
$k_p2_t1 = FactoryGirl.build :k_p2_t1
$k_p2_t2 = FactoryGirl.build :k_p2_t2

$hash_p1_t1_l1_and_p2_t2_l1 = {
    $k_p1_t1 => [$l1],
    $k_p2_t2 => [$l1]
}

$hash_p1_t1_l1_and_p2_t1_l1 = {
    $k_p1_t1 => [$l1],
    $k_p2_t1 => [$l1]
}

$hash_p1_t2_l1_and_p2_t1_l1 = {
    $k_p2_t1 => [$l1],
    $k_p1_t2 => [$l1]
}






