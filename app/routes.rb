match 'login' => 'authentication#login'
match 'logout' => 'authentication#logout'

match 'show servers' => 'servers#index'
match 'show server :id' => 'servers#show'
match 'create server' => 'servers#create'
match 'update server :id' => 'servers#update'
match 'destroy server :id' => 'servers#destroy'

match 'show loadbalancers' => 'loadbalancers#index'
match 'show loadbalancer :id' => 'loadbalancers#show'
match 'create loadbalancer' => 'loadbalancers#create'
match 'update loadbalancer :id' => 'loadbalancers#update'
match 'destroy loadbalancer :id' => 'loadbalancers#destroy'

match 'show nodes on loadbalancer :loadbalancer_id' => 'nodes#index'
match 'show node :id on loadbalancer :loadbalancer_id' => 'nodes#show'
match 'create node on loadbalancer :loadbalancer_id' => 'nodes#create'
match 'update node :id on loadbalancer :loadbalancer_id' => 'nodes#update'
match 'destroy node :id on loadbalancer :loadbalancer_id' => 'nodes#destroy'

match 'ssh :id' => 'servers#ssh'
