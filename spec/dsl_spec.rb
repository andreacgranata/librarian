require 'librarian'
require 'librarian/mock'

module Librarian
  module Mock

    describe Dsl do

      context "a single dependency but no applicable source" do

        it "should not run without any sources" do
          expect do
            Dsl.run do
              dep 'dependency-1'
            end
          end.to raise_error(Dsl::Error)
        end

        it "should not run when a block source is defined but the dependency is outside the block" do
          expect do
            Dsl.run do
              src 'source-1' do end
              dep 'dependency-1'
            end
          end.to raise_error(Dsl::Error)
        end

      end

      context "a simple specfile - a single source, a single dependency, no transitive dependencies" do

        it "should run with a hash source" do
          spec = Dsl.run do
            dep 'dependency-1',
              :src => 'source-1'
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-1'
          spec.source.should be_nil
        end

        it "should run with a shortcut source" do
          spec = Dsl.run do
            dep 'dependency-1',
              :source => :a
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-a'
          spec.source.should be_nil
        end

        it "should run with a block hash source" do
          spec = Dsl.run do
            source :src => 'source-1' do
              dep 'dependency-1'
            end
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-1'
          spec.source.should be_nil
        end

        it "should run with a block named source" do
          spec = Dsl.run do
            src 'source-1' do
              dep 'dependency-1'
            end
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-1'
          spec.source.should be_nil
        end

        it "should run with a default hash source" do
          spec = Dsl.run do
            source :src => 'source-1'
            dep 'dependency-1'
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-1'
          spec.source.should_not be_nil
          spec.dependencies.first.source.should == spec.source
        end

        it "should run with a default named source" do
          spec = Dsl.run do
            src 'source-1'
            dep 'dependency-1'
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-1'
          spec.source.should_not be_nil
          spec.dependencies.first.source.should == spec.source
        end

        it "should run with a default shortcut source" do
          spec = Dsl.run do
            source :a
            dep 'dependency-1'
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-a'
          spec.source.should_not be_nil
          spec.dependencies.first.source.should == spec.source
        end

        it "should run with a shortcut source hash definition" do
          spec = Dsl.run do
            source :b, :src => 'source-b'
            dep 'dependency-1', :source => :b
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-b'
          spec.source.should be_nil
        end

        it "should run with a shortcut source block definition" do
          spec = Dsl.run do
            source :b, proc { src 'source-b' }
            dep 'dependency-1', :source => :b
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-b'
          spec.source.should be_nil
        end

        it "should run with a default shortcut source hash definition" do
          spec = Dsl.run do
            source :b, :src => 'source-b'
            source :b
            dep 'dependency-1'
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-b'
          spec.source.should_not be_nil
          spec.source.name.should == 'source-b'
        end

        it "should run with a default shortcut source block definition" do
          spec = Dsl.run do
            source :b, proc { src 'source-b' }
            source :b
            dep 'dependency-1'
          end
          spec.dependencies.should_not be_empty
          spec.dependencies.first.name.should == 'dependency-1'
          spec.dependencies.first.source.name.should == 'source-b'
          spec.source.should_not be_nil
          spec.source.name.should == 'source-b'
        end

      end

    end

  end
end