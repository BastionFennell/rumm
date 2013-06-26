## Rumm: a tasty tool for pirates and hackers

Rumm is a command line interface and API to rackspace. You can use it
to easily build and manage infrastructure for great good.


## Usage

Authenticate with rackspace

    rumm login
      username: joe
      password: ****
      logged in, credentials written to ~/.netrc
      

Now we can see the list of servers we have available:

    $ rumm show servers
    you don't have any servers, but you can create on with:
    rumm create server

Create the server:

    rackspace create server
      created server:divine-reef
        id: 52415800-8b69-11e0-9b19-734f565bc83b, hostId: e4d909c290d0fb1ca068ffaddf22cbd0, ip: 67.23.10.138, image: CentOS 5.2
        
Create the database:

    rackspace create databaseinstance #=> POST databaseintsances
      created databaseinstance:little-fork
        id: 623, username: 'username', password: 'password', databases: production

In order to allow for a multilpe server nodes, and the ability to
bring up new server nodes without changing the public IP of our
application, we'll create a load balancer to handle traffic, and then
add our server to it:

    rackspace create loadbalancer  #=> POST loadbalancers
      created loadbalancer:tranquil-snowflake
        id: 220, port: 80, protocol: http, algorithm: random, virtualIps: 10.1.1.1, fd24:f480:ce44:91bc:1af2:15ff:0000:0005

    rackspace create node on loadbalancer:tranquil-snowflake
      created node loadbalancer:tranquil-snowflake
        id: 410, address: 67.23.10.138, port: 3000, condition: ENABLED, status: ONLINE, weight: 10, type: PRIMARY
