#!/usr/bin/python
import dependencies as deps

deps.chdir('./app_customers')

# Run the dart test script
dartTest = deps.run('flutter test --update-goldens --tags=golden')

# Returns the exit code returned by the dart test Script
exit(dartTest.returncode)