class AddRatingToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :rating, :int
  end
end
