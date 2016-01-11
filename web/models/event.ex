defmodule Wally.Event do
  use Timex

  @moduledoc """
  Represents an incoming external event that says something about a
  project. Examples include a deployment, failed CI build or exception report.
  """

  defstruct id: nil, type: nil, status: nil, date: nil, description: nil, subject: nil

  def github_status(%{"branches" => [%{"name" => branch}|_], "state" => state, "context" => "continuous-integration" <> _, "description" => description, "created_at" => date}) do
    {:ok, %Wally.Event{subject: branch, type: "ci", status: state, description: description, date: date}}
  end

  def github_status(%{"zen" => _, "hook_id" => _, "hook" => _}) do
    {:ignored, "Initial ping to confirm installation"}
  end

  def github_status(_) do
    {:error, "Invalid inputs"}
  end

  def errbit_exception(%{"error" => %{"error_message" => error_message, "times_occurred" => count, "last_occurred_at" => date, "project" => %{"name" => app}}}) do
    {:ok, %Wally.Event{type: "exception", subject: app, status: "exception", description: "#{error_message} (#{count})", date: date}}
  end

  def errbit_exception(_) do
    {:error, "Invalid inputs"}
  end

  def heroku_deployment(%{"app" => app, "release" => release, "git_log" => "  * " <> log, "head" => head}) do
    {:ok, %Wally.Event{type: "deployment", subject: app, status: "deployed", description: "#{log} (#{release}, #{head})", date: timestamp}}
  end

  def heroku_deployment(_) do
    {:error, "Invalid inputs"}
  end

  defp timestamp do
    {:ok, formatted_timestamp} = Date.now |> DateFormat.format("{ISOz}")
    formatted_timestamp
  end
end
