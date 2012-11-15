require 'spec_helper'

describe Jooxe::Loader do
  
  it "should load models from app/models" do
    Jooxe::Loader.load_models('test/app/models/*.rb')
    expect { eval "new_class = User.new"}.not_to raise_error(NameError,"uninitialized constant User")
    expect { eval "new_class = Dummy.new"}.to raise_error(NameError,"uninitialized constant Dummy")
  end
  
  it "should load controllers from app/controllers" do
    Jooxe::Loader.load_controllers('test/app/controllers/*.rb')
    expect { eval "new_class = UsersController.new"}.not_to raise_error(NameError,"uninitialized constant  UsersController")
    expect { eval "new_class = DummydumdumsController.new"}.to raise_error(NameError,"uninitialized constant DummydumdumsController")
  end
  
  it "should load databases from test/db/*.yml" do
    Jooxe::Loader.load_databases('test/db/*.yml')
    $dbs.keys.should include('default')
    $dbs.keys.should include('plural')
    $dbs.keys.should include('prefix')
  end
  
  
end