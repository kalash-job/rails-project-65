# frozen_string_literal: true

[
  'Auto',
  'Real Estate',
  'Electronics',
  'Clothing, shoes, accessories',
  'Beauty and Health'
].each do |name|
  category = Category.create!(name:)
  Rails.logger.debug { "Added category #{category.name}" }
end

10.times do
  User.create!(name: Faker::Name.name, email: Faker::Internet.unique.email)
end

directories = {
  'Auto' => 'auto',
  'Real Estate' => 'real_estate',
  'Electronics' => 'electronics',
  'Clothing, shoes, accessories' => 'clothing_shoes',
  'Beauty and Health' => 'beauty_health'
}

User.all.each do |user|
  Category.all.each do |category|
    image_filename = "image#{(1..3).to_a.sample}.jpg"
    dir_name = directories[category.name]

    Rails.root.join('test', 'fixtures', 'files', dir_name, image_filename).open do |file|
      bulletin = user.bulletins.build(
        title: Faker::Commerce.product_name.truncate(50),
        description: Faker::Lorem.paragraph_by_chars(number: 350),
        category_id: category.id
      )
      bulletin.image.attach(io: file, filename: "#{user.id}_#{category.id}_#{image_filename}", content_type: 'image/jpeg')
      bulletin.save!
      sleep 1
    end
  end
end
