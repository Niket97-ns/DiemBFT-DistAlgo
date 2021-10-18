# DiemBFT-DistAlgo

## Platform

DistAlgo Version:1.1.0b15
Python Version: 3.7
Operating systems: MacOS, Windows 10
Type of host: Laptop

## Workload Generation

The file main.da is the main driver file that reads the testcase configuration from a file 'test_cases_config.json' and drives these test cases. It creates an instance of the DiemBFT
process for each of the test cases, which in turn generates the clients, replicas and faulty
replicas for that testcase. In the run method of the DiemBFT process, the signing and verify
keys of each of the replicas and clients are generated, and the public keys are given to all
replicas. The value of number_of_requests, f and timeout are also sent to each client
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
Await statements: 8
Receive handlers: 11

## Contributions

All team members have contributed equally and thoroughly to the development of this project.
All were equally involved in bringing the modules together and running test cases.
Additionally, the following shows the major contribution of the team members to the different modules.
Aditya Nandan Bhide : block_tree, mempool, main, replica, pacemaker, timeoutInfo, timeoutMsg.
Drushti Mewada : block, client, safety, main, ledger_state, ledger_commit_info, qc, safety, vote_msg.
Niket Bhaumik Shah : ledger, leader_election, replica, client, pacemaker, util, vote_info.

## Other Comments

PSEUDOCODES:

For hashing:

Consider a list of args to be hashed together. These arguments are passed to function "createConcatString"
which converts them into a tuple and returns the pickle.dumps() output.
def createConcatString(\*args):
tuple_of_arguments <- tuple(args)
RETURN pickle.dumps(tuple_of_arguments)

The byte encoded data is sent to the function 'createDigest' for hashing.
'createDigest' uses pynacl.hash.sha256 hasher to create the digest and
RETURNS digest and message_to_be_sent

    def createDigest(msg):
        HASHER <- nacl.hash.sha256
        digest <- HASHER(msg, encoder=nacl.encoding.HexEncoder)
        message_to_be_sent <- nacl.encoding.HexEncoder.encode(msg)
        RETURN digest, message_to_be_sent

The 'checkDigest' function matches the digest with the recieved message. It creates a
digest of the received message and RETURNS true if it matches the digest which was received.

    def checkDigest(receivedMsg, digest):
        HASHER <- nacl.hash.sha256
        received_msg <- nacl.encoding.HexEncoder.decode(receivedMsg)
        RETURN True if digest == HASHER(received_msg, encoder=nacl.encoding.HexEncoder)
            Else False

For digital signatures:

The sign function converts the arguments in a tuple, uses pickle.dumps() on it, and signs it with the
users private key using pynacl's sign function.

    def sign(self, \*args):
        tuple_of_arguments <- tuple(args)
        RETURN private_key.sign(pickle.dumps(tuple_of_arguments))

Use the public key of the sender to verify the signature and the message using pynacl's verify function.
Then use pickle.loads() to retrieve the message.

    verifyKeySender.verify(P.message, P.signature)
    P = pickle.loads(P.message)

HANDLING CLIENT REQUESTS AND ACKNOWLEDGEMENTS FOR COMMITTED REQUESTS:

Client sends requests to client along with it's digest which is used for verification. Once the request
is sent, the client waits for time 't'. If it receives the acknowledgement from f+1 replicas
that its request has been committed, it sends the next request.

PSEUDOCODE for transmitting and retransmitting messages :  
 while request_number <= total_requests:
request = str(self)+"-"+str(request_number)
send(('Request', request, digest),to=replicas)

        if await(len(setof(r, received(('Reply', _), from_=r))) > self.f + 1):
            validate_replica()
            request_number += 1
            reset(received)
        elif timeout t:
            pass

CLIENTS REQUESTS HANDLING AT replicas:

The replicas uses a commit_cache , which stores the recently committed requests as a
(client_id, client_request) tuple. If the replica receives the same request(same request_number)
from the same client, it directly replies to it from the cache.
Else, it adds the tuple to the mempool , and its status is "PENDING"

PSEUDOCODE:
if receive(msg=('Request', request, message*to_hash, digest), from*=c)
validate_client()
if request_tuple in self.ledger.commit_cache:

        send(('Reply', response), to=c)
        return
    self.mempool.addTxns(request_tuple)

PSEUDOCODE FOR BRINGING VALIDATORS UPTO DATE (NOT IMPLEMENTED):

When a validator receives a block with id greater than it's current round, it broadcasts a "need_sync_up"
message to all replicas. After verifying the replica's identity, the other replicas send the "requiring sync_up" replica the following in signed message format:

1. blockTree.high_qc
2. blockTree.high_commit_qc
3. last_tc
4. ledger_file_contents
5. ledger_tree
6. pending_blocks
7. mempool

The replica will wait for a quorum of such signatures, and once it receives this, it will change its
state to the received state of the quorum

PSEUDOCODE:

if P.block.id > self.pacemaker_current_round:
broadcast("need_sync_up", to=all_replicas)

if received("need_sync_up", from=r):
verify(r)
send the above mentioned data, signed, to r
send(("sync_up_data", signature) ,to=r)

if received(("sync_up_data", signature), from = r):
verify(r)
Maintain hashmap[signature] = set of senders
if len(set) == quorum:
set objects to data retrived from signature
