from typing import Generic, TypeVar, overload
import inspect
import ast
import textwrap
from python.compiler import ASTSource


T = TypeVar("T")


class JITFunction(Generic[T]):
    
    def __init__(self, fn):
        self.fn = fn
        self.signature = inspect.signature(fn)
        # source code of fn
        self.src = textwrap.dedent(inspect.getsource(fn))

    def __getitem__(self, grid):
        
        return lambda *args, **kwargs: self.run(grid = grid, *args, **kwargs)
    
    def run(self, *args, grid, **kwargs):
        
        ...
    

    def parse(self):

        return ast.parse(self.src)



# decorator function
def jit(fn):
    def decorator(fn):
        return JITFunction(fn)

    return decorator(fn)