require 'spec_helper'

describe DataMapper::Types::BasedDiscriminator do
  before :all do
    module ::Blog
      class Article
        include DataMapper::Resource

        property :id,    Serial
        property :title, String, :required => true
        property :type,  BasedDiscriminator
        
        class Announcement < Article
          class Release < Announcement
          end
        end
      end

    end

    @article_model      = Blog::Article
    @announcement_model = Blog::Article::Announcement
    @release_model      = Blog::Article::Announcement::Release
    
    @discriminator = @article_model.properties[:type]
  end

  it 'should typecast to a Model' do
    @discriminator.typecast('').should equal(@article_model)
    @discriminator.typecast('Announcement').should equal(@announcement_model)
    @discriminator.typecast('Announcement::Release').should equal(@release_model)
  end
  
  it 'should dump base demodulized class' do
    @discriminator.type.dump(@article_model, @discriminator).should == ''
    @discriminator.type.dump(@announcement_model, @discriminator).should == 'Announcement'
    @discriminator.type.dump(@release_model, @discriminator).should == 'Announcement::Release'
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
