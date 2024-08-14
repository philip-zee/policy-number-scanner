#===========================================================
#
# Author: Philip Zee
# Email:  philip.zee@gmail.com
# Date:   August 14, 2024
#
#===========================================================

import pytest
from scan_policy import is_valid, parse_file, parse_large_file

@pytest.mark.parametrize(
    "policy, expected",
    [
        (
            '123456789',
            ''
        ),
        (
            '103456789',
            'ERR'
        ),
        (
            '1?3456789',
            'ILL'
        ),
        (
            '16789',
            'ERR'
        ),
    ]
)
def test_is_valid(policy, expected):
    assert is_valid(policy) == expected


@pytest.mark.parametrize(
    "file, expected",
    [
        (
            'spec/fixtures/sample.txt',
            [ '000000000', '111111111', '222222222', '333333333', '444444444', '555555555', '666666666', '777777777', '888888888', '999999999', '123456789']
        ),
        (
            'spec/fixtures/modified_sample.txt', # No break between 1s and 2s, expect 2s to be skipped. Also, no blank line at EOF
            [ '111111111', '333333333', '444444444', '555555555', '666666666', '777777777', '888888888', '999999999', '123456789']
        ),
        (
            'spec/fixtures/single_policy_number.txt',
            ['123456789']
        ),
        (
            'spec/fixtures/short_policy_number.txt',
            ['12345????', '11?456???', '123465889']
        ),
        (
            'spec/fixtures/policy_number.txt',
            ['123456789', '103456789', '11?456789', '103?56789']
        ),
        (
            'non_exist.txt',
            []
        ),
    ]
)
def test_parse_file(file, expected):
    assert parse_file(file) == expected


@pytest.mark.parametrize(
    "file, block, expected",
    [
        (
            'spec/fixtures/sample.txt',
            2*1024,
            [ '000000000', '111111111', '222222222', '333333333', '444444444', '555555555', '666666666', '777777777', '888888888', '999999999', '123456789']
        ),
        (
            'spec/fixtures/modified_sample.txt', # No break between 1s and 2s, expect 2s to be skipped. Also, no blank line at EOF
            2*1024,
            [ '111111111', '333333333', '444444444', '555555555', '666666666', '777777777', '888888888', '999999999', '123456789']
        ),
        (
            'spec/fixtures/single_policy_number.txt',
            1024,
            ['123456789']
        ),
        (
            'spec/fixtures/short_policy_number.txt',
            512,
            ['12345????', '11?456???', '123465889']
        ),
        (
            'spec/fixtures/policy_number.txt',
            1024,
            ['123456789', '103456789', '11?456789', '103?56789']
        ),
        (
            'non_exist.txt',
            512,
            []
        ),
    ]
)
def test_parse_large_file(file, block, expected):
    assert parse_large_file(file, block) == expected
