[
  {FormatterMock, Formatter},
  {TasksMock, Solution.Day7.Behaviours.Tasks},
  {DBMock, Solution.Day7.Behaviours.DiagramBuilder}
] |> Enum.each(fn {mock_name, module_mocked} ->
  Mox.defmock(mock_name, for: module_mocked)
end)
