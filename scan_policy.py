#===========================================================
#
# Author: Philip Zee
# Email:  philip.zee@gmail.com
# Date:   August 14, 2024
#
#===========================================================

import argparse
import re
from typing import List
from functools import partial

# Create a dictionary for all digits for easier lookup
NUMBER = {
    '   ' +
    '  |' +
    '  |' : 1,

    ' _ ' +
    ' _|' +
    '|_ ' : 2,

    ' _ ' +
    ' _|' +
    ' _|' : 3,

    '   ' +
    '|_|' +
    '  |' : 4,

    ' _ ' +
    '|_ ' +
    ' _|' : 5,

    ' _ ' +
    '|_ ' +
    '|_|' : 6,

    ' _ ' +
    '  |' +
    '  |' : 7,

    ' _ ' +
    '|_|' +
    '|_|' : 8,

    ' _ ' +
    '|_|' +
    ' _|' : 9,

    ' _ ' +
    '| |' +
    '|_|' : 0
}


def is_valid(policy_number: str) -> str:
    sum = 0
    index = 9

    if len(policy_number) != 9 or re.match('^(0-9?)', policy_number):
        return 'ERR'

    for char in policy_number:
        if char == '?':
            return 'ILL'
        sum += int(char) * index
        index -= 1
    if sum % 11 == 0:
        return ''
    else:
        return 'ERR'


def parse_file(filename: str) -> List[str]:
    parsed_policy_numbers = []
    # Create an array of 9 array elements
    policy_number = [[], [], [], [], [], [], [], [], []]
    parsed_lines = 0

    try:
        with open(filename, 'r') as f:
            for line in f:
                if parsed_lines >= 3 and line.strip() == '':
                    policy_number_as_string = ''
                    for item in policy_number:
                        key = ''.join(item)
                        policy_number_as_string += f'{NUMBER[key]}' if key in NUMBER else '?'

                    # Could add a check to skip policy number that contains more than 2/3 ?s
                    parsed_policy_numbers.append(policy_number_as_string)
                    policy_number = [[], [], [], [], [], [], [], [], []]
                    parsed_lines = 0
                    continue

                index = 0
                parsed_lines += 1

                # Discard as parsing is done, looking for blank line
                if parsed_lines > 3:
                    continue

                for char in line:
                    # Stop at 27th character to avoid out of array range for policy_number
                    if index >= 27:
                        continue
                    policy_number[index//3].append(char)
                    index += 1

    except FileNotFoundError:
        print(f"File {filename} not found")

    # In case the file misses the last blank line
    if parsed_lines >=3 and policy_number !=  [[], [], [], [], [], [], [], [], []]:
        policy_number_as_string = ''
        for item in policy_number:
            key = ''.join(item)
            policy_number_as_string += f'{NUMBER[key]}' if key in NUMBER else '?'
        # Could add a check to skip policy number that contains more than 2/3 ?s
        parsed_policy_numbers.append(policy_number_as_string)

    return parsed_policy_numbers


def parse_large_file(filename: str, block_size: int=1024) -> List[str]:
    parsed_policy_numbers = []
    # Create an array of 9 array elements
    policy_number = [[], [], [], [], [], [], [], [], []]
    parsed_lines = 0

    try:
        with open(filename, 'r') as f:
            f_read = partial(f.read, block_size)
            remain = ''
            for text in iter(f_read, ''):
                lines = (remain + text).split('\n')
                if len(lines) > 1:
                    for idx in range(len(lines) - 1):
                        if parsed_lines >= 3 and lines[idx].strip() == '':
                            policy_number_as_string = ''
                            for item in policy_number:
                                key = ''.join(item)
                                policy_number_as_string += f'{NUMBER[key]}' if key in NUMBER else '?'

                            # Could add a check to skip policy number that contains more than 2/3 ?s
                            parsed_policy_numbers.append(policy_number_as_string)
                            policy_number = [[], [], [], [], [], [], [], [], []]
                            parsed_lines = 0
                            continue

                        index = 0
                        parsed_lines += 1

                        # Discard as parsing is done, looking for blank line
                        if parsed_lines > 3:
                            continue

                        for char in lines[idx]:
                            # Stop at 27th character to avoid out of array range for policy_number
                            if index >= 27:
                                continue
                            policy_number[index//3].append(char)
                            index += 1

                    remain = lines[-1]
                else:
                    remain += text

    except FileNotFoundError:
        print(f"File {filename} not found")

    # In case the file misses the last blank line
    if parsed_lines >=3 and policy_number !=  [[], [], [], [], [], [], [], [], []]:
        policy_number_as_string = ''
        for item in policy_number:
            key = ''.join(item)
            policy_number_as_string += f'{NUMBER[key]}' if key in NUMBER else '?'
        # Could add a check to skip policy number that contains more than 2/3 ?s
        parsed_policy_numbers.append(policy_number_as_string)

    return parsed_policy_numbers


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_files', nargs='+', help="Input files containing policy numbers", required=True)
    parser.add_argument('--output_file', help="Output file containing scanned policy numbers with status", required=True)
    parser.add_argument('--use_large', nargs='?', help="Block size to process extremely large file", const=10, type=int)
    args = parser.parse_args()

    with open(args.output_file, 'a') as f:
        if args.use_large:
            for file in args.input_files:
                for policy in parse_large_file(file, args.use_large * 1024):
                    f.write(f"{policy}: {is_valid(policy)}\n")
        else:
            for file in args.input_files:
                for policy in parse_file(file):
                    f.write(f"{policy}: {is_valid(policy)}\n")

    print(f"Successfully processed {', '.join(args.input_files)}. Result can be see in {args.output_file}.")


if __name__ == "__main__":
    main()
