[
  {FormatterMock, Formatter},
  {TasksMock, Solution.Day7.Behaviours.Tasks}
] |> Enum.each(fn {mock_name, module_mocked} ->
  Mox.defmock(mock_name, for: module_mocked)
end)
