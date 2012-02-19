rename unknown ::tcl::unknown

proc assertString {expected actual} {
  if {$expected ne $actual} {
    error "Expected $expected, got $actual"
  }
}

proc assertNumber {expected actual} {
  if {$expected != $actual} {
    error "Expected $expected, got $actual"
  }
}

proc on {args} {
  
  global debugOn
  
  if { [info exists debugOn] } {
    puts "on called with the following [llength $args] arguments: $args"
  }  
  
  global expectations
  lappend expectations $args
  
}

proc unknown {args} {

  global debugOn
  global expectations

  if { [info exists expectations] } {

    foreach expectation $expectations {

      set proccall [lrange $expectation 0 end-2]
      set procresult [lindex $expectation end]

      if { $proccall == $args} {
        switch -regexp [lindex $expectation end-1] {
          {^return$} {
              if {[info exists debugOn] } {
                puts "Returning value $procresult for $proccall"
              }
              return $procresult
          }
          {^error$} {
              if {[info exists debugOn] } {
                puts "Generate error $procresult for $proccall"
              }
              error $procresult
          }
          {^end$} {
            puts "end found"
          }
          default {
            error "Invalid expectation - expected one of return, error or end."
          }
        }
      }
      

    }

  }

  uplevel ::tcl::unknown $args
}

