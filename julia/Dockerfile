FROM senhuang/julia

ENV PATH="/usr/julia:${PATH}"
RUN julia -e "using Pkg; Pkg.add(\"HTTP\");Pkg.add(\"JSON\")"

ADD controllers.jl /usr/myapp/controllers.jl
ADD szvav-sup.jl /usr/myapp/szvav-sup.jl

