#!/bin/bash
set -eu

CLASSPATH=".:/work/otp/lib/jinterface/java_src"
cd java
javac -classpath "$CLASSPATH" -Xlint:deprecation *.java
