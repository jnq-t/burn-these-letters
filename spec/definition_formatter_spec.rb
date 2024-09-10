describe 'DefinitionFormatter' do
  require_relative '../helpers/definition_formatter.rb'
  require 'pry'

  subject { ::DefinitionFormatter }

  describe ".call" do
    let(:definition) { "text" }
    context "when the definition is a string" do
      it "symolizes is" do
        expect(subject.call(definition)).to eq definition.to_sym
      end
    end

    context "when the definition is a hash" do
      let(:formatted) do
        { :keys => ["value"] }
      end
      context "and its keys and values are already formatted" do
        it "returns the definition" do
          expect(subject.call(formatted)).to eq formatted
        end
      end

      context "its value is a string" do
        let(:definition) do
          { :keys => "value" }
        end
        it "returns the definition" do
          expect(subject.call(formatted)).to eq formatted
        end

        context "and its key is a string" do
          let(:definition) do
            { "keys" => "value"}
          end
          it "returns the definition" do
            expect(subject.call(formatted)).to eq formatted
          end
        end
      end

      context "when its key is a string" do
        let(:definition) do
          { "keys" => ["value"] }
        end
        it "returns the definition" do
          expect(subject.call(formatted)).to eq formatted
        end
      end
    end
  end
end