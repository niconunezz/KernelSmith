

class ASTSource:

    def __init__(self, fn, signature):
        self.fn = fn
        self.signature = signature
        self.name = fn.__name__
    

    def make_ir(self):
        ...
        