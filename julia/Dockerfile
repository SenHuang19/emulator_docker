FROM senhuang/julia

ENV PATH="/usr/julia:${PATH}"
RUN julia -e "using Pkg; Pkg.add(\"HTTP\");Pkg.add(\"JSON\")"

ARG Script

COPY .julia/${Script}.jl /usr/myapp/${Script}.jl

