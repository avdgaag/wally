defmodule Wally.SerializerTest do
  use ExUnit.Case, async: true
  alias Wally.Serializer

  setup do
    project = %Wally.Project{id: "1", name: "project", api_token: "bla"}
    {:ok, [project: project]}
  end

  test "it includes empty list of events when there are none", %{project: project} do
    assert Serializer.project(project)["eventIds"] == []
  end

  test "it uses camel-case keys instead of snake-case", %{project: project} do
    assert Map.has_key?(Serializer.project(project), "eventIds")
    refute Map.has_key?(Serializer.project(project), "event_ids")
  end

  test "omits API tokens from projects", %{project: project} do
    refute Map.has_key?(Serializer.project(project), :api_token)
  end

  test "it converts list of projects into hash by ID", %{project: project} do
    serialized = Serializer.projects([project])
    assert serialized["1"]["name"] == "project"
  end
end
