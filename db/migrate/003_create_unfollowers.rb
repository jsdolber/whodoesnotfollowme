migration 3, :create_unfollowers do
  up do
    create_table :unfollowers do
      column :id, Integer, :serial => true
      column :avatar_url, DataMapper::Property::String, :length => 255
      column :name, DataMapper::Property::String, :length => 255
      column :screen_name, DataMapper::Property::String, :length => 255
      column :last_tweet, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :unfollowers
  end
end
