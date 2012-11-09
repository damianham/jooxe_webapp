# Jooxe configuration file

# connect to the mysql database with the sequel adapter assigning the DB constant

require 'sequel'
DB = Sequel.connect('jdbc:mysql://localhost/helios?user=test&password=test')

=begin
example connection strings
jdbc:sqlite::memory:
jdbc:postgresql://localhost/database?user=username
jdbc:mysql://localhost/test?user=root&password=root
jdbc:h2:mem:
jdbc:hsqldb:mem:mymemdb
jdbc:derby:memory:myDb;create=true
jdbc:sqlserver://localhost;database=sequel_test;integratedSecurity=true
jdbc:jtds:sqlserver://localhost/sequel_test;user=sequel_test;password=sequel_test
jdbc:oracle:thin:user/password@localhost:1521:database
jdbc:db2://localhost:3700/database:user=user;password=password;
jdbc:firebirdsql:localhost/3050:/path/to/database.fdb
jdbc:jdbcprogress:T:hostname:port:database
jdbc:cubrid:hostname:port:database:::
=end