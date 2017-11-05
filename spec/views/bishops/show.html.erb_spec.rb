require 'rails_helper'

RSpec.describe "bishops/show", type: :view do
  before(:each) do
    @bishop = assign(:bishop, Bishop.create!(
      :parent=Piece => "Parent=Piece"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Parent=Piece/)
  end
end
