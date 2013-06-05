match 'login' => 'authentication#login'
match 'logout' => 'authentication#logout'

match 'show servers' => 'servers#index'
match 'show server :id' => 'servers#show'
match 'create server' => 'servers#create'
match 'update server :id' => 'servers#update'
match 'destroy server :id' => 'servers#destroy'

match 'show loadbalancers' => 'loadbalancers#index'
match 'show loadbalancer :id' => 'loadbalancers#show'
match 'create loadbalancer with node at address :ip_address' => 'loadbalancers#create'
match 'update loadbalancer :id' => 'loadbalancers#update'
match 'destroy loadbalancer :id' => 'loadbalancers#destroy'

match 'show nodes on loadbalancer :loadbalancer_id' => 'nodes#index'
match 'show node :id on loadbalancer :loadbalancer_id' => 'nodes#show'
match 'create node on loadbalancer :loadbalancer_id at address :ip_address' => 'nodes#create'
match 'update node :id on loadbalancer :loadbalancer_id' => 'nodes#update'
match 'destroy node :id on loadbalancer :loadbalancer_id' => 'nodes#destroy'

match 'show instances' => 'instances#index'
match 'show instance :id' => 'instances#show'
match 'create instance' => 'instances#create'
match 'update instance :id' => 'instances#update'
match 'destroy instance :id' => 'instances#destroy'

match 'show databases on instance :instance_id' => 'databases#index'
match 'show database :id on instance :instance_id' => 'databases#show'
match 'create database on instance :instance_id' => 'databases#create'
match 'update database :id on instance :instance_id' => 'databases#update'
match 'destroy database :id on instance :instance_id' => 'databases#destroy'

match 'ssh :id' => 'servers#ssh'
