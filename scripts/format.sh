#!/bin/sh
cd `dirname $0`
cd ../

./Pods/SwiftFormat/CommandLineTool/swiftformat FireTodo --config '.swiftformat'
