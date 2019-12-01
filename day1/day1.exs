defmodule Calculator do
    def calculateRecursiveFuel(fuel) do
        calculateRecursiveFuel calculateFuel(fuel), 0
    end

    def calculateRecursiveFuel(fuel, accumilator) when fuel > 0 do
        fuel_need = calculateFuel fuel
        calculateRecursiveFuel fuel_need, accumilator + fuel
    end

    def calculateRecursiveFuel(fuel, accumilator) when fuel <= 0 do
        accumilator
    end

    def calculateFuel(fuel) do
        Float.round(fuel / 3 - 0.5) - 2
    end
end

{:ok, text} = File.read "fuel_values.txt"
fuel_values = Enum.map String.split(text, "\n"), fn(x) -> String.to_integer(x) end

IO.puts Enum.reduce fuel_values, 0, fn(fuel, acc) -> acc + Calculator.calculateFuel(fuel) end
IO.puts Enum.reduce fuel_values, 0, fn(fuel, acc) -> acc + Calculator.calculateRecursiveFuel(fuel) end
