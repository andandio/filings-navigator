require "application_system_test_case"

class DashboardTableTest < ApplicationSystemTestCase
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
  test "fetches and displays filer data upon button click" do
    visit root_path 

    click_button "FILERS" 

    find("table[data-table]")

    within("table[data-table]") do
      assert_selector "th", text: "Name"
      assert_selector "th", text: "Ein"
      assert_selector "th", text: "Address"
      assert_selector "th", text: "City"
      assert_selector "th", text: "State"
      assert_selector "th", text: "Zip"
      assert_selector "td", text: "Example Filer"
      assert_selector "td", text: "123456789"
      assert_selector "td", text: "123 Main St"
      assert_selector "td", text: "Anytown"
      assert_selector "td", text: "CA"
      assert_selector "td", text: "12345"
    end
  end

  test "fetches and displays filing data upon button click" do
    visit root_path 

    click_button "FILINGS" 

    find("table[data-table]")

    within("table[data-table]") do
      assert_selector "th", text: "Filed"
      assert_selector "th", text: "Tax period end"
      assert_selector "th", text: "Award Count"
      assert_selector "th", text: "Filer"
      assert_selector "td", text: @filed.strftime('%b %m, %Y')
      assert_selector "td", text: "2023-12-31" 
      assert_selector "td", text: "1"
      assert_selector "td", text: "Example Filer"
    end
  end

  test "fetches and displays filer data upon button click" do
    visit root_path 

    click_button "AWARDS" 

    find("table[data-table]")

    within("table[data-table]") do
      assert_selector "th", text: "Cash Award"
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