class AddDomainsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :domains, :json
  end
end
