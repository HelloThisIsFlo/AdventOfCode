defmodule Solution.Day8Test do
  use ExUnit.Case, async: false
  alias Solution.Day8
  alias Solution.Day8.TreeNode

  setup do
    :ok
  end

  describe "Build tree" do
    test "Single branch" do
      #   0 2 4 4
      #   ^ ^ M M
      #  | |
      # |  - 2 Metadata (M)
      # - 0 children
      assert Day8.build_tree([0, 2, 4, 4]) == %TreeNode{metadata: [4, 4], children: []}
    end

    test "Nested branches - 2 levels" do
      #   2 3 0 3 10 11 12 0 1 2 1 1 2
      #   X   X    M  M  M X   M M M M
      #   ^ ^
      #  | |
      # |  - 3 Metadata (M)
      # - 2 children
      assert Day8.build_tree([2, 3, 0, 3, 10, 11, 12, 0, 1, 2, 1, 1, 2]) ==
               TreeNode.new(
                 [1, 1, 2],
                 [
                   TreeNode.new(
                     [10, 11, 12],
                     []
                   ),
                   TreeNode.new(
                     [2],
                     []
                   )
                 ]
               )
    end

    test "Nested branches - 3 levels" do
      #   2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
      #   X   X    M  M  M X   X   M  M M M M
      #   ^ ^
      #  | |
      # |  - 3 Metadata (M)
      # - 2 children

      assert Day8.build_tree([2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]) ==
               TreeNode.new(
                 [1, 1, 2],
                 [
                   TreeNode.new(
                     [10, 11, 12],
                     []
                   ),
                   TreeNode.new(
                     [2],
                     [
                       TreeNode.new(
                         [99],
                         []
                       )
                     ]
                   )
                 ]
               )
    end
  end

  describe "Node value" do
    test "Childless node => Sum of metadata" do
      assert Day8.node_value(TreeNode.new([1, 5, 6], [])) == 1 + 5 + 6
    end

    test "Node with children => Sum of all nodes references in metadata" do
      node_c = TreeNode.new([2], [])
      node_b = TreeNode.new([10, 11, 12], [])
      node_a = TreeNode.new([1, 1, 2], [node_b, node_c])

      assert Day8.node_value(node_a) == 2 * Day8.node_value(node_b) + Day8.node_value(node_c)
    end

    test "Node with children => '0' in metadata is ignored" do
      node_b = TreeNode.new([10, 11, 12], [])
      node_a = TreeNode.new([1, 1, 0, 1], [node_b])

      assert Day8.node_value(node_a) == 3 * Day8.node_value(node_b)
    end

    test "Node with children => Skip if referencing a child node that doesn't exist" do
      node_b = TreeNode.new([10, 11, 12], [])
      # Child node 3 does not exist
      node_a = TreeNode.new([1, 3, 1], [node_b])

      assert Day8.node_value(node_a) == 2 * Day8.node_value(node_b)
    end

    test "Full tree => Sum of all nodes references in metadata recursively" do
      # 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
      # A----------------------------------
      #     B----------- C-----------
      #                      D-----

      node_d = TreeNode.new([99], [])
      node_c = TreeNode.new([2], [node_d])
      node_b = TreeNode.new([10, 11, 12], [])
      node_a = TreeNode.new([1, 1, 2], [node_b, node_c])

      expected_node_b_value = 10 + 11 + 12
      expected_node_c_value = 0
      assert Day8.node_value(node_a) == 2 * expected_node_b_value + expected_node_c_value
    end
  end

  describe "Part 1" do
    test "Example from Problem Statement" do
      # 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
      # A----------------------------------
      #     B----------- C-----------
      #                      D-----

      # 1 + 1 + 2 + 10 + 11 + 12 + 2 + 99 = 138

      assert "138" ==
               Day8.solve_part_1("""
               2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
               """)
    end
  end

  describe "Part 2" do
    test "Example from Problem Statement" do
      assert "66" ==
               Day8.solve_part_2("""
               2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
               """)
    end
  end
end
