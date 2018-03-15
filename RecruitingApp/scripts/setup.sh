#!/bin/bash

if [ $# -lt 1 ]
then
    echo Usage: setup.sh branchname
    exit
fi

## create a scratch org for this branch
sfdx force:org:create -s -f config/project-scratch-def.json -a $1;

## set as default scratch org
sfdx force:config:set defaultusername=$1

## push local code artifacts to scratch org
sfdx force:source:push;

## Assign Permission Set
sfdx force:user:permset:assign -n HR_Admin

## import Data
sfdx force:data:tree:import --targetusername $1 --plan data/sample-Position__c-Job_Application__c-plan.json

## run Unit tests
sfdx force:apex:test:run -l RunLocalTests -r human --wait 60 --verbose -u $1

## open org
sfdx force:org:open




