#!/usr/bin/env python3

"""
Argument:

    one or more filepaths referring to a nation babyname data file, e.g.
        data/raw/nation/yob1999.txt
        data/raw/nation/yob2000.txt

    which contains text data like:

    Emily,F,26539
    Hannah,F,21673
    Alexis,F,19234

Output:

    Text data, e.g.

    US,F,1999,Emily,26539
"""

import csv
from pathlib import Path
from re import search as rxsearch
from sys import argv, stdout

def prepend_year_foo(filename):
    """
    Yields:
        <list of strings>, e.g. ['1899', 'Mary', 'F',  42]
    """
    fname = Path(filename)
    year = rxsearch(r'(?<=yob)\d{4}', fname.stem).group()
    with fname.open('r') as f:
        for name, sex, number in csv.reader(f):
            yield ['US', sex, year, name, number]


if __name__ == '__main__':
    for filename in argv[1:]:
        output = csv.writer(stdout)
        for row in prepend_year_foo(filename):
            output.writerow(row)
