require 'mongo'
require 'yaml'

describe "Mongo" do

  before :each do
    @users ||= Mongo::Connection.new().db('foo').collection('users')
    @test_users ||= YAML.load_file 'users.yaml'
    @users.remove
    @users.insert(@test_users)
  end

  it "there should be 10 documents in the users collection" do
    @users.count.should == 10
  end

  describe "find [query selector] [] lets you query by:" do
    it "specifying a field's value, eg { first: 'Bertrand' }" do
      results = @users.find(:first => 'Bertrand').to_a
      results.should have(1).item
      results[0]['last'].should == "Adams"
    end

    it "using special query keys like $lt, $gt, $lte, $gte, $ne" do
      @users.find(:age => { '$gt' => 40 }).should have(6).items
    end

    it "checking for the existence of a key with $exists" do
      @users.find(first: { :$exists => false }).to_a.should be_empty
    end
  end

  describe "update {selector} {changes} upsert = false, multiple = false" do
    it "replaces all of the document's fields by default (except _id)" do
      @users.update({ first: 'Eula' }, { age: 33 })
      @users.count({ :query => { first: 'Eula' } }).should == 0
    end

    it "updates only the specified fields only if you use $set" do
      @users.update({ first: 'Eula' }, { '$set' => { age: 34 } })
      @users.find({ first: 'Eula' }).count.should == 1
    end

    it "does NOT do an upsert by default" do
      @users.update({ first: 'New User' }, { age: 19 })
      @users.find({ first: 'New User' }).count.should be_zero
    end

    it "does an upsert if you pass true as the third argument" do
      @users.update({ first: 'New User' }, { '$set' => { age: 19 } }, { :upsert => true })
      @users.find({ first: 'New User' }).count.should == 1
    end

    it "does NOT update multiple rows by default" do
      @users.update({ age: { '$gt' => 60 } }, { '$set' => { old: true } })
      @users.find({ old: true }).count.should == 1
    end

    it "does updates multiple rows when you include :multi => true" do
      @users.update({ age: { '$gt' => 60 } }, { '$set' => { old: true } }, { :multi => true })
      @users.find({ old: true }).count.should == 2
    end
  end
end
