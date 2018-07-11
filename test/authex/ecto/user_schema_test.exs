defmodule Authex.Ecto.UserSchemaTest do
  use ExUnit.Case
  doctest Authex.Ecto.UserSchema

  alias Authex.Ecto.UserSchema
  alias Authex.Test.Ecto.Users.User

  test "user_schema/1" do
    user = %User{}

    assert Map.has_key?(user, :email)
    assert Map.has_key?(user, :current_password)
  end

  test "migration_file/1" do
    content = UserSchema.migration_file()

    assert content =~ "defmodule Authex.Repo.Migrations.CreateUsers do"
    assert content =~ "create table(:users)"
    assert content =~ "add :email, :string, null: false"
    assert content =~ "add :password_hash, :string"
    refute content =~ ":current_password"
    assert content =~ "create unique_index(:users, [:email])"

    content = UserSchema.migration_file(login_field: :username)
    assert content =~ "add :username, :string, null: false"
    assert content =~ "create unique_index(:users, [:username])"

    content = UserSchema.migration_file(context_app: :test)
    assert content =~ "defmodule Test.Repo.Migrations.CreateUsers do"
  end
end
