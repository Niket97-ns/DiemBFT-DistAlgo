# DiemBFT-DistAlgo

## Platform

Python Version: 3.7
Operating systems: MacOS, Windows 10
Type of host: Laptop

## Workload Generation

The file main.da is the main driver file that reads the testcase configuration from a file and drives 
these test cases. It creates an instance of the DiemBFT process for each of the test cases, which in turn
generates the clients, replicas and faulty replicas for that testcase. In the run method of the DiemBFT
process, the signing and verify keys of each of the replicas and clients are generated, and the public keys
are given to all replicas. The value of number_of_requests, f and timeout are also sent to each client
while setting it up.

## Timeouts

TODO: TBD - for now we have kept it random

## Bugs and Limitations

## Main Files

main.da
client.da
replica.da

## Code Size

Non-Blank Non-Comment lines of code in the system: 

Algorithm: 
    Replica Algorithm: 
    Other functionality interleaved within(logging, instrumentation): 
Other: 
Total: 

This count was obtained using : https://github.com/AlDanial/cloc

Rough estimate of how much of the "algorithm code" is for the algorithm, and how much
is for the other functionality interleaved within it.


## Language feature usage

#### Python
List Comprehensions: 0
Dictionary Comprehensions:
Set Comprehensions:
Aggregations:

#### DistAlgo
Quantifications: 4
Await statements: 11
Receive handlers: 11



## Contributions



## Other Comments


