function testcase_athena.utils.add_to_array()
{
	local myarray=()
	athena.utils.add_to_array "myarray" "xpto"
	local -a expected_array=(xpto)
	athena.test.assert_array expected_array myarray
	myarray=()
	expected_array=()
	athena.test.assert_array expected_array myarray
	expected_array=(one two three)
	athena.utils.add_to_array "myarray" one two three
	athena.test.assert_array expected_array myarray

	myarray=()
	athena.test.assert_return "athena.utils.add_to_array" "myarray" "one"
}

function testcase_athena.utils.remove_from_array()
{
	local -a emptyarray=()
	athena.test.assert_return.expects_fail "athena.utils.remove_from_array" "emptyarray" "one"

	local -a myarray=(one two three)
	local -a expected_array=(one three)
	athena.utils.remove_from_array "myarray" 1
	athena.test.assert_array expected_array myarray

	athena.utils.remove_from_array "myarray" "three"
	expected_array=(one)
	athena.test.assert_array expected_array myarray
	athena.test.assert_return.expects_fail "athena.utils.remove_from_array" "myarray" "four"
	athena.test.assert_return.expects_fail "athena.utils.remove_from_array" "myarray" "on"
	athena.utils.remove_from_array "myarray" "on" 0
	expected_array=()
	athena.test.assert_array expected_array myarray

	myarray=(one "--myarg='my value with spaces'" end)
	expected_array=(one end)
	athena.utils.remove_from_array "myarray" "--myarg" 0
	athena.test.assert_array expected_array myarray

	myarray=(ten nine eight)
	expected_array=(nine eight)
	athena.utils.remove_from_array "myarray" 0 0
	athena.test.assert_array expected_array myarray

	expected_array=(eight)
	athena.utils.remove_from_array "myarray" 0 0
	athena.test.assert_array expected_array myarray

	expected_array=()
	athena.utils.remove_from_array "myarray" 0 0
	athena.test.assert_array expected_array myarray
}

function testcase_athena.utils.find_index_in_array()
{
	local -a myarray=(one two three)
	athena.test.assert_return "athena.utils.find_index_in_array" "myarray" "tw" 0
	athena.test.assert_return.expects_fail "athena.utils.find_index_in_array" "myarray" "tw" 1
	athena.test.assert_return.expects_fail "athena.utils.find_index_in_array" "myarray" "four"
	athena.test.assert_output "athena.utils.find_index_in_array" 2 "myarray" "three"

}

function testcase_athena.utils.preprend_to_array()
{
	local myarray=(two)
	athena.utils.prepend_to_array "myarray" "one"
	local -a expected_array=(one two)
	athena.test.assert_array expected_array myarray

	athena.utils.prepend_to_array "myarray" "other with spaces"
	local -a expected_array=("other with spaces" one two)
	athena.test.assert_array expected_array myarray
}

function testcase_athena.utils.set_array()
{
	local myarray=()
	athena.utils.set_array "myarray" one two three
	local -a expected_array=(one two three)
	athena.test.assert_array expected_array myarray

	local -a expected_array=()
	athena.utils.set_array "myarray"
	athena.test.assert_array expected_array myarray

	myarray=()
	athena.utils.set_array "myarray" one four "other spaced"
	local -a expected_array=(one four "other spaced")
	athena.test.assert_array expected_array myarray

	myarray=()
	athena.utils.set_array "myarray" one four --myarg="other spaced"
	local -a expected_array=(one four --myarg="other spaced")
	athena.test.assert_array expected_array myarray
}

function testcase_athena.utils.get_array()
{
	local -a myarray=(one four two)
	local -a expected_array=()
	athena.utils.get_array "myarray" "expected_array"
	athena.test.assert_array expected_array myarray
	athena.test.assert_output "athena.utils.get_array" "one four two" "myarray"
}

function testcase_athena.utils.array_pop()
{
	local -a myarray=(one two three)
	local -a expected_array=(two three)
	athena.utils.array_pop "myarray"
	athena.test.assert_array expected_array myarray

	myarray=(one two three)
	local -a expected_array=(three)
	athena.utils.array_pop "myarray" 2
	athena.test.assert_array expected_array myarray
}

function testcase_athena.utils.in_array()
{
	local -a myarray=(one two three)
	athena.test.assert_return "athena.utils.in_array" "myarray" "three"
	athena.test.assert_return.expects_fail "athena.utils.in_array" "myarray" "thr"
	athena.test.assert_return "athena.utils.in_array" "myarray" "thr" 0

	local dummy_array=("element1" "element with spaces" "--env='something'" 123)
	athena.test.assert_return "athena.utils.in_array" "dummy_array" "element1" 1
	athena.test.assert_return "athena.utils.in_array" "dummy_array" "element with spaces"
	athena.test.assert_return "athena.utils.in_array" "dummy_array" "--env='something'" 1
	athena.test.assert_return "athena.utils.in_array" "dummy_array" 123 1
	athena.test.assert_return "athena.utils.in_array" "dummy_array" 12 0
	athena.test.assert_return "athena.utils.in_array" "dummy_array" "--env" 0
	athena.test.assert_return.expects_fail "athena.utils.in_array" "dummy_array" "element1 I dont exist" 1
	athena.test.assert_return.expects_fail "athena.utils.in_array" "dummy_array" "non-existing" 1
	athena.test.assert_return.expects_fail "athena.utils.in_array" "dummy_array" "--env" 1
}

