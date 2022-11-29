module par_words

using Folds
using InitialValues

abstract type WordState end

struct Chunk <: WordState
    chars::String
end

struct Segment <: WordState
    left::String
    middle::Vector{String}
    right::String
end

InitialValues.@def_monoid ⊕

⊕(a::Chunk, b::Chunk) = Chunk(a.chars * b.chars)
⊕(a::Chunk, b::Segment) = Segment(a.chars * b.left, b.middle, b.right)
⊕(a::Segment, b::Chunk) = Segment(a.left, a.middle, a.right * b.chars)
⊕(a::Segment, b::Segment) = Segment(a.left, vcat(a.middle, maybeWord(a.right * b.left), b.middle), b.right)

maybeWord(s::String) = isempty(s) ? [] : [s]

processChar(c::Char) = isspace(c) ? Segment("", [], "") : Chunk(string(c))

function words(s::String) 
    g = Folds.mapreduce(processChar, ⊕, s)
    if g isa Chunk
        return [g.chars]
    else
        return vcat(maybeWord(g.left), g.middle, maybeWord(g.right))
    end
end

str = "Here is a sesquipedalian string of words"
end # module par_words
