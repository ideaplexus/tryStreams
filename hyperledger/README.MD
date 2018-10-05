First docker has to be installed and docker daemon running.

Installing Hyper Ledger Fabric  servers.
1.  Install python and pip
2. sudo pip install docker-compose
3.sudo docker pull hyperledger/fabric-couchdb:x86_64-1.0.4
4.sudo docker tag hyperledger/fabric-couchdb:x86_64-1.0.4 hyperledger/fabric-couchdb:latest
5.sudo docker pull hyperledger/fabric-orderer:x86_64-1.0.4
6.sudo docker tag hyperledger/fabric-orderer:x86_64-1.0.4 hyperledger/fabric-orderer:latest
7.sudo docker pull hyperledger/fabric-peer:x86_64-1.0.4
8.sudo docker tag hyperledger/fabric-peer:x86_64-1.0.4 hyperledger/fabric-peer:latest
9. sudo docker pull hyperledger/fabric-ca:x86_64-1.0.4
10. sudo docker tag hyperledger/fabric-ca:x86_64-1.0.4 hyperledger/fabric-ca:latest
11.sudo docker pull hyperledger/fabric-tools:x86_64-1.0.4
12. sudo docker tag hyperledger/fabric-tools:x86_64-1.0.4 hyperledger/fabric-tools:latest
 unzip the previously shared source code.
13.  cd fabric-sample/fabcar
 fab.tar.gz
14.  rm -rf  node_modules
15. npm  install
16.  sudo ./startFabric.sh
17.  node enrollAdmin.js
18. node server.js

19. To test it http://localhost:3000 
