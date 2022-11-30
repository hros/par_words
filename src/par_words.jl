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

words(s::Segment) = vcat(maybeWord(s.left), s.middle, maybeWord(s.right))
words(c::Chunk) = [c.chars]

words(s::String) = words(Folds.mapreduce(processChar, ⊕, s))

end # module par_words
