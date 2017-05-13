defmodule Identicon do
  @moduledoc """
  Creates an Identicon from an input string.
  """

  @doc """
  Creates the Identicon.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color 
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end
  
  @doc """
  Calculates a hash of the input string using MD5.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list
    %Identicon.Image{hex: hex}
  end

  @doc """
  Creates a color from the first three hex values in the hash.
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _ ]} = image) do
    # Creat new structure basing on passed one and fill up color property
    %Identicon.Image{image | color: {r, g ,b}}
  end

  @doc """
  Builds a number grid from the hex values.
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
    hex 
      |> Enum.chunk(3)
      # passing ref to a func
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      # return new struct with existing properties and grid
      |> Enum.with_index
      %Identicon.Image{image | grid: grid}
  end

  @doc """
  *Helper function* to mirror the input row.
  """
  def mirror_row(row) do
    # ie [14, 65, 117]
    # comes back as [14, 65, 117, 65, 14]
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
  *Helper function* to filter the grid. Removes any odd hex values, returns even values in a new grid.
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # Enum.filter(grid, &(rem(&1, 2) == 0))
    grid = Enum.filter grid, fn({code, _index } = grid) -> 
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Builds a pixel map.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) -> 
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Uses erlang graphical drawer module to generate an image.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
  Saves the generated image to disk.
  """
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

end
