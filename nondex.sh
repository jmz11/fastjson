if [[ -z $TRAVIS_COMMIT_RANGE ]]; then TRAVIS_COMMIT_RANGE=$(git rev-parse master)...$(git rev-parse HEAD); fi
nondextests=$(git diff --name-status $TRAVIS_COMMIT_RANGE | grep /test/ | sed -e 's;.*test/java/;;' -e 's/.java//' -e 's;/;.;g' | tr '\n' ','); fi
echo $nondextests
if [ ! -z $nondextests ]; then mvn -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn edu.illinois:nondex-maven-plugin:1.1.2:nondex -DnondexSeed=$RANDOM -DnondexRuns=10 -DfailIfNoTests=false -Dtest=$nondextests > /dev/null 2>&1 ; fi  
if [ -d ".nondex" ]; then flakyTests=$(awk ' !x[$0]++' .nondex/*/failures); fi