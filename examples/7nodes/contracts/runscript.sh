#!/bin/bash
geth --exec "loadScript(\"$1\")" attach ipc:/Users/peter/IdeaProjects/quorum-examples/examples/7nodes/qdata/dd1/geth.ipc