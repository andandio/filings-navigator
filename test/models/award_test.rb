require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  test "should have the necessary required fields" do
    award = Award.new
    assert_not award.save, "Saved the award without required fields"
    assert_not award.errors[:grantmaker_id].empty?, "Missing grantmaker_id validation"
    assert_not award.errors[:filing_id].empty?, "Missing filing_id validation"
  end

  test "should belong to grantmaker, recipient, and filing" do
    grantmaker = Filer.create(name: "Grantmaker")
    recipient = Filer.create(name: "Recipient")
    filing = Filing.create(filer: grantmaker)
    
    award = Award.new(grantmaker: grantmaker, recipient: recipient, filing: filing)
    assert_equal grantmaker, award.grantmaker
    assert_equal recipient, award.recipient
    assert_equal filing, award.filing
  end

  test "should have appropriate column types" do
    assert_equal :datetime, Award.columns_hash['created_at'].type
    assert_equal :datetime, Award.columns_hash['updated_at'].type
    assert_equal :integer, Award.columns_hash['grantmaker_id'].type
    assert_equal :integer, Award.columns_hash['recipient_id'].type
    assert_equal :integer, Award.columns_hash['filing_id'].type
    assert_equal :text, Award.columns_hash['purpose'].type
    assert_equal :decimal, Award.columns_hash['cash_award'].type
    assert_equal 10, Award.columns_hash['cash_award'].precision
    assert_equal 2, Award.columns_hash['cash_award'].scale
    assert_not Award.columns_hash['created_at'].null, "created_at should not allow null values"
    assert_not Award.columns_hash['updated_at'].null, "updated_at should not allow null values"
    assert_not Award.columns_hash['grantmaker_id'].null, "grantmaker_id should not allow null values"
    assert_not Award.columns_hash['filing_id'].null, "filing_id should allow null values"
  end

  test "should have an index on filing_id" do
    assert ActiveRecord::Base.connection.index_exists?(:awards, :filing_id)
  end
end