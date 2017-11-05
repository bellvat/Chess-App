require 'rails_helper'

RSpec.describe "bishops/index", type: :view do
  before(:each) do
    assign(:bishops, [
      Bishop.create!(
        :parent=Piece => "Parent=Piece"
      ),
      Bishop.create!(
        :parent=Piece => "Parent=Piece"
      )
    ])
  end

  it "renders a list of bishops" do
    render
    assert_select "tr>td", :text => "Parent=Piece".to_s, :count => 2
  end
end
