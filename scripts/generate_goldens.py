#!/usr/bin/python
import dependencies as deps

deps.chdir('./app_customers')

# Run the dart format test script
flutterGoldenTest = deps.run('flutter test --update-goldens --tags=golden')

# Returns the exit code returned by the dart format test Script
exit(flutterGoldenTest.returncode)