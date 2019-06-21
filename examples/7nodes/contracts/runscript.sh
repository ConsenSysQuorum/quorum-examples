#!/bin/bash
geth --exec "loadScript(\"$1\")" attach ipc:${EXAMPLENODEFOLDER}/qdata/dd1/geth.ipc