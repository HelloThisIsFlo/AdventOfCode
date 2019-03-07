defmodule Solution.Day8 do
  require Logger
  alias __MODULE__.TreeNode

  @moduledoc """
  Solution to: https://adventofcode.com/2018/day/8
  """

  @behaviour Solution

  defmodule TreeNode do
    defstruct metadata: [],
              children: []

    def new(metadata, children), do: %TreeNode{metadata: metadata, children: children}
  end


  def solve_part_1(input_as_string) do
    input_as_string
    |> build_tree_from_string()
    |> sum_all_metadata()
    |> Integer.to_string()
  end

  defp build_tree_from_string(input_as_string) do
    input_as_string
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> build_tree()
  end

  def build_tree(all_numbers) do
    {root_node_in_singleton_list, []} = build_children(1, all_numbers)
    List.first(root_node_in_singleton_list)
  end

  defp build_children(num_of_children, numbers) do
    do_build_children([], num_of_children, numbers)
  end

  defp do_build_children(children, remaining_children, numbers)

  defp do_build_children(children, 0, metadata_and_remaining_numbers),
    do: {Enum.reverse(children), metadata_and_remaining_numbers}

  defp do_build_children(children, remaining_children, numbers) do
    {[num_of_subchildren, num_of_metadata], numbers_after_header} =
      Enum.split(numbers, 2)

    {sub_children, metadata_and_remaining_numbers} =
      build_children(num_of_subchildren, numbers_after_header)

    {metadata, remaining_numbers} =
      Enum.split(metadata_and_remaining_numbers, num_of_metadata)

    node = TreeNode.new(metadata, sub_children)

    do_build_children([node | children], remaining_children - 1, remaining_numbers)
  end

  defp sum_all_metadata(tree_node) do
    children_metadata_sum =
      tree_node.children
      |> Enum.map(&sum_all_metadata(&1))
      |> Enum.sum()

    children_metadata_sum + Enum.sum(tree_node.metadata)
  end

  def node_value(%TreeNode{metadata: metadata, children: []}) do
    Enum.sum(metadata)
  end

  def node_value(%TreeNode{metadata: metadata, children: children}) do
    metadata
    |> Enum.map(&(&1 - 1))
    |> Enum.reject(&(&1 < 0))
    |> Enum.reject(&(&1 >= length(children)))
    |> Enum.map(fn node_index ->
      children
      |> Enum.at(node_index)
      |> node_value()
    end)
    |> Enum.sum()
  end

  def solve_part_2(input_as_string) do
    input_as_string
    |> build_tree_from_string()
    |> node_value()
    |> Integer.to_string()
  end
end
