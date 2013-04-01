migration 2, :add_fields_to_accounts do
  up do
    modify_table :accounts do
      add_column :oauth_key, String
    add_column :oauth_secret, String
    end
  end

  down do
    modify_table :accounts do
      drop_column :oauth_key
    drop_column :oauth_secret
    end
  end
end
