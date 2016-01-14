defmodule Wally.RepoTest do
  defmodule Project do
    defstruct id: nil, name: nil, api_key: nil
  end

  defmodule Event do
    defstruct id: nil, type: nil
  end

  use ExUnit.Case
  alias Wally.Repo
  alias Exredis.Api

  setup do
    Api.flushdb
    :ok
  end

  test "counts the number of records" do
    assert Repo.count(Project) == 0
    Api.sadd("project_ids", "id1")
    assert Repo.count(Project) == 1
  end

  test "can test existence of records by ID" do
    Api.sadd("project_ids", "id1")
    assert Repo.exist?(Project, "id1")
    refute Repo.exist?(Project, "id2")
  end

  test "returns error when getting record with non-existant ID" do
    assert Repo.get(Project, "id1") == {:error, "No such ID"}
  end

  test "returns error when getting record without a key" do
    Api.sadd("project_ids", "id1")
    assert Repo.get(Project, "id1") == {:error, "Missing attributes for ID"}
  end

  test "gets a record by ID and loads details into its struct" do
    Api.sadd("project_ids", "id1")
    Api.hmset("project:id1", ["name", "test"])
    assert Repo.get(Project, "id1") == {:ok, %Project{name: "test"}}
  end

  test "returns multiple records by ID" do
    Api.sadd("project_ids", ["id1", "id2"])
    Api.hmset("project:id1", ["name", "test1"])
    Api.hmset("project:id2", ["name", "test2"])
    {:ok, [record1, record2]} = Repo.get(Project, ["id1", "id2"])
    assert record1 == %Project{name: "test1"}
    assert record2 == %Project{name: "test2"}
  end

  test "returns all records for a struct module" do
    Api.sadd("project_ids", ["id1", "id2"])
    Api.hmset("project:id1", ["name", "test1"])
    Api.hmset("project:id2", ["name", "test2"])
    {:ok, records} = Repo.all(Project)
    assert Enum.member?(records, %Project{name: "test1"})
    assert Enum.member?(records, %Project{name: "test2"})
  end

  test "fails when one of multiple records was not found" do
    Api.sadd("project_ids", ["id1", "id2"])
    Api.hmset("project:id2", ["name", "test2"])
    assert Repo.get(Project, ["id1", "id2"]) == {:error, "Missing attributes for ID"}
  end

  test "returns error when destroying a non-existant record" do
    assert Repo.destroy(%Project{id: "id1"}) == {:error, "No such ID"}
  end

  test "returns confirmation when destroying an existing record" do
    Api.sadd("project_ids", "id1")
    Api.hmset("project:id1", ["name", "test"])
    assert Repo.destroy(%Project{id: "id1"}) == :ok
    assert Api.sismember("project_ids", "id1") == "0"
    refute Api.exists("project:id1") == "0"
  end

  test "stores a struct" do
    struct = %Project{name: "new project"}
    assert Repo.persist(struct) == {:ok, %Project{id: "1", name: "new project"}}
    assert Repo.get(Project, "1") == {:ok, %Project{id: "1", name: "new project"}}
  end

  test "stores a struct and tracks an attibute in an index hash" do
    struct = %Project{name: "indexed project", api_key: "foobar"}
    assert Repo.persist(struct, [:api_key]) == {:ok, %Project{id: "1", name: "indexed project", api_key: "foobar"}}
    assert "1" == Api.hget("project:by_api_key", "foobar")
  end

  test "can find a struct by an indexed attribute value" do
    Repo.persist(%Project{name: "indexed project", api_key: "foobar"}, [:api_key])
    assert {:ok, %Project{id: "1", name: "indexed project", api_key: "foobar"}} == Repo.get_by(Project, :api_key, "foobar")
  end

  test "uses auto-incrementing ID for storing records" do
    {:ok, record1} = Repo.persist(%Project{name: "test1"})
    {:ok, record2} = Repo.persist(%Project{name: "test2"})
    assert record1.id == "1"
    assert record2.id == "2"
  end

  test "updates an existing record" do
    {:ok, record_before_update} = Repo.persist(%Project{name: "test"})
    updated_record = %Project{record_before_update | name: "test 2"}
    {:ok, record_after_update} = Repo.persist(updated_record)
    {:ok, record_reloaded} = Repo.get(Project, record_after_update.id)
    assert record_reloaded.name == "test 2"
  end

  test "updates any existing indices if they have changed" do
    {:ok, record_before_update} = Repo.persist(%Project{name: "test", api_key: "foobar"}, [:name, :api_key])
    assert 1 == Api.hexists("project:by_name", "test")
    assert 1 == Api.hexists("project:by_api_key", "foobar")
    updated_record = %Project{record_before_update | name: "test 2", api_key: "bazqux"}
    {:ok, _record_after_update} = Repo.persist(updated_record, [:name, :api_key])
    assert 0 == Api.hexists("project:by_name", "test")
    assert 0 == Api.hexists("project:by_api_key", "foobar")
    assert 1 == Api.hexists("project:by_name", "test 2")
    assert 1 == Api.hexists("project:by_api_key", "bazqux")
  end

  test "does not change existing ID for record" do
    {:ok, record_before_update} = Repo.persist(%Project{name: "test"})
    updated_record = %Project{record_before_update | name: "test 2"}
    {:ok, record_after_update} = Repo.persist(updated_record)
    {:ok, record_reloaded} = Repo.get(Project, record_after_update.id)
    assert record_after_update == record_reloaded
    assert record_reloaded.id == record_before_update.id
  end

  test "can associate two records in a has-many relationship" do
    {:ok, project} = Repo.persist(%Project{name: "test"})
    {:ok, event} = Repo.persist(%Event{type: "deployment"})
    assert Repo.associate(project, event) == :ok
    assert Api.sismember("project:1:event_ids", event.id) == "1"
  end

  test "loads all associated structs from a has-many relationship" do
    {:ok, project} = Repo.persist(%Project{name: "test"})
    {:ok, event} = Repo.persist(%Event{type: "deployment"})
    assert Repo.associate(project, event) == :ok
    assert Repo.children(project, Event) == {:ok, [event]}
  end

  test "can lookup the parent record from a child record in a belongs-to relationship" do
    {:ok, project} = Repo.persist(%Project{name: "test"})
    {:ok, event} = Repo.persist(%Event{type: "deployment"})
    :ok = Repo.associate(project, event)
    assert Repo.parent(event, Project) == {:ok, project}
  end
end
