#!/usr/bin/env python

import os
import re
import subprocess
import parser

TEST_FOLDER = 'tests'

def getActualResult(string):
	return parser.fsm(string)

def getFirstNum(f):
	firstChar = f.read(1)
	#print firstChar
	firstNum = int(firstChar)
	return firstNum

def assertStartNumber(num):
	assert num in [0,1,2,3]

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

def runTest(fileName):
	f = open(fileName)

	try:
		num = getFirstNum(f)
		assertStartNumber(num)

		testString = getString(f)
		#print testString

		expectedResult = getExpectedResult(f)
		#print expectedResult

		actualResult = getActualResult(str(num) + testString)
		#print actualResul
		return expectedResult == actualResult
	except:
		return False


def findTests():
	files = os.listdir(TEST_FOLDER)
	files.sort()
	return files

if __name__ == "__main__":
	for test in findTests():
		print "%s\t%s" % ( test, runTest(os.path.join(TEST_FOLDER, test)) )
