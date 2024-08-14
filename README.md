# KIN Insurance Code Scanner Repository

# Table of Contents
- [Overview](#overview)
  - [Language](#language)
  - [Setup](#setup)
  - [General Design](#general-design)
  - [Extremely Large Files](#extremely-large-files)
  - [Assumptions](#assumptions)
  - [Tricky Situations](#tricky-situations)
  - [Running](#running)
  - [Tests](#tests)
- [Improvements](#improvements)
  - [Scalability](#scalability)
  - [Monitoring](#monitoring)
  - [Reporting](#reporting)
  - [Repo Setup](#repo-setup)

# Overview
## Language
Python is chosen as the programming language for this exercise, as I am a bit rusty with Ruby.
However, the same logic can be implemented with Ruby or any other language.

## Setup
Kin has an ingenious machine that helps to read policy report documents. The machine scans the paper documents for
policy numbers, and produces a file with a number of entries which each look like this:

```
    _  _     _  _ _  _  _
  | _| _||_||_ |_  ||_||_|
  ||_  _|  | _||_| ||_| _|

```
Each entry is 4 lines long, and each line has 27 characters. The first 3 lines of each
entry contain a policy number written using pipes and underscores, and the fourth
line is blank. Each policy number should have 9 digits, all of which should be in the
range 0-9. A normal file contains around 500 entries.

## General Design
Since each digit is represented by pipes and underscores in a 3x3 space, it is natural to choose a two dimensional array for it.
However, an flattened array of 9 elements would be more efficient.

Array comparison is slower than string comparison. If an array of 9 elements are compressed (joined) into a string, it would be
easier to do comparison and/or assigned. A dictionary with the compressed strings as keys makes the translation to the
digit (represented as a number of 0-9) very efficient.

Reading a file like this can feel tricky in the beginning. However, each 27 characters on the line can be divided into 9 sets of 3 characters
for each number. The key is to find the break point when the next number is encountered.

As a result, this coding exercise chooses to use an array of 9 arrays as the main data struction. Each array inside of the main array will contain
9 characters.

The code stops reaching after it reaches 27 characters for each line, thus discarding anything after it.

Check sum can be computed as follows:

```
policy number: 3 4 5 8 8 2 8 6 5
position names: d9 d8 d7 d6 d5 d4 d3 d2 d1
checksum calculation:
(d1+(2*d2)+(3*d3)+...+(9*d9)) mod 11 = 0
```

Even though the formula calculates from the last digit, it is mathatically possible to get the same result by calculating from the beginning
of the string:

```
policy number: 3 4 5 8 8 2 8 6 5
position names: d1 d2 d3 d4 d5 d6 d7 d8 d9
((9*d1)+(8*d2)+(7*d3)+...+(2*d8)+d9) mod 11 = 0
```

This computation avoids the call the reverse function.

The validation function will make sure that the policy number is exactly 9 characters long. The characters have to be digits or ?. Anything else
would return 'ERR' as result. If ? is found, 'ILL' will be returned. 'ERR' will be returned if it fails the checksum validation. Only the valid
policy number will return ''.

## Extremely Large Files
Extremely large files presents a unique problem with memory. Conventional process reads the entire file into memory before processing. This
will require machines/clusters to have more memory available than the file size. To get around the memory limitation, I am using `partial` read
from `functools` to read the content of the file in chunks.

The tricky part is the only process entire lines when a newline character is detected. The remaining will need to be processed with the next read.
But the process logic remain pretty much the same.

This exercise provides the convertional way of processing a file with function `parse_file`. However, another function `parse_large_file` is also
provided as an option. Command line argument `use_large` can be used to pass in the block size.

## Assumptions
This exercise tries not to make any assumptions. The supplied file willb e checked for existence. It is assumed that each policy number takes
up 3 lines may or may not be followed by a blank line. The code only considers the first three lines before a blank line or EOF. Any lines
after the first 3 parsed lines will be ignored.

The current design provides the ability to process 100 records within a second. This part is a bit hard to measure. The processing speed is
not only determined by the CPU and available memory. The speed is also determined by network traffic if files are to be retrieved via network.

## Tricky Situations
Simply looking for blank line to end the parsing will not work 100% of the time. In the case of `111111111`, the first line is already blank.
Also, blank lines may be missing. In this case, all the following lines should be ignored until a blank line is encountered.

End of file may be missing a blank line. It can also be missing the last of the three lines required for a policy. This is also a special case
that needs to be addressed.

## Running
Code can be run with
```
python scan_policy.py --input_files spec/fixtures/policy_number.txt --output_file parsed_policies.txt [--use_large 2]
```
Note the `input_files` parameter can take on a list of files.

For full usage:
```
> python scan_policy.py -h
usage: scan_policy.py [-h] --input_files INPUT_FILES [INPUT_FILES ...] --output_file OUTPUT_FILE [--use_large [USE_LARGE]]

optional arguments:
  -h, --help            show this help message and exit
  --input_files INPUT_FILES [INPUT_FILES ...]
                        Input files containing policy numbers
  --output_file OUTPUT_FILE
                        Output file containing scanned policy numbers with status
  --use_large [USE_LARGE]
                        Block size to process extremely large file
```

## Tests
Tests contained in this exercise only focus on unit testing. Integration tests, load tests, regressions tests are not in the scope of the project.
pytest framework is used for the unit tests.
To run tests
```
python -m pytest -vvv test/test_validator.py::test_parse_file
```
or
```
python -m pytest -vvv test/test_validator.py::test_is_valid
```
or
```
python -m pytest -vvv test/test_validator.py::test_parse_large_file
```
or
```
python -m pytest -vvv test/test_validator.py
```

# Improvements
## Scalability
The code provided is single threaded. To address scalability, a streaming architectural design can be used.
Maybe Kin has multiple ingenious machines that read millions of policy report documents. It is desirable to store the scanned documents in cloud
storage. Once a file is stored, a message queue, like Kafka, can be used to instruct downstream workers to start reading the document. A consumer
group can be created for the message queue with each consumer running in a Kubernetes pod to process the jobs. Pods can expanded when the load
is heavy and scale back is just as easy.

The result of the scanning process can also be delivered via message queues. A topic can be created for all successful scanned policies while others
can be delivered to a different topic to be processed based on business needs.

If database is used, sharding is encouraged during deployments. Some structured data can be kept in a relational database such as Postgres while
unstructured data can be store in cloud databases of choice.

Parallel processing can help with increased productivity, with the use of `Pool` in `multiprocessing`.

## Monitoring
For a process to work, monitoring should be set up to make sure hicups are addressed right away. Kubernetes can be configured for auto-scaling, but
monitoring the lag on topics consumed by Kafka consumer groups may prove to be useful in the early detection of down time.

## Reporting
Statistical reporting should include the scanning error rate at the least. Others can be implemented based on business requirements.

## Repo Setup
Additional setup like gitignore, ownership, pre-commits etc can be done when necessary.
