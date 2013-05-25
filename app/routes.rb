match 'login' => 'authentication#login'
match 'logout' => 'authentication#logout'

match 'show servers' => 'servers#index'
match 'show server :id' => 'servers#show'
match 'create server' => 'servers#create'
match 'update server :id' => 'servers#update'
match 'destroy server :id' => 'servers#destroy'
