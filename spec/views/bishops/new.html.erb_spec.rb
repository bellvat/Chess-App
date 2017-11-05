require 'rails_helper'

RSpec.describe "bishops/new", type: :view do
  before(:each) do
    assign(:bishop, Bishop.new(
      :parent=Piece => "MyString"
    ))
  end

  it "renders new bishop form" do
    render

    assert_select "form[action=?][method=?]", bishops_path, "post" do

      assert_select "input[name=?]", "bishop[parent=Piece]"
    end
  end
end
