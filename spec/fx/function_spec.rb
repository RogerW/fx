require "spec_helper"
require "fx/function"

module Fx
  describe Function do
    describe "#signature" do
      context "when the function has arguments" do
        it "returns the name plus those arguments" do
          function = Function.new(
            "name" => "name",
            "definition" => "some defintion",
            "arguments" => "(a int, b int)",
          )

          expect(function.signature).to eq "name(a int, b int)"
        end
      end

      context "when the function does not have any arguments" do
        it "returns the name plus the default arguments" do
          function = Function.new(
            "name" => "name",
            "definition" => "some defintion",
            "arguments" => "",
          )

          expect(function.signature).to eq "name()"
        end
      end
    end

    describe "#<=>" do
      it "delegates to `name`" do
        function_a = Function.new(
          "name" => "name_a",
          "definition" => "some defintion",
        )
        function_b = Function.new(
          "name" => "name_b",
          "definition" => "some defintion",
        )
        function_c = Function.new(
          "name" => "name_c",
          "definition" => "some defintion",
        )

        expect(function_b).to be_between(function_a, function_c)
      end
    end

    describe "#==" do
      it "compares `name` and `definition`" do
        function_a = Function.new(
          "name" => "name_a",
          "definition" => "some defintion",
        )
        function_b = Function.new(
          "name" => "name_b",
          "definition" => "some other defintion",
        )

        expect(function_a).not_to eq(function_b)
      end
    end

    describe "#to_schema" do
      it "returns a schema compatible version of the function" do
        function = Function.new(
          "name" => "uppercase_users_name",
          "definition" => "CREATE OR REPLACE TRIGGER uppercase_users_name ...",
        )

        expect(function.to_schema).to eq <<-EOS
  create_function :uppercase_users_name, sql_definition: <<-\SQL
      CREATE OR REPLACE TRIGGER uppercase_users_name ...
  SQL
        EOS
      end
    end
  end
end
