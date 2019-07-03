#!/bin/bash
/usr/bin/java -Xms128M -Xmx128M -jar /Users/nicolae/Develop/java-ws/tessera/tessera-dist/tessera-app/target/tessera-app-0.10-SNAPSHOT-app.jar -configfile qdata/c4/tessera-config-09-41.json >> "qdata/logs/tessera41.log" 2>&1 &
/usr/bin/java -Xms128M -Xmx128M -jar /Users/nicolae/Develop/java-ws/tessera/tessera-dist/tessera-app/target/tessera-app-0.10-SNAPSHOT-app.jar -configfile qdata/c4/tessera-config-09-42.json >> "qdata/logs/tessera42.log" 2>&1 &
