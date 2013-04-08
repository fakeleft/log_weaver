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

$no_t_line = "no t"
$io_t1_l1 = StringIO.new($t1_l1)
$io_t2_l1 = StringIO.new($t2_l1)
$io_t1_l1_t2_l1                  = StringIO.new([$t1_l1, $t2_l1].join("\n"))
$hash_t1_l1 = { $t1 => [$l1] }
$hash_t1_l1_t2_l1 = { $t1 => [$l1], $t2 => [$l1] }
