defmodule SandboxTest do
  use ExUnit.Case
  import Mox

  describe "Mocked" do
    setup do
      FormatterMock
      |> expect(:format_hello, 1, fn name ->
        "MOCKED HELLO #{name}"
      end)

      :ok
    end

    test "Say Hello" do
      assert "MOCKED HELLO frank" == Sandbox.hello("frank")
    end
  end

  describe "Not Mocked" do
    setup do
      FormatterMock
      |> stub_with(RealFormatter)

      :ok
    end

    test "Say Hello" do
      assert "Hello frank" == Sandbox.hello("frank")
    end
  end
end
