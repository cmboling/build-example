#!/bin/bash

# codeql create
/tools/codeql/codeql database init codeql-database --language java --source-root . --begin-tracing -vvvv

# source the env vars
cat /usr/src/myapp/codeql-database/temp/tracingEnvironment/start-tracing.sh
. /usr/src/myapp/codeql-database/temp/tracingEnvironment/start-tracing.sh
env

# build code
javac HelloBelfast.java

# finalize db
/tools/codeql/codeql database finalize codeql-database

# codeql analyze with default queries
/tools/codeql/codeql database analyze codeql-database java-code-scanning.qls --format=sarif-latest --output=codeql-java-results.sarif