function testcase_athena.utils.validate_version()
{
	athena.test.assert_return "athena.utils.validate_version" "1.0.1" ">1.0.0"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.0.0" ">1.0.0"
	athena.test.assert_return "athena.utils.validate_version" "1.0.0" "<1.0.1"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.0.0" "<1.0.0"
	athena.test.assert_return "athena.utils.validate_version" "1.0.0" "<=1.0.1"
	athena.test.assert_return "athena.utils.validate_version" "1.0.0" "<=1.0.0"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.0.1" "<=1.0.0"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.1.1" "<=1.0.0"
	athena.test.assert_return "athena.utils.validate_version" "1.1.1" "<=2.0.0"
	athena.test.assert_return "athena.utils.validate_version" "1.0.0" ">=1.0.0"

	####
	athena.test.assert_return "athena.utils.validate_version" "1.0.0" "1.0.0"
	athena.test.assert_return "athena.utils.validate_version" "1.0.0-rc1" "1.0.0"
	athena.test.assert_return "athena.utils.validate_version" "1.1.0" "1.0.0"

	athena.test.assert_return.expects_fail "athena.utils.validate_version" "a.0.0" "2.0.0"
	athena.test.assert_return "athena.utils.validate_version" "1.0.1" "1.0.1"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.0.0" "2.0.0"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.0.1" "1.1.1"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.0.0" "1.0.1"

	athena.test.assert_return "athena.utils.validate_version" "1.0.1" ">1.0.0 <1.0.2"
	athena.test.assert_return "athena.utils.validate_version" "1.0.1" ">1.0.0 <=1.0.1"
	athena.test.assert_return.expects_fail "athena.utils.validate_version" "1.0.3" ">1.0.0 <1.0.2"

}

function testcase_athena.utils.validate_version_format()
{
	athena.test.assert_return.expects_fail "athena.utils.validate_version_format" ""
	athena.test.assert_return "athena.utils.validate_version_format" "1.2.3"
	athena.test.assert_return "athena.utils.validate_version_format" "1.2.3-rc"
	athena.test.assert_return "athena.utils.validate_version_format" "13.2.3-rc"
	athena.test.assert_return "athena.utils.validate_version_format" "13.2.35-rc"
	athena.test.assert_return "athena.utils.validate_version_format" "13.233.35-rc"
	athena.test.assert_return.expects_fail "athena.utils.validate_version_format" "a.2.3-rc"

	# with operators
	athena.test.assert_return "athena.utils.validate_version_format" ">1.0.1"
	athena.test.assert_return "athena.utils.validate_version_format" ">=1.0.1"
	athena.test.assert_return "athena.utils.validate_version_format" "<1.0.1"
	athena.test.assert_return "athena.utils.validate_version_format" "<=1.0.1"
}


function testcase_athena.utils.get_version_components()
{
	athena.test.assert_return.expects_fail "athena.utils.get_version_components" "a.a2.1"

	local -a mycomponents=()
	athena.utils.get_version_components ">1.2.3" "mycomponents"
	athena.test.assert_value ">" "${mycomponents[0]}"
	athena.test.assert_value "1" ${mycomponents[1]}
	athena.test.assert_value "2" "${mycomponents[2]}"
	athena.test.assert_value "3" "${mycomponents[3]}"

	mycomponents=()
	athena.utils.get_version_components ">=3.1" "mycomponents"
	athena.test.assert_value ">=" "${mycomponents[0]}"
	athena.test.assert_value "3" ${mycomponents[1]}
	athena.test.assert_value "1" "${mycomponents[2]}"
	athena.test.assert_value "" "${mycomponents[3]}"

	mycomponents=()
	athena.utils.get_version_components "<3" "mycomponents"
	athena.test.assert_value "<" "${mycomponents[0]}"
	athena.test.assert_value "3" ${mycomponents[1]}
	athena.test.assert_value "" "${mycomponents[2]}"
	athena.test.assert_value "" "${mycomponents[3]}"

	mycomponents=()
	athena.utils.get_version_components ">3.0.1-rc1" "mycomponents"
	athena.test.assert_value ">" "${mycomponents[0]}"
	athena.test.assert_value "3" ${mycomponents[1]}
	athena.test.assert_value "0" "${mycomponents[2]}"
	athena.test.assert_value "1" "${mycomponents[3]}"

	mycomponents=()
	athena.utils.get_version_components ">3.0.1-rc1 <3.1.0" "mycomponents"
	athena.test.assert_value ">" "${mycomponents[0]}"
	athena.test.assert_value "3" ${mycomponents[1]}
	athena.test.assert_value "0" "${mycomponents[2]}"
	athena.test.assert_value "1" "${mycomponents[3]}"
}
