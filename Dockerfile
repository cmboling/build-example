FROM openjdk:7

# create directories
RUN mkdir /tools

# setup codeql tools
RUN wget -q https://github.com/github/codeql-action/releases/download/codeql-bundle-20210921/codeql-bundle-linux64.tar.gz
RUN tar xzf /codeql-bundle-linux64.tar.gz -C tools

# copy source
COPY src /usr/src/myapp

# set working directory
WORKDIR /usr/src/myapp

# codeql create
RUN /tools/codeql/codeql database init codeql-database --language java --source-root . --begin-tracing -vvvv

# source the env vars
RUN cat /usr/src/myapp/codeql-database/temp/tracingEnvironment/start-tracing.sh
RUN . /usr/src/myapp/codeql-database/temp/tracingEnvironment/start-tracing.sh

# build code
RUN javac HelloBelfast.java

# codeql analyze with default queries
RUN /tools/codeql/codeql database analyze codeql-database java-code-scanning.qls --format=sarif-latest --output=codeql-java-results.sarif
