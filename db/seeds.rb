# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
storage_urls = [
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201612429349300846_public.xml",
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201831309349303578_public.xml",
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201641949349301259_public.xml",
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201921719349301032_public.xml",
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/202141799349300234_public.xml",
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201823309349300127_public.xml",
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/202122439349100302_public.xml",
    "https://filing-service.s3-us-west-2.amazonaws.com/990-xmls/201831359349101003_public.xml"
]

storage_urls.each do |storage_url|
  p "Importing filing data from #{storage_url}"
  filing_data = HTTParty.get(storage_url)
  ImportFilingService.call(filing_data)
end