require 'rails_helper'

RSpec.describe "bishops/edit", type: :view do
  before(:each) do
    @bishop = assign(:bishop, Bishop.create!(
      :parent=Piece => "MyString"
    ))
  end

  it "renders the edit bishop form" do
    render

    assert_select "form[action=?][method=?]", bishop_path(@bishop), "post" do

      assert_select "input[name=?]", "bishop[parent=Piece]"
    end
  end
end
