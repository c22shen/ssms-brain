class AddLibraryidToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :library_id, :int
  end
end
