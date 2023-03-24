# Introduction 
This repo contains azure integration services demo. The infrastuctre for this demo is deployed via https://github.com/Azure/Integration-Services-Landing-Zone-Accelerator

# Implementation

## Overview

This demo implements the following scenario:

![image](https://user-images.githubusercontent.com/11030157/227463657-d78ff92a-b364-4043-8e59-5a10c85ba109.png)

## Notes

1. If not using a hosted agent pool, you will have to remove network restriction on the logic app to deploy the workflow from ADO.

2. Office365 connector requires one time manual authorization.

3. Ensure variables are set correctly. (ado/variables)