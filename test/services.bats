#!/usr/bin/env bats
#shellcheck disable

load 'helpers/bats-support/load'
load 'helpers/bats-file/load'
load 'helpers/bats-assert/load'

s="${HOME}/dotfiles/scripting/helpers/services.bash"
base="$(basename $s)"

[ -f "$s" ] \
  && { source "$s"; trap - EXIT INT TERM ; } \
  || { echo "Can not find script to test" ; exit 1 ; }

quiet=false;              printLog=false;             verbose=false;
force=false;              dryrun=false;
debug=false;              sourceOnly=false;           args=();

ping -t 2 -c 1 1.1.1.1 &>/dev/null \
  && noint=false \
  || noint=true

setup() {

  testdir="$(temp_make)"
  curPath="$PWD"

  BATSLIB_FILE_PATH_REM="#${TEST_TEMP_DIR}"
  BATSLIB_FILE_PATH_ADD='<temp>'

  cd "${testdir}"
}

teardown() {
  cd $curPath
  temp_del "${testdir}"
}

@test "Sanity..." {
  run true

  assert_success
  assert_output ""
}

@test "_haveInternet_: true" {
  ("$noint") && skip "!! No Internet connection."
  run _haveInternet_
  assert_success
}

@test "_httpStatus_: Bad URL" {
  ("$noint") && skip "!! No Internet connection."
  run _httpStatus_ http://thereisabadurlishere.com 1
  assert_success
  assert_line --index 1 "000 Not responding within 1 seconds"
}

@test "_httpStatus_: redirect" {skip "not working yet...."
  ("$noint") && skip "!! No Internet connection."
  run _httpStatus_ https://jigsaw.w3.org/HTTP/300/301.html 3 --status -L
  assert_success
  assert_output --partial "Redirection: Moved Permanently"
}

@test "_httpStatus_: google.com" {
  ("$noint") && skip "!! No Internet connection."
  run _httpStatus_ google.com
  assert_success
  assert_output --partial "200 Successful:"
}

@test "_httpStatus_: -c" {
  ("$noint") && skip "!! No Internet connection."
  run _httpStatus_ https://natelandau.com/something/not/here/ 3 -c
  assert_success
  assert_output "404"
}

@test "_httpStatus_: --code" {
  ("$noint") && skip "!! No Internet connection."
  run _httpStatus_ www.google.com 3 --code
  assert_success
  assert_output "200"
}

@test "_httpStatus_: -s" {
  ("$noint") && skip "!! No Internet connection."
  run _httpStatus_ www.google.com 3 -s
  assert_success
  assert_output "200 Successful: OK within 3 seconds"
}

@test "_httpStatus_: --status" {
  ("$noint") && skip "!! No Internet connection."
  run _httpStatus_ www.google.com 3 -s
  assert_success
  assert_output "200 Successful: OK within 3 seconds"
}