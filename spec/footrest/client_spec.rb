require_relative '../spec_helper'

describe Footrest::Client do
  it "sets the domain" do
    client = Footrest::Client.new(prefix: "http://domain.test")
    expect(client.prefix).to eq("http://domain.test")
  end

  it "sets the authtoken" do
    client = Footrest::Client.new(token: "test_token")
    expect(client.token).to eq("test_token")
  end

  context "join" do
    let(:client) { Footrest::Client.new }

    it "retains initial slash" do
      expect(client.send(:join, '/test', 'path')).to eq('/test/path')
    end

    it "combines multiple segments" do
      expect(client.send(:join, 'test', 'path', 'parts')).to eq('test/path/parts')
    end

    it "respects http://" do
      expect(client.send(:join, 'http://', 'path')).to eq('http://path')
    end

    it "keeps slashes within strings" do
      expect(client.send(:join, 'http://', 'domain', '/path/to/something')).
        to eq('http://domain/path/to/something')
    end
  end

  context "Request" do
    let(:client) { Footrest::Client.new }

    it "gets" do
      stub_request(:get, "http://domain.test/page?p=1").
        to_return(:status => 200, :body => "", :headers => {})
      client.get('http://domain.test/page', :p => 1)
    end

    it "deletes" do
      stub_request(:get, "http://domain.test/page?auth=xyz").
        to_return(:status => 200, :body => "", :headers => {})
      client.get('http://domain.test/page', :auth => 'xyz')
    end

    it "posts" do
      stub_request(:post, "http://domain.test/new_page").
        with(:body => {"password"=>"xyz", "username"=>"abc"}).
        to_return(:status => 200, :body => "", :headers => {})
      client.post('http://domain.test/new_page', :username => 'abc', :password => 'xyz')
    end

    it "puts" do
      stub_request(:put, "http://domain.test/update_page").
        with(:body => {"password"=>"zzz", "username"=>"aaa"}).
        to_return(:status => 200, :body => "", :headers => {})
      client.put('http://domain.test/update_page', :username => 'aaa', :password => 'zzz')
    end
  end
end