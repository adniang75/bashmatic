load test_helper

source lib/util.sh
source lib/time.sh
source lib/is.sh
source lib/run.sh
source lib/runtime-config.sh
source lib/output.sh
source lib/runtime.sh

@test "run() with an unsuccessful command and defaults" {
  set +e
  run.set-next show-output-on 
  run "zhopa"
  code=$?
  set -e
  [[ "${code}" -ne 0 ]]
  [[ "${LibRun__LastExitCode}" -eq 127 ]]
}


@test "run() with a successful command and defaults" {
  set +e
  run.set-next show-output-off
  output=$(run "/bin/ls -al")
  clean_output=$(ascii-clean $(printf "${output}"))
  code=$?
  set -e
  [[ "${code}" -eq 0 ]]
  [[ "${LibRun__LastExitCode}" -eq 0 ]]
  [[ ${clean_output} =~ 'ls -al' ]]
}

@test "run() with a successful hidden command" {
  set +e
  run.set-next show-output-off show-command-off
  output=$(run "/bin/ls -al")
  clean_output=$(ascii-clean $(printf "${output}"))
  code=$?
  set -e
  [[ "${code}" -eq 0 ]]
  [[ "${LibRun__LastExitCode}" -eq 0 ]]
  [[ ${clean_output/\/bin\/ls/} == "${clean_output}" ]]
}

@test "inspect variables with names starting with LibRun" {
  set +e
  output=$(run.inspect-variables-that-are starting-with LibRun)
  code=$?
  set -e
  [[ "${code}" -eq 0 ]]
  [[ "${output}" =~ "LibRun__DryRun" ]]
  [[ "${output}" =~ "LibRun__Verbose" ]]
}

