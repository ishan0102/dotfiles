#!/bin/bash

# From swyx: functions to measure time per bash command
preexec() {
  timer=$(gdate +%s.%N)
}

precmd() {
  if [ -n "$timer" ]; then
    now=$(gdate +%s.%N)
    elapsed=$(echo "$now - $timer" | bc)
    timer_show=$(printf "%.2f" $elapsed)
    echo "Execution time: ${timer_show}s"
    unset timer
  fi
}