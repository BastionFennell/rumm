require "spec_helper"

describe "interactive learning" do
  use_natural_assertions
  describe "the basic help system" do
    Given {rumm "help"}
    Then { stdout.match "Rumm: A tasty tool for hackers and pirates" }

    # Rumm: A tasty tool for hackers and pirates
    #   Rumm provides a command line interface for hacking with Rackspace. The
    #   only thing you'll need to get started is a username and password from
    #   your Rackspace hosting account. e.g.
    #
    #     rumm login
    #     Username: rsteveson
    #     Password: ******
    #     logged in as rstevenson, credentials written to ~/.rummrc
    #
    #   And you're good to go! The following commands are available in your Rumm
    #   environment:
    #
    # Authentication:
    #   rumm login
    #   rumm logout
    #
    # Images:
    #   show images
    #   rum show images
    #
    # Servers:
    #   rumm show servers
    #   rumm show server :id
    #   rumm create server
    #   rumm update server :id
    #   rumm destroy server :id
    #   rumm ssh :id

    # Loadbalancers:
    #   rumm show loadbalancers
    #   rumm show loadbalancer :id
    #   rumm create loadbalancer
    #   rumm update loadbalancer :id
    #   rumm destroy loadbalancer :id
    #
    # Nodes:
    #   rumm show nodes on loadbalancer :loadbalancer_id
    #   rumm show node :id on loadbalancer :loadbalancer_id
    #   rumm create node on loadbalancer :loadbalancer_id
    #   rumm update node :id on loadbalancer :loadbalancer_id
    #   rumm destroy node :id on loadbalancer :loadbalancer_id
    #
    # Dbinstances:
    #   rumm show dbinstances
    #   rumm show dbinstance :id
    #   rumm create dbinstance
    #   rumm update dbinstance :id
    #   rumm destroy dbinstance :id
    #
    # Databases:
    #   rumm show databases on dbinstance :instance_id
    #   rumm show database :id on dbinstance :instance_id
    #   rumm create database on dbinstance :instance_id
    #   rumm update database :id on dbinstance :instance_id
    #   rumm destroy database :id on dbinstance :instance_id
    #
    # Users:
    #   rumm show users on dbinstance :dbinstance_id
    #   rumm show user :id on dbinstance :dbinstance_id
    #   rumm create user on dbinstance :dbinstance_id
    #
    # Containers:
    #   rumm show containers
    #   rumm show container :id
    #   rumm create container
    #   rumm update container :id
    #   rumm destroy container :id
    #
    # Files:
    #   rumm show files in container :container_id
    #   rumm show file :id on container :container_id
    #   rumm create file :id on container :container_id
    #   rumm update file :id on container :container_id
    #   rumm destroy file :id on container :container_id
    #   rumm download file :id on container :container_id
    #
    # Volumes:
    #   rumm show volumes
    #   rumm show volume :id
    #   rumm create volume
    #   rumm update volume :id
    #   rumm destroy volume :id
    #
    # Attachments:
    #   rumm show attachments on server :server_id
    #   rumm attach volume :id to server :server_id
    #   rumm detach volume :id from server :server_id

    #
    #> With aggretate help topic per controller e.g. one listing for all server commands
  end

  describe "help in a group" do
    Given { pending }
    Given {rumm "help servers"}
    # Description:
    #   Rumm allows you to manipulate all of your cloud servers from the command line
    #   including creating, listing, updating and destroying them.
    # Commands:
    #   rumm show servers
    #   rumm create server
    #   rumm show server ID
    #   rumm destroy server ID

  end

  describe "the error message when the input is invalid" do
    #> What does error look like when you're missing a required argument?
    #
    #  rumm destroy server
    #  missing required argument(s) :id
    #  run `rumm help destroy server` for a complete listing of options.
    #
    #> What is the error when a server doesn't exist?
    #  rumm destroy server does-not-exist
    #  no such server named 'does-not-exist'

    #> what is error when you're missing an option or the option is invalid?
    # e.g.
    #  rumm create loadbalancer --node 10.0.0.1:-100 --node xxx:80 --port -1
    #  input:
    #  --port: `-1` is not a valid port number (port >= 0 && port <= 65535)
    #  --nodes[0][port] `-100` is not a valid port number (port >= 0 && port <= 65535)
    #  errors:
    #  --nodes[1][address]: 'xxx' -> IPAddr::InvalidAddressError: invalid address

    Given {rumm "create loadbalancer --node 10.0.0.1:999999 --node %%^:80 --port=-1"}
    Then { stderr.match  "port: must be between 0 and 65,535" }
    Then { stderr.match  /nodes\[0\].port: must be between 0 and 65,535/ }
    Then { stderr.match  /nodes\[1\].address:/}
  end

  #> Show all commands


  #> there is a partial match but no command

  # rumm show
  # no command found for 'rum show'. Possible matches are
  #   rumm show servers
  #   rumm show server :id
  #   rumm show dbinstances
  # ...

  #> show a single action / command>
  describe "help for a specific command" do
    Given { pending }
    Given {rumm "help create server"}

    # Usage:
    #   rumm create server [--name STRING] [--image-id STRING] [--flavor-id STRING]
    #
    # Options:
    #   -n, --name STRING               # Name to give the new server
    #   -i, --image-id STRING           # use this VM image
    #   -f, --flavor-id STRING          # create with the specified flavor
    #
    # Description:
    #   creates a new next-generation rackspace cloud server. If you do not
    #   specify a name, then one will be provided for you. The name can be
    #   to identify this server for other commands.
    #
    # Examples:
    #   rumm create server
    #   rumm create server --name rumm-example-server
    #   rumm create server --image-id 9922a7c7-5a42-4a56-bc6a-93f857ae2346 --flavor-id 3

    Given { rumm "help show server" }

    # Usage:
    #   rumm show server ID
    #
    # Arguments:
    #   ID: STRING                      # Name of the server to show
    #
    # Description:
    #   Looks up the server named ID and returns its details including ipaddress
    #   etc.
    #

  end
end
