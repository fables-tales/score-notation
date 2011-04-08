#!/usr/bin/env python

import re
import subprocess

parser = './foo'

def getActualResult(string):
	p = subprocess.Popen([ parser, string ])


def assertStartsWithNumber(f):
	firstChar = f.read(1)
	#print firstChar
	firstNum = int(firstChar)
	assert firstNum in [0,1,2,3]

def getItemFromLine(line):
	#print line,
	pattern = '([BCMRSTud]+)'
	res = re.search(pattern, line)
	#print res, res.group(0)
	if res is None:
		return None
	else:
		return res.group(0)

def getString(f):
	string = ''
	for line in f.readlines()[1:]:
		part = getItemFromLine(line)
		if part is not None:
			string += part
		else:
			# we've hit the numbers at the end
			# or maybe something's gone horribly wrong (TODO: deal with this better)
			break
	return string

def getExpectedResult(f):
	f.seek(0)
	bits = f.read().rsplit('\n', 2)
	#print bits
	lastLine = bits[1]
	#print lastLine
	expectedResult = int(lastLine)
	#print expectedResult
	return expectedResult

def test(fileName):
	f = open(fileName)
	assertStartsWithNumber(f)

	testString = getString(f)
	#print testString

	expectedResult = getExpectedResult(f)
	#print expectedResult

	actualResult = getActualResult(testString)
	#print actualResult

	assert expectedResult == actualResult

if __name__ == "__main__":
	test('test1')

