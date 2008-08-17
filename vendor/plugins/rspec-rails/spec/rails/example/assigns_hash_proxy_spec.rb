require File.dirname(__FILE__) + '/../../spec_helper'

describe "AssignsHashProxy" do
  def orig_assigns
    @object.assigns
  end
  
  before(:each) do
    @object = Class.new do
      attr_accessor :assigns
    end.new
    @object.assigns = Hash.new
    @proxy = Spec::Rails::Example::AssignsHashProxy.new self do
      @object
    end
  end
  
  it "should set ivars on object using string" do
    @proxy['foo'] = 'bar'
    @object.instance_eval{@foo}.should == 'bar'
  end
  
  it "should set ivars on object using symbol" do
    @proxy[:foo] = 'bar'
    @object.instance_eval{@foo}.should == 'bar'
  end
  
  it "should access object's assigns with a string" do
    @object.assigns['foo'] = 'bar'
    @proxy[:foo].should == 'bar'
  end
  
  it "should access object's assigns with a symbol" do
    @object.assigns['foo'] = 'bar'
    @proxy[:foo].should == 'bar'
  end

  it "iterates through each element like a Hash" do
    values = {
      'foo' => 1,
      'bar' => 2,
      'baz' => 3
    }
    @proxy['foo'] = values['foo']
    @proxy['bar'] = values['bar']
    @proxy['baz'] = values['baz']
  
    @proxy.each do |key, value|
      key.should == key
      value.should == values[key]
    end
  end
  
  it "deletes the element of passed in key" do
    @object.assigns['foo'] = 'bar'
    @proxy.delete('foo').should == 'bar'
    @proxy['foo'].should be_nil
  end
  
  it "detects the presence of a key" do
    @object.assigns['foo'] = 'bar'
    @proxy.has_key?('foo').should == true
    @proxy.has_key?('bar').should == false
  end
end
