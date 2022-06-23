require "spec_helper"
require "jiminy/recording/n_plus_one"

RSpec.describe Jiminy::Recording::NPlusOne do
  context "when location is an RHTML template" do
    describe "#to_h" do
      it "contains the file, line, and details" do
        location_string = "app/views/users/_user.html.erb:1:in `_app_views_users__user_html_erb__2366356888272897519_876440'"
        n_plus_one = Jiminy::Recording::NPlusOne.new(location: location_string)

        hash = n_plus_one.to_h

        expect(hash).to eql({
          location_string => {
            "examples" => [],
            "file" => "app/views/users/_user.html.erb",
            "line" => "1",
            "method" => "_app_views_users__user_html_erb__2366356888272897519_876440"
          }
        })
      end
    end
  end

  context "when location is a Ruby file" do
    describe "#to_h" do
      it "contains the file, line, and details" do
        location_string = "app/models/admins/user.rb:13:in `map'"
        n_plus_one = Jiminy::Recording::NPlusOne.new(location: location_string)

        hash = n_plus_one.to_h

        expect(hash).to eql({
          location_string => {
            "examples" => [],
            "file" => "app/models/admins/user.rb",
            "line" => "13",
            "method" => "map"
          }
        })
      end
    end
  end
  context "when location is in a jbuilder file" do
    describe "#to_h" do
      it "contains the file, line, and details" do
        location_string = "app/views/widgets/_widget.json.jbuilder:3:in `block in _app_views_widgets__widget_json_jbuilder___243700433639123'"
        n_plus_one = Jiminy::Recording::NPlusOne.new(location: location_string)

        hash = n_plus_one.to_h

        expect(hash).to eql({
          location_string => {
            "examples" => [],
            "file" => "app/views/widgets/_widget.json.jbuilder",
            "line" => "3",
            "method" => "_app_views_widgets__widget_json_jbuilder___243700433639123"
          }
        })
      end
    end
  end
end
