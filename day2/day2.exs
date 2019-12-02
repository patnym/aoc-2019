defmodule OpParser do
  def parse(seq, i) when i < (length(seq) - 4) do
    case Instructions.execute(seq, i) do
      {:ok, list} -> parse(list, i+4)
      {:halt, list} -> list
    end
  end

  def parse(seq, _i) do
    seq
  end

  def parse2(seq, i1, i2) when i1 < 100  do
    list = List.replace_at(seq, 1, i1) |> List.replace_at(2, i2)
    case parse(list , 0) do
      [ 19690720 | _ ] -> { i1, i2 }
      _ -> parse2(seq, i1 + 1, i2)
    end
  end

  def parse2(seq, i1, i2) when i1 == 100 do
    parse2(seq, 0, i2 + 1)
  end
end

defmodule Instructions do
  def execute(seq, index) do
    {:ok, instruction} = Enum.fetch(seq, index)
    {:ok, indexV1} = Enum.fetch(seq, index + 1)
    {:ok, indexV2} = Enum.fetch(seq, index + 2)
    {:ok, indexV3} = Enum.fetch(seq, index + 3)
    execute(instruction, seq, {indexV1, indexV2, indexV3})
  end

  def execute(ins, seq, {i1, i2, i3}) when ins == 1 do
    {:ok, v1} = Enum.fetch(seq, i1)
    {:ok, v2} = Enum.fetch(seq, i2)
    {:ok, List.replace_at(seq, i3, v1 + v2)}
  end

  def execute(ins, seq, {i1, i2, i3}) when ins == 2 do
    {:ok, v1} = Enum.fetch(seq, i1)
    {:ok, v2} = Enum.fetch(seq, i2)
    {:ok, List.replace_at(seq, i3,   v1 * v2)}
  end

  def execute(ins, seq, {_, _, _}) when ins == 99 do
    {:halt, seq}
  end

  def execute(ins, _seq, {_, _, _}) do
    raise("Bad OP code: " <> ins)
  end
end

program = [1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,13,19,1,10,19,23,2,9,23,27,1,6,27,31,1,10,31,35,1,35,10,39,1,9,39,43,1,6,43,47,1,10,47,51,1,6,51,55,2,13,55,59,1,6,59,63,1,10,63,67,2,67,9,71,1,71,5,75,1,13,75,79,2,79,13,83,1,83,9,87,2,10,87,91,2,91,6,95,2,13,95,99,1,10,99,103,2,9,103,107,1,107,5,111,2,9,111,115,1,5,115,119,1,9,119,123,2,123,6,127,1,5,127,131,1,10,131,135,1,135,6,139,1,139,5,143,1,143,9,147,1,5,147,151,1,151,13,155,1,5,155,159,1,2,159,163,1,163,6,0,99,2,0,14,0]
code = OpParser.parse(program, 0)
IO.inspect code, label: "Code is:"

{ noun, verb } = OpParser.parse2 program, 0, 0
result = (100 * noun) + verb
IO.puts "Noun: #{noun}, Verb: #{verb}, Result: #{result}"
