The compilation part seems to have this parts:
@jit function -> AST:

    Simply create the JIT class and decorator that redirects
    a @jit function so that the python interpreter does not 
    see it and we can manipulate it. To go from a function to its
    [AST](https://docs.python.org/3/library/ast.html) we make use
    of the AST library. With the module inspect we get the code
    inside the function and with ast.parse we get the three.  


AST -> ttir:
...

ttir -> tgir:
...

tgir -> llir:
...

llir -> ptx:
...

