== Jooxe

Jooxe is the zero code web application framework.

Visit http://www.jooxe.org for all the latest news and gossip.

Controller and model classes are defined dynamically from the contents of a 
schema file that you can generate from your database using the command 

rake build_schema[dbname,dbuser,dbpasswd]

where dbname == the name of the database to describe
dbuser == a database user with read access on the database
dbpasswd == the database user's password

These dynamically defined classes include all the regular CRUD methods.

However.....

You can create Controller and Model classes to redefine CRUD methods or extend
the basic CRUD behaviour.

Rendering boilerplate is also eliminated with rendering of an instance of a class 
performed by a generic view template.  Collections of instances are also rendered by a generic
view template.

However.....

You can define a view template to render an instance of a class and this is used instead of 
the generic view template and you can define a view to render a collection of instances
of a class and this is used instead of the generic collection view template.

What's the point ?

Well the long and the short of it is that all you need is your database and you have a working 
application for basic CRUD operations.  Without dynamically defined classes you would need
to create a controller, model and view templates for every database table.  This will not
be a lot of fun when there are 2000 tables in your database.

Databases have powerful features and db admins are far more capable of creating a
database than scripts in a DSL (i.e. Rails migrations).  For example you may want to include triggers
to journal modified/deleted records to a journal database.  You may want to define
foreign key constraints on fields in a table - stuff like that.  You may want to define comments
for each field in the table and a comment for the table itself.  More stuff you can't do with the
DSL.

The rake task to build the schema will work out the relationships between models based on the
foreign key constraints and the generic views will use the field comments to display tooltips in the 
create/edit form.

Furthermore.....

Given that the foreign key constraints imply that a value must belong to a range of values from another table
the form views can create an auto complete field or drop down menu using a title from the other table.  E.g

create table managers (
   id int not null auto_increment primary key,
   name varchar(255) not null comment 'the full name of the manager'
);

create table employees (
   id int not null auto_increment primary key,
   name varchar(255) not null 'the full name of the employee',
   manager_id not null comment 'foreign key on managers.id'
   key `fk_user_manager`,
   constraint `user_manager_id` foreign key (`manager_id`) references `managers`(`id`)
);


The form views will then generate an auto complete field or drop down menu to choose the
manager using the name field from the managers table as the title of the drop down menu options
or auto complete data.  Whether it is a drop down menu or an auto complete field depends
on the number of managers.  Based on a per class configurable limit if there are less than 
the limit (e.g less than 100 managers) you get a drop down - otherwise it's an auto complete
for you Jimmy.

