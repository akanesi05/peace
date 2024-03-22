class AddFavoriteGenreToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :favorite_genre, :string
  end
end
