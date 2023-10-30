require 'test_helper'

class FilingTest < ActiveSupport::TestCase
  setup do
    @example_blob = {
        "CashGrantAmt" => "1000.00",
        "PurposeOfGrantTxt" => "Support education programs",
        "GrantOrContributionPurposeTxt" => "Fund for educational activities",
        "RecipientBusinessName" => { "BusinessNameLine1Txt" => "Example Recipient" },
        "USAddress" => {
        "AddressLine1Txt" => "123 Main St",
        "CityNm" => "Anytown",
        "StateAbbreviationCd" => "NY",
        "ZIPCd" => "12345"
        }
    }
  end
    
  test "should have the necessary required fields" do
    filing = Filing.new
    assert_not filing.save, "Saved the filing without required fields"
    assert_not filing.errors[:filer_id].empty?, "Missing filer_id validation"
  end

  test "should belong to a filer" do
    filer = Filer.create(name: "Filer")
    filing = Filing.new(filer: filer)
    assert_equal filer, filing.filer
  end

  test "should have appropriate column types and constraints" do
    assert_equal :datetime, Filing.columns_hash['created_at'].type
    assert_equal :datetime, Filing.columns_hash['updated_at'].type
    assert_equal :integer, Filing.columns_hash['filer_id'].type
    assert_equal :boolean, Filing.columns_hash['amended_indicator'].type
    assert_equal :datetime, Filing.columns_hash['filed_at'].type
    assert_equal :string, Filing.columns_hash['tax_period_end_at'].type
    assert_not Filing.columns_hash['created_at'].null, "created_at should not allow null values"
    assert_not Filing.columns_hash['updated_at'].null, "updated_at should not allow null values"
    assert_not Filing.columns_hash['filer_id'].null, "filer_id should not allow null values"
    assert Filing.columns_hash['amended_indicator'].null, "amended_indicator should allow null values"
    assert Filing.columns_hash['filed_at'].null, "filed_at should allow null values"
    assert Filing.columns_hash['tax_period_end_at'].null, "tax_period_end_at should allow null values"
  end

  test "should have an index on filer_id" do
    assert ActiveRecord::Base.connection.index_exists?(:filings, :filer_id)
  end

  test "should filter filings by filer_id and tax_period_end_at" do
    filer = Filer.create(name: "Filer")
    tax_period = '2023-12-31'

    filing_1 = Filing.create(filer: filer, tax_period_end_at: tax_period, created_at: Date.new(2023, 1, 1))
    filing_2 = Filing.create(filer: filer, tax_period_end_at: tax_period, created_at: Date.new(2023, 3, 15))
    filing_3 = Filing.create(filer: filer, tax_period_end_at: '2024-12-31', created_at: Date.new(2024, 1, 1))

    filings_for_year = Filing.by_filer_for_year(filer.id, tax_period)

    assert_includes filings_for_year, filing_1
    assert_includes filings_for_year, filing_2
    refute_includes filings_for_year, filing_3
  end

  test "should parse cash award amount from blob" do
    assert_equal 1000.00, Filing.parse_cash_award_amount(@example_blob)
  end

  test "should parse purpose from blob" do
    assert_equal "Support education programs", Filing.parse_purpose(@example_blob)
  end

  test "should parse filer name from blob" do
    assert_equal "Example Recipient", Filing.parse_filer_name(@example_blob, true)
  end

  test "should parse filer address from blob" do
    expected_address = ["123 Main St", "Anytown", "NY", "12345"]
    assert_equal expected_address, Filing.parse_filer_address(@example_blob)
  end
end