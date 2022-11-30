# par_words
A Parallel implementation of splitting a sentence to words based on a talk by Guy Steele: [How to Think about Parallel Programming: Not!](https://www.youtube.com/watch?v=dPK6t7echuA&t=2396s).
The original algorithm was written in [Fortress](https://en.wikipedia.org/wiki/Fortress_(programming_language)) and was ported to [Julia](https://julialang.org/) and the [JuliaFolds](https://github.com/JuliaFolds) set of parallel programming packages.

## usage
from the Julia REPL, add the package:
```julia
pkg> add https://github.com/hros/par_words.git
julia> using par_words

julia> w = par_words.words("Here is a sesquipedalian string of words")
```

## benchmarking
The internal `split` function has the same functionality, albeit sequential rather than parallel.
Comparing the performance for a large text with multiple threads:
- Start julia with 4 or 8 threads: `julia -t 4` or `julia -t 8`
- load the attached text of the bible
```julia
julia> bible = join(readlines(joinpath(dirname(pathof(par_words)), "../bible.txt")), " ");
```
- split the text to words, and measure time and resources
```julia
julia> @time pw = par_words.words(bible);
```
- compare with internal (and sequential) implementation
```julia
julia> @time sw = split(bible);
```
