require "application_system_test_case"

class FilerTest < ApplicationSystemTestCase
  def setup
    @filed = DateTime.now
    @filer = Filer.new(
        ein: '123456789',
        name: 'Example Filer',
        address: '123 Main St',
        city: 'Anytown',
        state: 'CA',
        zip: '12345'
    )
    @filing = Filing.new(
        filer_id: @filer.id,
        filed_at: @filed,
        tax_period_end_at: "2023-12-31"   
    )
    @filing.awards = [
        Award.new(grantmaker_id: @filer.id, purpose: "General Help", cash_award: 35000)
    ]
  end
  test "loads and displays filer information" do
    visit "/filers/#{@filer.id}"

    within("h2") do
      assert_text 'Example Filer'
    end

    within("h3", text: "EIN") do
      assert_text "123456789"
    end

    within("h3", text: "Address") do
      assert_text "123 Main St"
    end

    within("h3", text: "City, State ZIP") do
      assert_text "#{@filer.city}, #{@filer.state} #{@filer.zip}"
    end

    click_button @filed.year

    find("table[data-table]")

    within("table[data-table]") do
      assert_selector "th", text: "Cash award"
      assert_selector "th", text: "Purpose"
      assert_selector "th", text: "Grantmaker"
      assert_selector "th", text: "Recipient"
      assert_selector "th", text: "Filing" 
      assert_selector "td", text: "$35,000"
      assert_selector "td", text: "General Help"
      assert_selector "td", text: "Example Filer"
      assert_selector "td", text: ""
      assert_selector "td", text: "2023-12-31"
    end
  end
end