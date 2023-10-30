class FilerTest < ActiveSupport::TestCase
    def setup
      @filer = Filer.new(
        ein: '123456789',
        name: 'Example Filer',
        address: '123 Main St',
        city: 'Anytown',
        state: 'CA',
        zip: '12345'
      )
    end
  
    test "should save with all values" do
      assert @filer.save, "Save the Filer with all values provided"
    end
  
    test "EIN should be unique in scope of name & zip (due to possible null values)" do
      @filer.ein = ""
      @filer.save
      duplicate_filer = @filer.dup
      assert_not duplicate_filer.valid?, "Can't save a Filer with a duplicate EIN"
    end
  
    test "should have the necessary fields" do
      assert_respond_to @filer, :created_at
      assert_respond_to @filer, :updated_at
      assert_respond_to @filer, :ein
      assert_respond_to @filer, :name
      assert_respond_to @filer, :address
      assert_respond_to @filer, :city
      assert_respond_to @filer, :state
      assert_respond_to @filer, :zip
    end
  
    test "should have string data type for fields" do
      assert_equal :string, Filer.columns_hash['ein'].type
      assert_equal :string, Filer.columns_hash['name'].type
      assert_equal :string, Filer.columns_hash['address'].type
      assert_equal :string, Filer.columns_hash['city'].type
      assert_equal :string, Filer.columns_hash['state'].type
      assert_equal :string, Filer.columns_hash['zip'].type
    end
  
    test "created_at and updated_at should not allow null values" do
      assert_not Filer.columns_hash['created_at'].null, "created_at should not allow null values"
      assert_not Filer.columns_hash['updated_at'].null, "updated_at should not allow null values"
    end
  end