defmodule Wally.Serializer do
  alias Wally.Repo

  def projects(structs) when is_list(structs) do
    structs
    |> Enum.map(&project/1)
    |> group_by_id
  end

  def project(struct) when is_map(struct) do
    struct
    |> add_event_ids
    |> camelize_keys
  end

  def events(structs) when is_list(structs) do
    structs
    |> Enum.map(&event/1)
    |> group_by_id
  end

  def event(struct) when is_map(struct) do
    struct
    |> add_project_id
    |> camelize_keys
  end

  defp add_event_ids(record) do
    Map.put(record, :event_ids, Repo.child_ids(record, Event))
  end

  defp add_project_id(record) do
    Map.put(record, :project_id, Repo.parent_id(record, Project))
  end

  defp group_by_id(records) do
    for record <- records, into: %{} do
      {record["id"], record}
    end
  end

  defp camelize_keys(record) do
    for {key, value} <- Map.from_struct(record), into: %{} do
      [first | rest] = key
      |> to_string
      |> Phoenix.Naming.camelize
      |> String.graphemes
      camelized_key = [String.downcase(first) | rest] |> Enum.join("")
      {camelized_key, value}
    end
  end
end
