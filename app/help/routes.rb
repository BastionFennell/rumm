require 'shellwords'

def self.help(path)
  match "help #{path}" => proc {|cmd|
    file_name = Shellwords.split(path).join('_')
    help_text = File.expand_path("../#{file_name}.txt", __FILE__)
    cmd.output << File.read(help_text)
  }
end

help('commands')

help('login')
help('logout')

help('show images')

help('show servers')
help('show server')
help('create server')
help('update server')
help('destroy server')

help('railsify server')

help('show loadbalancers')
help('show loadbalancer')
help('create loadbalancer')
help('update loadbalancer')
help('destroy loadbalancer')

help('show nodes on loadbalancer')
help('show node on loadbalancer')
help('create node on loadbalancer')
help('update node on loadbalancer')
help('destroy node on loadbalancer')

help('show  dbinstances')
help('show dbinstance')
help('create dbinstance')
help('update dbinstance')
help('destroy dbinstance')

help('show databases on dbinstance')
help('show database on dbinstance')
help('create database on dbinstance')
help('update database on dbinstance')
help('destroy database on dbinstance')

help('show users on dbinstance')
help('show user on dbinstance')
help('create user on dbinstance')
help('destroy user on dbinstance')

help('ssh')

help('show containers')
help('show container')
help('create container')
help('update container')
help('destroy container')

help('show files in container')
help('show file in container')
help('create file in container')
help('update file in container')
help('destroy file in container')
help('download file in container')

help('show volumes')
help('show volume')
help('create volume')
help('update volume')
help('destroy volume')

help('show attachments on server')
help('create attachment on server')
help('destroy attachment on server')
