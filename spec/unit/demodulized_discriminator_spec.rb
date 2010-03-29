require 'spec_helper'

describe DataMapper::Types::DemodulizedDiscriminator do
  before :all do
    module ::Blog
      class Article
        include DataMapper::Resource

        property :id,    Serial
        property :title, String, :required => true
        property :type,  DemodulizedDiscriminator
      end

      class Announcement < Article; end
      class Release < Announcement; end
    end

    @article_model      = Blog::Article
    @announcement_model = Blog::Announcement
    @release_model      = Blog::Release
  end

  it 'should typecast to a Model' do
    @article_model.properties[:type].typecast('Blog::Release').should equal(@release_model)
    @article_model.properties[:type].typecast('Release').should equal(@release_model)
  end
  
  it 'should dump demodulized class' do
    property = @article_model.properties[:type]
    
    property.type.dump('Blog::Release', property).should == 'Release'
    property.type.dump(@announcement_model, property).should == 'Announcement'
  end

  describe 'Model#new' do
    describe 'when provided a String discriminator in the attributes' do
      before :all do
        @resource = @article_model.new(:type => 'Blog::Release')
      end

      it 'should return a Resource' do
        @resource.should be_kind_of(DataMapper::Resource)
      end

      it 'should be an descendant instance' do
        @resource.should be_instance_of(Blog::Release)
      end
    end

    describe 'when provided a Class discriminator in the attributes' do
      before :all do
        @resource = @article_model.new(:type => Blog::Release)
      end

      it 'should return a Resource' do
        @resource.should be_kind_of(DataMapper::Resource)
      end

      it 'should be an descendant instance' do
        @resource.should be_instance_of(Blog::Release)
      end
    end

    describe 'when not provided a discriminator in the attributes' do
      before :all do
        @resource = @article_model.new
      end

      it 'should return a Resource' do
        @resource.should be_kind_of(DataMapper::Resource)
      end

      it 'should be a base model instance' do
        @resource.should be_instance_of(@article_model)
      end
    end
  end

  describe 'Model#descendants' do
    it 'should set the descendants for the parent model' do
      @announcement_model.descendants.to_a.should == [ @announcement_model, @release_model ]
    end

    it 'should set the descendants for the child model' do
      @release_model.descendants.to_a.should == [ @release_model ]
    end
  end

  describe 'Model#default_scope' do
    it "shouldn't set the default scope for root model if you want all descendants anyway" do
      @article_model.default_scope[:type].should be_nil
    end

    it 'should set the default scope for the parent model' do
      @announcement_model.default_scope[:type].should equal(@announcement_model.descendants)
    end

    it 'should set the default scope for the child model' do
      @release_model.default_scope[:type].should equal(@release_model.descendants)
    end
  end
end
